# 高维数据分析 Assignment 2：可逐段运行的完整 R 源代码
# 建议：在 RStudio 打开本文件，将工作目录设为本文件所在文件夹。
# 初次使用只需安装这两个额外包：
# install.packages(c("glmnet", "gglasso"))
# 其余函数来自 R 自带的 stats、utils、graphics 和 splines。

set.seed(2026)
options(digits = 10)

# 如果从上一级文件夹运行，自动定位到本文件夹；不改变数据行序。
if (!file.exists("data/ais.csv") && file.exists("HW2_Study_Package/data/ais.csv")) {
  setwd("HW2_Study_Package")
}
stopifnot(file.exists("data/ais.csv"))
dir.create("results", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)

library(splines)
library(glmnet)
library(gglasso)

salary <- read.csv("data/salary.csv")
wblake <- read.csv("data/wblake.csv")
ais <- read.csv("data/ais.csv")
split <- read.csv("data/ais_split.csv")

# factor 的第一个 level 是参照类别。
salary$rank <- factor(salary$rank, levels = c("Asst", "Assoc", "Prof"))
salary$degree <- factor(salary$degree, levels = c("Masters", "PhD"))
salary$sex <- factor(salary$sex, levels = c("Male", "Female"))

# 两个小工具：仅负责统一保存结果，不改变统计计算。
save_table <- function(x, filename, row.names = FALSE) {
  write.csv(x, file.path("results", filename), row.names = row.names)
  print(x)
}
coef_table <- function(model) {
  data.frame(term = names(coef(model)), coefficient = unname(coef(model)))
}
# 题目使用的 BIC：省略公共常数；q 包括截距。
model_score <- function(model) {
  n <- nobs(model)
  q <- model$rank
  rss <- sum(resid(model)^2)
  tss <- sum((model.response(model.frame(model)) -
                mean(model.response(model.frame(model))))^2)
  data.frame(q = q, RSS = rss,
             adjusted_R2 = 1 - (rss / (n - q)) / (tss / (n - 1)),
             AIC = n * log(rss / n) + 2 * q,
             BIC = n * log(rss / n) + q * log(n))
}
colors <- c("#2463A0", "#C97522", "#777B32", "#AA4C75", "#5755A0")

# ============================================================
# 第 1 题：分类变量回归
# ============================================================
cat("\n========== Problem 1 ==========\n")
save_table(as.data.frame(table(salary$rank)), "q1_rank_counts.csv")
save_table(as.data.frame(table(salary$degree)), "q1_degree_counts.csv")

fit1 <- lm(salary ~ rank + degree, data = salary)
save_table(coef_table(fit1), "q1_coefficients.csv")
save_table(model_score(fit1), "q1_metrics.csv")

# 直接看设计矩阵，理解三个虚拟变量是如何生成的。
print(head(model.matrix(fit1)))

# 换参照类别后，系数会变，但拟合值与 RSS 不变。
salary_ref <- salary
salary_ref$rank <- relevel(salary_ref$rank, ref = "Prof")
salary_ref$degree <- relevel(salary_ref$degree, ref = "PhD")
fit1_ref <- lm(salary ~ rank + degree, data = salary_ref)
stopifnot(max(abs(fitted(fit1) - fitted(fit1_ref))) < 1e-8)

# ============================================================
# 第 2 题：1 至 5 阶多项式，使用原始幂基底 1,x,x^2,...
# ============================================================
cat("\n========== Problem 2 ==========\n")
poly_fits <- vector("list", 5)
poly_metrics <- data.frame()
poly_coefs <- data.frame()
grid <- data.frame(Scale = seq(min(wblake$Scale), max(wblake$Scale), length.out = 500))

