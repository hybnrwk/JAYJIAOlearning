function [x] = usolve(U, b)
% By Gwz, Shanghai University of finance and economics 
% This function solves linear system L*x = b where L is an n * n 
% non-singular upper triangular matrix and b is an n * 1 vector

[n, ~] = size(U);

for i = n:-1:1
    b(i) = (b(i) - U(i, i + 1:n) * b(i + 1:n)) / U(i, i);
end % End for

x = b;

end % End function