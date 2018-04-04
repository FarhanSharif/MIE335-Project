function [x_values, lambda_values, mu_values, slack_values] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim)

% First, row reduce all basic variables to "identity" matrix 
% for all basic vars that are not slack (either "x" or "a", because slacks 
% are by default "identity")

% Reduce for all basic "mu" or "x" vars 
for ii = 1 : x_dim(3) % # mu's = x_dim(3) = # x's = x_dim(1)
   if basis_lookup(vars_in_basis(ii)) == 1
       tableau = row_reduce(tableau, ii, vars_in_basis(ii));
   end
end

% For "a" vars (last columns after all x, lambda, mu, and s vars)
for ii = sum(x_dim)+1 : length(basis_lookup)
    
    a_row = find(vars_in_basis == ii);
    tableau = row_reduce(tableau, a_row, ii);
    
end

num_rows_tableau = size(tableau, 1);
num_cols_tableau = size(tableau, 2);

% Last row of tableau is used to find entering variable (corresponds to
% position of largest positive value b/c this is a min problem)
z_row = tableau(num_rows_tableau, (1 : num_cols_tableau-1));

% Find max value and corresponding pivot column
[max_value, pivot_col] = max(z_row);

% Find complement variable position of candidate entering variable
complement_position = complementary_positions(pivot_col);

% Keep searching for a candidate entering variable until one is found that
% doesnt have a complement in the basis
while complement_position ~= 0 && basis_lookup(complement_position) == 1
    
    z_row(pivot_col) = -inf; % Make the candidate -inf, so new max can be found
    [max_value, pivot_col] = max(z_row); % Returns pivot column of *first* max occurence
    
    % Check if new entering candidate has a basic complement
    complement_position = complementary_positions(pivot_col);
    
end

while max_value > 0
    
    % Extract RHS corresponding to basic vars (i.e. all RHS except z row)
    var_RHS = tableau((1 : num_rows_tableau-1), num_cols_tableau);
    
    % Calculate ratios
    ratios = var_RHS ./ tableau((1 : num_rows_tableau-1), pivot_col);
    
    % Remove all nonpositive ratios to properly find min ratio
    ratios(ratios <= 0) = inf;
    
    % Find min ratio and corresponding pivot row
    [min_ratio, pivot_row] = min(ratios);
    
    % pivot_col (entering variable's position) replaces the current
    % variable in the basis associated with the pivot row
    basis_lookup(vars_in_basis(pivot_row)) = 0;
    basis_lookup(pivot_col) = 1;
    
    vars_in_basis(pivot_row) = pivot_col;
    
    % Update (row reduce) tableau
    tableau = row_reduce(tableau, pivot_row, pivot_col);
    
    z_row = tableau(num_rows_tableau, (1 : num_cols_tableau-1));

    % Find max value and corresponding pivot column
    [max_value, pivot_col] = max(z_row);

    % If max value is not positive, then optimal solution found.
    if max_value <= 0
        break;
    end
    
    % Find complement variable position of candidate entering variable
    complement_position = complementary_positions(pivot_col);

    % Keep searching for a candidate entering variable until one is found that
    % doesnt have a complement in the basis
    while complement_position ~= 0 && basis_lookup(complement_position) == 1

        z_row(pivot_col) = -inf; % Make the candidate -inf, so new max can be found
        [max_value, pivot_col] = max(z_row); % Returns pivot column of *first* max occurence

        % Check if new entering candidate has a basic complement
        complement_position = complementary_positions(pivot_col);

    end
    
end

% Extract final RHS corresponding to basic vars (i.e. all RHS except z row)
x_RHS = tableau((1 : num_rows_tableau-1), num_cols_tableau);

% Initialize solution vector
x = zeros(sum(x_dim), 1);

% For each basic variable, put corresponding RHS in solution
for ii = 1 : length(vars_in_basis)
    x(vars_in_basis(ii)) = x_RHS(ii);
end

% Partition solution according to "x", labmda, mu, and slacks
[x_values, lambda_values, mu_values, slack_values] = partition_x(x, x_dim);

end

function [x_values, lambda_values, mu_values, slack_values] = partition_x(x, x_dim) 

num_x = x_dim(1);
num_lambda = x_dim(2);
num_mu = x_dim(3);
num_slacks = x_dim(4);

x_range = 1 : num_x;
lambda_range = num_x + 1 : num_x + num_lambda;
mu_range = num_x + num_lambda + 1 : num_x + num_lambda + num_mu;
slack_range = num_x + num_lambda + num_mu + 1 : num_x + num_lambda + num_mu + num_slacks;

x_values = x(x_range);
lambda_values = x(lambda_range);
mu_values = x(mu_range);
slack_values = x(slack_range);

end