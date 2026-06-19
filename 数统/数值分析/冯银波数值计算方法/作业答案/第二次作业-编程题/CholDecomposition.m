function [res] = CholDecomposition(A,mode)
% By Wanyu Z., wanyuzhang@stu.sufe.edu.cn
% This function implements the LL and LDL decomposition

% Get matrix dimension
[n, ~] = size(A);

% Initialize solution struct
res.mode = mode;

if mode == "LL"
    for k = 1:n
        A(k,k) = sqrt(A(k,k));
        A(k+1:n, k) = A(k+1:n, k)/A(k,k);
        for j = k+1:n
            A(j:n, j) = A(j:n, j) - A(j:n, k)*A(j,k);
        end
    end
    res.L = tril(A);
    res.D = eye(n);
elseif mode == "LDL"
    for j = 1:n
        v = zeros(j-1,1);
        for i = 1:j-1
            v(i) = A(j,i)*A(i,i);
        end
        if j >= 2
            A(j,j) = A(j,j)-A(j,1:j-1)*v(1:j-1);
        end
        A(j+1:n,j) = (A(j+1:n,j)-A(j+1:n,1:j-1)*v)/A(j,j);
    end
    res.L = tril(A,-1) + eye(n);
    res.D = diag(diag(A));
else
    error("Mode not supported, specify 'LL' for Cholesky decomposition," + ...
            "'LDL' for LDL decomposition");
end % End if
end

