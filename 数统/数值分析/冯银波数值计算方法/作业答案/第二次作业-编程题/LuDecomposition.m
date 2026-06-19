function [res] = LuDecomposition(A, mode)
% By Gwz, Shanghai University of finance and economics 
% This function computes the LU decomposition of a non-singular square
% matrix using either column/row pivoting or non-pivoting rule

% Get matrix dimension
[n, ~] = size(A);

% Initialize permutation
pmt = 1:n;

% Initialize solution struct
res.mode = mode;

% Implement LU decomposition without pivoting
if mode == "N"
    for i = 1:n - 1
        if abs(A(i, i)) < 1e-20
            warning("Numerical issues due to pivoting");
        end
        
        A(i + 1:end, i) = A(i + 1:end, i) / A(i, i);
        A(i + 1:end, i + 1:end) = A(i + 1:end, i + 1:end) - ...
            diag(A(i + 1:end, i)) * repmat(A(i, i + 1:end), (n - i), 1);
    end % End for
    
    % Get solution
    res.L = tril(A) - diag(diag(A)) + eye(n);
    res.U = triu(A);

% Implement LU decomposition with row pivoting
elseif mode == "R"
    for i = 1:n - 1
        if abs(A(i, i)) < 1e-20
            warning("Numerical issues due to pivoting");
        end
        % Take the element with maximum absolute value in the column
        [~, k] = max(abs(A(i, i:end)));
        
        % Exchange rows and permutation
        A(:, [i, k + i - 1]) = A(:, [k + i - 1, i]);
        pmt([i, k + i - 1]) = pmt([k + i - 1, i]);
        
        % Do elimination
        A(i + 1:end, i) = A(i + 1:end, i) / A(i, i);
        A(i + 1:end, i + 1:end) = A(i + 1:end, i + 1:end) - ...
            diag(A(i + 1:end, i)) * repmat(A(i, i + 1:end), (n - i), 1);
    end % End for
    
    % Get solution
    res.U = triu(A);
    res.L = tril(A) - diag(diag(A)) + eye(n);

% Implement LU decomposition with column pivoting
elseif mode == "C"
    for i = 1:n - 1
        % Take the element with maximum absolute value in the column
        [~, k] = max(abs(A(i:end, i)));
        
        % Exchange rows and permutation
        A([i, k + i - 1], :) = A([k + i - 1, i], :);
        pmt([i, k + i - 1]) = pmt([k + i - 1, i]);
        
        if abs(A(i, i)) < 1e-20
            warning("Numerical issues due to pivoting");
        end
        
        % Do elimination
        A(i + 1:end, i) = A(i + 1:end, i) / A(i, i);
        A(i + 1:end, i + 1:end) = A(i + 1:end, i + 1:end) - ...
            diag(A(i + 1:end, i)) * repmat(A(i, i + 1:end), (n - i), 1);
    end % End for
    
    % Get solution
    res.L = tril(A) - diag(diag(A)) + eye(n);
    res.U = triu(A);
    
else
    error("Mode not supported, specify 'C' for column pivoting," + ...
            "'R' for row pivoting and 'N' for non-pivoting");
end % End if

% Get permutation
res.P = pmt;

end % End function

