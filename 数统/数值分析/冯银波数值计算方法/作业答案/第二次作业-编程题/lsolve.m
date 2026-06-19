function [x] = lsolve(L, b)
% By Gwz, Shanghai University of finance and economics 
% This function solves linear system L*x = b where L is an n * n 
% non-singular lower triangular matrix and b is an n * 1 vector

[n, ~] = size(L);

for i = 1:n
    b(i) = (b(i) - L(i, 1:i - 1) * b(1:i - 1)) / L(i, i);
end % End for

x = b;

end % End function


