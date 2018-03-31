function [x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(A, b, x_dim)

% If any RHS is -ve, make positive (multiply that row of A and b by -1)
[A, b] = make_RHS_positive(A, b);

num_rows = size(A, 1); % # of constraints = # rows in A = # basic vars
num_cols = size(A, 2); % Initial # of columns in A (initial # of variables)

x_positions = [1 : num_cols]'; % x_positions keep track of variables' indices
c = zeros(num_cols, 1); % c keeps track of z coefficients (current no a's)

num_x = x_dim(1); % Number of "x" vars (which are NOT lambda, mu, slack)

% For the first num_x # constraints, check if RHS = 0
% If RHS = 0, then the corresponding "x" variable for that constraint stays
% in the basis and is assigned value of RHS (0) by default
for ii = 1 : num_x
    
    % If RHS is not zero, add an artifical variable for that constraint
    if b(ii) ~= 0
        
        % Takes position of x and c out of basis
        temp = x_positions(ii);
        temp_c = c(ii);
        
        % Put newly added position and c (of artificial variable) in basis
        x_positions(ii) = length(x_positions) + 1;
        c(ii) = 1; % Artificial variable has coefficient = 1 in objective
        
        % Append position of x and c (that was taken out of basis) at the
        % end (thus, putting in nonbasis)
        x_positions = [x_positions; temp];
        c = [c; temp_c];
        
        % Increase A with column for newly added artificial variable
        a_col = zeros(num_rows, 1);
        a_col(ii) = 1;
        A = [A a_col];
        
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
        
        % Takes position of x and c out of basis
        temp = x_positions(ii);
        temp_c = c(ii);
        
        % Puts position of slack (in x) and c in basis
        x_positions(ii) = x_positions(slack_col);
        c(ii) = c(slack_col);
        
        % Put position of x and c (that was taken out of basis) in nonbasis
        x_positions(slack_col) = temp;
        c(slack_col) = temp_c;
        
    else
        
        % Takes position of x and c out of basis
        temp = x_positions(ii);
        temp_c = c(ii);
        
        % Put newly added position and c (of artificial variable) in basis
        x_positions(ii) = length(x_positions) + 1;
        c(ii) = 1; % Artificial variable has coefficient = 1 in objective
        
        % Append position of x and c (that was taken out of basis) at the
        % end (thus, putting in nonbasis)
        x_positions = [x_positions; temp];
        c = [c; temp_c];
        
        % Increase A with column for newly added artificial variable
        a_col = zeros(num_rows, 1);
        a_col(ii) = 1;
        A = [A a_col];
        
    end
    
end

num_cols = size(A, 2); % # of columns will change after adding a's

% Initialize B and N with 0's
B = zeros(num_rows, num_rows);
N = zeros(num_rows, num_cols - num_rows);

% Make B based on basic variables positions (# basic vars = # rows)
for ii = 1 : num_rows
    B(:, ii) = A(:, x_positions(ii)); 
end

% Make N based on nonbasic vars positions (# nonbasic vars = #cols - #rows)
for ii = num_rows+1 : num_cols
    N(:, ii-num_rows) = A(:, x_positions(ii)); 
end

% #rows = #basic variables, top num_rows of c corresponds to basic vars
cB = c(1 : num_rows); 

% Rest of rows after num_rows of c corresponds to nonbasic variables
cN = c(num_rows+1 : num_cols); 

% First num_rows of x will be basic (so = b); rest of the rows will be
% nonbasic (so = 0);
x = [b; zeros(num_cols - num_rows, 1)];

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
    basis_lookup(x_positions(ii)) = 1; % Assign 1 for variables in basis
end

end

function [A, b] = make_RHS_positive(A, b)
    
    for ii = 1 : length(b) 
        if b(ii) < 0
            A(ii,:) = -A(ii,:);
            b(ii) = -b(ii);
        end
    end
    
end