for (d in 1:5) {
  # 将阶数写进公式本身，避免循环结束后 d 改变影响 predict。
  form <- as.formula(paste0("Length ~ poly(Scale, degree = ", d, ", raw = TRUE)"))
  fit <- lm(form, data = wblake)
  poly_fits[[d]] <- fit
  poly_metrics <- rbind(poly_metrics, data.frame(degree = d, model_score(fit)))
  poly_coefs <- rbind(poly_coefs,
                      data.frame(degree = d, power = 0:d, coefficient = unname(coef(fit))))
}
save_table(poly_metrics, "q2_metrics.csv")
save_table(poly_coefs, "q2_coefficients.csv")
best_degree <- poly_metrics$degree[which.min(poly_metrics$BIC)]
cat("BIC-selected degree:", best_degree, "\n")

png("figures/q2_polynomial.png", width = 1500, height = 1000, res = 160)
par(mar = c(4.5, 4.5, 3, 1))
# 坐标范围同时覆盖观测和拟合值，避免一次直线在右上角被裁掉。
poly_grid_predictions <- sapply(poly_fits, predict, newdata = grid)
plot(Length ~ Scale, data = wblake, pch = 16, cex = 0.6,
     col = adjustcolor("#536273", alpha.f = 0.35),
     ylim = range(c(wblake$Length, poly_grid_predictions)),
     xlab = "Scale radius (mm)", ylab = "Fish length (mm)",
     main = "Polynomial regression: degrees 1 to 5")
for (d in 1:5) lines(grid$Scale, predict(poly_fits[[d]], newdata = grid),
                    col = colors[d], lty = d, lwd = 2)
legend("topleft", paste("Degree", 1:5), col = colors, lty = 1:5, lwd = 2, bty = "n")
dev.off()

# ============================================================
# 第 3 题：样条
# ============================================================
cat("\n========== Problem 3 ==========\n")
knots <- as.numeric(quantile(wblake$Scale, probs = c(0.25, 0.50, 0.75), type = 7))
boundary <- range(wblake$Scale)
print(knots)

fit3_poly <- poly_fits[[3]]
fit3_bs <- lm(Length ~ bs(Scale, degree = 3, knots = knots,
                         Boundary.knots = boundary, intercept = FALSE), data = wblake)
fit3_ns <- lm(Length ~ ns(Scale, knots = knots,
                         Boundary.knots = boundary, intercept = FALSE), data = wblake)
# cv=FALSE 表示用 GCV 选择平滑参数。不是人为固定 df。
fit3_smooth <- smooth.spline(wblake$Scale, wblake$Length, cv = FALSE)

spline_metrics <- data.frame(
  model = c("Cubic polynomial", "Cubic regression spline", "Natural cubic spline", "Smoothing spline (GCV)"),
  RSS = c(sum(resid(fit3_poly)^2), sum(resid(fit3_bs)^2), sum(resid(fit3_ns)^2),
          sum((wblake$Length - predict(fit3_smooth, x = wblake$Scale)$y)^2)),
  columns_including_intercept = c(ncol(model.matrix(fit3_poly)), ncol(model.matrix(fit3_bs)),
                                  ncol(model.matrix(fit3_ns)), NA),
  effective_df = c(fit3_poly$rank, fit3_bs$rank, fit3_ns$rank, fit3_smooth$df))
save_table(spline_metrics, "q3_metrics.csv")
save_table(data.frame(knot = c("min", "Q25", "Q50", "Q75", "max"),
                      value = c(boundary[1], knots, boundary[2])), "q3_knots.csv")
save_table(data.frame(spar = fit3_smooth$spar, lambda = fit3_smooth$lambda,
                      effective_df = fit3_smooth$df, GCV = fit3_smooth$cv.crit),
           "q3_smoothing_parameters.csv")

png("figures/q3_splines.png", width = 1500, height = 1000, res = 160)
par(mar = c(4.5, 4.5, 3, 1))
plot(Length ~ Scale, data = wblake, pch = 16, cex = 0.6,
     col = adjustcolor("#536273", alpha.f = 0.35),
     xlab = "Scale radius (mm)", ylab = "Fish length (mm)", main = "Four nonlinear regression fits")
