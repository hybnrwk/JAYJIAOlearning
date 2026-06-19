function [x] = CholSolve(A, b, mode)
% By Wanyu Z., wanyuzhang@stu.sufe.edu.cn
% Last modified in 2024.10.12
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code implementation for Numerical Computation Method course,
% homework 2, LL and LDL decomposition for solving a linear system
% Function input
%           A    A positive semi-definite matrix
%           b    The right hand side vector
%        mode    "LL" or "LDL"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check dimension
[n, ~] = size(A);

if ~ (size(b) == n)
    error("Dimension mismatch");
end % End if

if mode == "LL"
    % Do LL decomposition of A
    res = CholDecomposition(A,mode);
    
    % Solve Ly = b
    y = lsolve(res.L, b);
    
    % Solve L'x = y
    x = usolve(res.L', y);
elseif mode == "LDL"
    % Do LDL decomposition of A
    res = CholDecomposition(A,mode);
    
    % Solve LDy = b
    y = lsolve(res.L*res.D, b);
    
    % Solve L'x = y
    x = usolve(res.L', y);
end
end

