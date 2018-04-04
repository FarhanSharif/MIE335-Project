function [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_only_mu(A, b, x_dim)

% If any RHS is -ve, make positive (multiply that row of A and b by -1)
[A, b] = make_RHS_positive(A, b);

num_rows = size(A, 1); % # of constraints = # rows in A = # basic vars
num_cols = size(A, 2); % Initial # of columns in A (initial # of variables)

vars_in_basis = zeros(num_rows, 1); % Will hold positions of vars in basis

num_x = x_dim(1); % Number of "x" vars (which are NOT lambda, mu, slack)

% For the first num_x # constraints, check if RHS = 0
% If RHS = 0, then the corresponding "x" variable for that constraint stays
% in the basis and is assigned value of RHS (0) by default
for ii = 1 : num_x
    
    % If RHS is not zero, add an artifical variable for that constraint
    if b(ii) ~= 0
        
        % Increase A with column for newly added artificial variable
        a_col = zeros(num_rows, 1);
        a_col(ii) = 1;
        A = [A a_col];
        
        % Add artificial variable to the basis
        num_cols = num_cols + 1; % # variables has increased by 1
        vars_in_basis(ii) = num_cols; % last col = position of new "a" var
        
    else
        
        % If RHS is zero, add row's corresponding "x" var to basis
        vars_in_basis(ii) = x_dim(1) + x_dim(2) + ii; 

    end
    
end

num_lambda = x_dim(2); % # of lambda variables
num_mu = x_dim(3); % # of mu variables
num_slacks = x_dim(4); % The last number in x_dim = # slack variables

% For the remaining constraints, check if slack coefficients = 1
% If slack coefficient = 1, then that corresponding slack variable position
% is swapped with the current variable's position in the basis
for ii = num_x + 1 : num_rows
    
    % Column of current slack variable with respect to A
    slack_col = num_lambda + num_mu + ii; 
    
    if A(ii, slack_col) == 1
        
        vars_in_basis(ii) = slack_col;
        
    else
        
        % Increase A with column for newly added artificial variable
        a_col = zeros(num_rows, 1);
        a_col(ii) = 1;
        A = [A a_col];
        
        % Add artificial variable to the basis
        num_cols = num_cols + 1; % # variables has increased by 1
        vars_in_basis(ii) = num_cols; % last col = position of new "a" var
        
    end
    
end

% Make complementary positions corresponding to each variable:
% x positions will be complementary for mu positions and vice versa,
% lamda positions will be complementary for slack positions and vice versa.
% Since x was initially a sorted list from 1 to # of variables in A (before
% being swapped around), and using the advantagous order of x_dim (i.e. x,
% lambda, mu, and then slack), another sorted list can be made, partitioned
% according to x, lambda, mu, and slack, and then the complementary
% sections can be swapped, mapping complementary variables.
x_range = 1 : num_x;
lambda_range = num_x + 1 : num_x + num_lambda;
mu_range = num_x + num_lambda + 1 : num_x + num_lambda + num_mu;
slack_range = num_x + num_lambda + num_mu + 1 : num_x + num_lambda + num_mu + num_slacks;

% Artificial variables will have no complements, so pad their
% "complementary_positions" with zeros
artificial_range = zeros(1, num_cols - sum(x_dim));

% This "dictionary" of complentary_positions will make it quicker to check
% if a variable's complement is in the basis when doing revised simplex.
complementary_positions = [mu_range slack_range x_range lambda_range artificial_range];

% This "dictionary" keeps track of whether variables are in basis (1) or not (0)
basis_lookup = zeros(num_cols, 1); % Initialize 0 for all variables
for ii = 1 : num_rows
    basis_lookup(vars_in_basis(ii)) = 1; % Assign 1 for variables in basis
end

bottom_row = [zeros(1, sum(x_dim)) -ones(1, num_cols - sum(x_dim)) 0];

tableau = [[A b]; bottom_row];

end

function [A, b] = make_RHS_positive(A, b)
    
    for ii = 1 : length(b) 
        if b(ii) < 0
            A(ii,:) = -A(ii,:);
            b(ii) = -b(ii);
        end
    end
    
end
