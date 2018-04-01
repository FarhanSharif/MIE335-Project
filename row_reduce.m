function tableau = row_reduce(tableau, pivot_row, pivot_col)
% This function does elementary row operations to make all values
% above/below the pivot element equal to 0

% Make pivot element = 1 if not already
if tableau(pivot_row, pivot_col) ~= 1
    tableau(pivot_row, :) = tableau(pivot_row, :) / tableau(pivot_row, pivot_col);
end

for i = 1 : size(tableau, 1)
    
    if tableau(i, pivot_col) == 0 || i == pivot_row
        continue;
    end
    
    tableau(i, :) = tableau(i, :) - (tableau(i, pivot_col) * tableau(pivot_row, :));
    
end

end