abline(v = knots, lty = 3, col = "#D4D9DF")
lines(grid$Scale, predict(fit3_poly, newdata = grid), col = colors[1], lwd = 2, lty = 1)
lines(grid$Scale, predict(fit3_bs, newdata = grid), col = colors[2], lwd = 2, lty = 2)
lines(grid$Scale, predict(fit3_ns, newdata = grid), col = colors[3], lwd = 2, lty = 3)
lines(grid$Scale, predict(fit3_smooth, x = grid$Scale)$y, col = colors[4], lwd = 2, lty = 4)
legend("topleft", spline_metrics$model, col = colors[1:4], lty = 1:4, lwd = 2, bty = "n", cex = 0.85)
dev.off()

# ============================================================
# 第 4 题：标准化、PCA 与主成分回归
# ============================================================
cat("\n========== Problem 4 ==========\n")
vars9 <- c("Ht", "Wt", "BMI", "RCC", "WCC", "Hc", "Hg", "Ferr", "SSF")
# prcomp 的 scale.=TRUE 使用样本标准差，即分母 n-1。
pca <- prcomp(ais[, vars9], center = TRUE, scale. = TRUE)
save_table(data.frame(variable = vars9, pca$rotation[, 1:3]), "q4_loadings.csv")
variance_ratio <- pca$sdev^2 / sum(pca$sdev^2)
save_table(data.frame(PC = paste0("PC", 1:3), eigenvalue = pca$sdev[1:3]^2,
                      proportion = variance_ratio[1:3], cumulative = cumsum(variance_ratio)[1:3]),
           "q4_variance.csv")
pc_data <- data.frame(Bfat = ais$Bfat, pca$x[, 1:3])
fit4 <- lm(Bfat ~ PC1 + PC2 + PC3, data = pc_data)
save_table(coef_table(fit4), "q4_pcr_coefficients.csv")
save_table(data.frame(R2 = summary(fit4)$r.squared), "q4_pcr_R2.csv")

# ============================================================
# 第 5 题：交互作用、秩与三个模型选择准则
# ============================================================
cat("\n========== Problem 5 ==========\n")
cross_counts <- as.data.frame(xtabs(~ sex + rank + degree, data = salary))
save_table(cross_counts, "q5_cross_counts.csv")
forms5 <- list(
  M0 = salary ~ 1,
  M1 = salary ~ sex + rank + degree,
  M2 = salary ~ sex + rank + degree + sex:rank,
  M3 = salary ~ sex + rank + degree + rank:degree,
  M4 = salary ~ sex + rank + degree + sex:degree,
  M5 = salary ~ sex + rank + degree + sex:rank + rank:degree + sex:degree,
  M6 = salary ~ sex * rank * degree)
fits5 <- lapply(forms5, function(f) lm(f, data = salary))
metrics5 <- do.call(rbind, lapply(names(fits5), function(name) {
  fit <- fits5[[name]]
  data.frame(model = name, nominal_columns = ncol(model.matrix(fit)), model_score(fit))
}))
save_table(metrics5, "q5_model_comparison.csv")
for (metric in c("adjusted_R2", "AIC", "BIC")) {
  v <- metrics5[[metric]]
  optimum <- if (metric == "adjusted_R2") max(v) else min(v)
  cat(metric, "winner(s):", paste(metrics5$model[abs(v - optimum) < 1e-8], collapse = ", "), "\n")
}
# 查看哪些系数无法独立估计；M6 的名义列数与实际秩可能不同。
save_table(data.frame(term = names(coef(fits5$M6)), coefficient = unname(coef(fits5$M6)),
                      independently_estimated = !is.na(coef(fits5$M6))),
           "q5_full_model_identifiability.csv")

# ============================================================
# 第 6 题：用同一个 BIC 作前向、后向与双向选择
# ============================================================
cat("\n========== Problem 6 ==========\n")
ais6 <- ais
ais6$Sex <- factor(ais6$Sex, levels = c(0, 1))
vars10 <- c(vars9, "Sex")
full_formula <- reformulate(vars10, response = "Bfat")
null6 <- lm(Bfat ~ 1, data = ais6)
full6 <- lm(full_formula, data = ais6)
k_bic <- log(nrow(ais6))

