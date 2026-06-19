function [x] = GaussElimination(A, b, mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  Numerical Computation Method 2021 Fall                 %
%                         Course Homework 1 Code                          %
%                                Wenzhi Gao                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the code implementation for Numerical Computation Method course,
% homework 1, Gaussian Elimination for solving a linear system
% Function input
%           A    A non-singular square matrix
%           b    The right hand side vector
%        mode    Whether to use pivoting (mode takes "C" for column
%                pivoting, "R" for row pivoting and "N" for no pivoting rule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check dimension
[n, ~] = size(A);

% Check degeneracy
if rank(A) < n
    warning("Matrix is numerically degenerate, " + ...
        "solution with non-pivoting may by inaccurate" + ...
        "(This warning is by Gwz, Shanghai University of Finance and Economics)");
end % End

if ~ (size(b) == n)
    error("Dimension mismatch");
end % End if

% Do LU decomposition
if mode == "N"
    % Do LU decomposition of A
    res = LuDecomposition(A, mode);
    
    % Solve Ly = b
    y = lsolve(res.L, b);
    
    % Solve Ux = y
    x = usolve(res.U, y);
elseif mode == "C"
    % Do LU decomposition of A
    res = LuDecomposition(A, mode);
    
    % Solve Ly = b
    y = lsolve(res.L, b(res.P));
    
    % Solve Ux = y
    x = usolve(res.U, y);
    
end % End if

end % End function

