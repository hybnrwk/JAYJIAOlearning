%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Numerical Computation Method 2024 Fall                 %
%                         Course Homework 2 Code                          %
%                        Provided by Wanyu Zhang                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code implementation for Numerical Computation Method course,
% homework 2 where it is required to implement LL and LDL decomposition
% to solve linear system A * x = b

clear;
clc;

% Generate matrix A
n = 100;
A_1 = eye(n) * 10;
A_2 = zeros(n);
A_2(2:n, 1:n - 1) = eye(n - 1) * 1;
A_3 = zeros(n);
A_3(1:n - 1, 2:n) = eye(n - 1) * 1;
A = A_1 + A_2 + A_3;

% Generate rhs vector b
b = ones(n, 1);

% Test Gaussian Elimination with Column-Pivoting

tic;
x_1 = GaussElimination(A, b, "C");
t_1 = toc;
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("% Gaussian Elimination with column pivoting is done %");
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("Norm of residual ||A * x - b||_2 = " + norm(b - A * x_1));
disp("Solving time: " + t_1);

% Test LL' Decomposition
tic;
x_2 = CholSolve(A, b, "LL");
t_2 = toc;
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("%          LL decomposition is done                 %");
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("Norm of residual ||A * x - b||_2 = " + norm(b - A * x_2));
disp("Solving time: " + t_2);

% Test LDL' Decomposition
tic;
x_3 = CholSolve(A, b, "LDL");
t_3 = toc;
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("%          LDL decomposition is done                %");
disp("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
disp("Norm of residual ||A * x - b||_2 = " + norm(b - A * x_3));
disp("Solving time: " + t_3);