# step 的参数名仍叫 k；k=log(n) 才按 BIC，而默认 k=2 是 AIC。
fs <- step(null6, scope = list(lower = ~ 1, upper = full_formula),
           direction = "forward", k = k_bic, trace = 0)
be <- step(full6, scope = list(lower = ~ 1, upper = full_formula),
           direction = "backward", k = k_bic, trace = 0)
both <- step(null6, scope = list(lower = ~ 1, upper = full_formula),
             direction = "both", k = k_bic, trace = 0)
fits6 <- list(FS = fs, BE = be, FS_BE = both)
for (name in names(fits6)) {
  fit <- fits6[[name]]
  cat("\n", name, "\n")
  save_table(fit$anova, paste0("q6_path_", name, ".csv"), row.names = TRUE)
  save_table(coef_table(fit), paste0("q6_coefficients_", name, ".csv"))
}
metrics6 <- do.call(rbind, lapply(names(fits6), function(name) {
  fit <- fits6[[name]]
  data.frame(method = name, formula = paste(deparse(formula(fit)), collapse = " "), model_score(fit))
}))
save_table(metrics6, "q6_final_models.csv")

# ============================================================
# 第 7 题：核对手算，不调用 glmnet，因为题目目标函数尺度不同
# ============================================================
cat("\n========== Problem 7 ==========\n")
X7 <- matrix(c(-1, 0, 0, -1, 0, 0, 0, 1, 1, 0), ncol = 2, byrow = TRUE)
Y7 <- c(3, -4, 1, 2, -2)
lambda7 <- 5
XtX <- crossprod(X7)
XtY <- drop(crossprod(X7, Y7))
print(XtX)
print(XtY)
beta_ols <- drop(solve(XtX, XtY))
beta_ridge <- drop(solve(XtX + lambda7 * diag(2), XtY))
# 本题两列正交，因此可以逐坐标软阈值。一般非正交 X 不能直接套这个公式。
beta_lasso <- sign(XtY) * pmax(abs(XtY) - lambda7, 0) / diag(XtX)
slopes7 <- rbind(OLS = beta_ols, Ridge = beta_ridge, Lasso = beta_lasso)
intercepts7 <- 3 - slopes7 %*% c(2, -1)
save_table(data.frame(method = rownames(slopes7), intercept = drop(intercepts7),
                      beta1 = slopes7[, 1], beta2 = slopes7[, 2]), "q7_handcalculation.csv")

# ============================================================
# 第 8 题：glmnet，完全使用给定划分与五折编号
# ============================================================
cat("\n========== Problem 8 ==========\n")
# match 只对齐 split 的标记，不重排 ais，也不重新随机划分。
stopifnot(nrow(ais) == 202, nrow(split) == 202, !anyDuplicated(split$row_id),
          identical(sort(as.integer(split$row_id)), seq_len(nrow(ais))))
split_aligned <- split[match(seq_len(nrow(ais)), split$row_id), ]
train <- which(split_aligned$set == "train")
test <- which(split_aligned$set == "test")
foldid <- as.integer(split_aligned$fold[train])
stopifnot(length(train) == 150, length(test) == 52, !anyNA(foldid),
          all(table(foldid) == 30), identical(sort(unique(foldid)), 1:5))

# ais 中的 Sex 已经是题目要求的 0/1 编码。
stopifnot(all(ais$Sex %in% c(0, 1)))
x <- as.matrix(ais[, vars10])
y <- ais$Bfat
x_train <- x[train, , drop = FALSE]
x_test <- x[test, , drop = FALSE]
y_train <- y[train]
y_test <- y[test]

# 不先 scale 全数据；让 glmnet 在拟合中 standardize=TRUE。
# 不手动标准化 y。lambda 网格使用软件默认，版本记在 sessionInfo 中。
cv_ridge <- cv.glmnet(x_train, y_train, family = "gaussian", alpha = 0,
                      foldid = foldid, nfolds = 5, type.measure = "mse",
                      standardize = TRUE, intercept = TRUE, keep = TRUE)
cv_lasso <- cv.glmnet(x_train, y_train, family = "gaussian", alpha = 1,
                      foldid = foldid, nfolds = 5, type.measure = "mse",
                      standardize = TRUE, intercept = TRUE, keep = TRUE)

pred_ridge <- drop(predict(cv_ridge, newx = x_test, s = "lambda.min"))
pred_lasso <- drop(predict(cv_lasso, newx = x_test, s = "lambda.min"))
coef_ridge <- as.matrix(coef(cv_ridge, s = "lambda.min"))
coef_lasso <- as.matrix(coef(cv_lasso, s = "lambda.min"))
metrics8 <- data.frame(model = c("Ridge", "Lasso"),
                       lambda_min = c(cv_ridge$lambda.min, cv_lasso$lambda.min),
                       min_CV_MSE = c(min(cv_ridge$cvm), min(cv_lasso$cvm)),
                       test_MSE = c(mean((y_test - pred_ridge)^2), mean((y_test - pred_lasso)^2)),
                       nonzero_slopes = c(sum(coef_ridge[-1, 1] != 0), sum(coef_lasso[-1, 1] != 0)))
save_table(metrics8, "q8_metrics.csv")
save_table(data.frame(term = rownames(coef_ridge), Ridge = coef_ridge[, 1], Lasso = coef_lasso[, 1]),
           "q8_coefficients_original_scale.csv")
for (name in c("ridge", "lasso")) {
  cv <- if (name == "ridge") cv_ridge else cv_lasso
  save_table(data.frame(lambda = cv$lambda, CV_MSE = cv$cvm, SE = cv$cvsd),
             paste0("q8_cv_", name, ".csv"))
  png(paste0("figures/q8_cv_", name, ".png"), width = 1400, height = 950, res = 160)
  # 上方数字是非零斜率数；给标题留出空间，避免与它们重叠。
  par(mar = c(5, 5, 6, 2))
  plot(cv)
  title(main = paste("Five-fold CV:", name), line = 4)
  dev.off()
}

omega <- seq(0, 1, by = 0.1)
combo_mse <- sapply(omega, function(w) mean((y_test - (w * pred_ridge + (1 - w) * pred_lasso))^2))
save_table(data.frame(omega = omega, test_MSE = combo_mse), "q8_combo_MSE.csv")
save_table(data.frame(row_id = test, observed = y_test, Ridge = pred_ridge, Lasso = pred_lasso),
           "q8_test_predictions.csv")

png("figures/q8_combo.png", width = 1400, height = 950, res = 160)
par(mar = c(4.5, 4.5, 3, 1))
plot(omega, combo_mse, type = "b", pch = 16, col = colors[1], lwd = 2,
     xlab = "Ridge weight (omega)", ylab = "Test MSE", main = "Prediction combination (descriptive only)")
grid(col = "#E5E7EB")
dev.off()
# 此曲线只描述测试集表现，不能用测试集最小值来确定可宣称独立测试有效的 omega。

# ============================================================
# 第 9 题：group lasso，训练集样本标准差，固定五折
# ============================================================
cat("\n========== Problem 9 ==========\n")
group_vars <- c("Ht", "Wt", "BMI", "RCC", "Hc", "Hg", "WCC", "Ferr", "SSF", "Sex")
groupid <- c(1, 1, 1, 2, 2, 2, 3, 3, 4, 5)
group_weights <- sqrt(as.numeric(table(groupid)))
xg_train <- as.matrix(ais[train, group_vars])
xg_test <- as.matrix(ais[test, group_vars])
mu <- colMeans(xg_train)
sd_train <- apply(xg_train, 2, sd)
zg_train <- scale(xg_train, center = mu, scale = sd_train)
zg_test <- scale(xg_test, center = mu, scale = sd_train)
save_table(data.frame(variable = group_vars, mean = mu, sample_sd = sd_train),
           "q9_standardization.csv")

# 按题目要求：先用整个训练集确定一次变换，再在这个矩阵上做五折 CV。
# 不使用测试集均值或标准差，也不额外重新缩放 Sex。
# gglasso 1.6 文档里 L1/L2 的文字存在混淆，下方用折外预测核验实际平方误差。
cv_group <- cv.gglasso(zg_train, y_train, group = groupid, loss = "ls",
                       pred.loss = "L2", foldid = foldid, nfolds = 5,
                       pf = group_weights, intercept = TRUE)

# 独立按定义重算五折 MSE，避免仅凭参数名称误判评估损失。
# 这里使用相同网格及相同模型，只核对实现，并不改变调参准则。
lambda_group <- cv_group$lambda
oof_group <- matrix(NA_real_, nrow = length(y_train), ncol = length(lambda_group))
for (k in 1:5) {
  valid <- which(foldid == k)
  fit_k <- gglasso(zg_train[-valid, , drop = FALSE], y_train[-valid],
                   group = groupid, loss = "ls", lambda = lambda_group,
                   pf = group_weights, intercept = TRUE)
  oof_group[valid, ] <- predict(fit_k, newx = zg_train[valid, , drop = FALSE], s = lambda_group)
}
manual_mse <- colMeans((oof_group - y_train)^2)
manual_mae <- colMeans(abs(oof_group - y_train))
cv_matches_mse <- max(abs(cv_group$cvm - manual_mse)) < 1e-5
cat("gglasso version:", as.character(packageVersion("gglasso")), "\n")
cat("Does pred.loss='L2' match squared error?", cv_matches_mse, "\n")

# 统一以明确计算的平方误差最小点作为选择；1.6 版本应与 lambda.min 一致。
lambda9 <- lambda_group[which.min(manual_mse)]
# 使用已经拟合的全训练集路径在所选网格点的系数，避免单点拟合的数值差异。
fit9 <- cv_group$gglasso.fit
coef9 <- as.matrix(coef(fit9, s = lambda9))
pred9 <- drop(predict(fit9, newx = zg_test, s = lambda9))
keep_groups <- sort(unique(groupid[abs(coef9[-1, 1]) > 1e-8]))
save_table(data.frame(term = c("(Intercept)", group_vars), group = c(NA, groupid),
                      coefficient_standardized = coef9[, 1]), "q9_coefficients_standardized.csv")
save_table(data.frame(lambda = lambda_group, CV_MSE = manual_mse, package_CV = cv_group$cvm,
                      CV_MAE_check_only = manual_mae, SE = cv_group$cvsd), "q9_cv.csv")
metrics9 <- data.frame(model = "Group lasso", lambda_min = lambda9,
                       min_CV_MSE = min(manual_mse), test_MSE = mean((y_test - pred9)^2),
                       retained_groups = paste(keep_groups, collapse = ","),
                       package_version = as.character(packageVersion("gglasso")),
                       L2_verified_as_MSE = cv_matches_mse)
save_table(metrics9, "q9_metrics.csv")
save_table(data.frame(row_id = test, observed = y_test, Group_lasso = pred9), "q9_test_predictions.csv")

png("figures/q9_cv_group_lasso.png", width = 1400, height = 950, res = 160)
par(mar = c(4.5, 4.5, 3, 1))
plot(log(lambda_group), manual_mse, type = "b", pch = 16, cex = 0.45,
     col = colors[3], xlab = "log(lambda)", ylab = "Five-fold validation MSE",
     main = "Group lasso: CV using squared prediction error")
abline(v = log(lambda9), col = colors[2], lty = 2, lwd = 2)
dev.off()

comparison <- data.frame(model = c("Ridge", "Lasso", "Group lasso"),
                          test_MSE = c(metrics8$test_MSE, metrics9$test_MSE))
save_table(comparison, "q9_test_comparison.csv")
capture.output(sessionInfo(), file = "results/sessionInfo.txt")
cat("\n全部 9 题运行完成。结果在 results/，图像在 figures/。\n")
