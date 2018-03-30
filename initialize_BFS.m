function [x, x_positions, cB, cN, B, N] = initialize_BFS(A, b, x_dim)

num_rows = size(A, 1); % # of constraints = # rows in A
num_cols = size(A, 2); % Initial # of columns in A (initial # of variables)

% The last number in x_dim = # slack variables
num_slacks = x_dim(length(x_dim)); 

% Number of nonslacks = total # of columns (# of "x" variables) - # slacks
num_nonslacks = num_cols - num_slacks;

% Extract portion of A that only corresponds to slack variables
A_slacks = A(:, (num_cols - num_slacks + 1 : num_cols));

% Summing each row of A_slacks allows us to quicker determine which rows
% have a slack with coefficient 1 (so we can swap that slack variable into 
% the basis), or coefficient -1 or 0 (so we can add artificial variables).
slack_coeffs_per_row = sum(A_slacks, 2);

x_positions = [1 : num_cols]'; % x_positions keep track of variables' indices
c = zeros(num_cols, 1); % c keeps track of z coefficients (current no a's)

for ii = 1 : num_rows 
    
    % Takes position of x and c out of basis
    temp = x_positions(ii);
    temp_c = c(ii);
    
    if slack_coeffs_per_row(ii) == 1
        
        % Find position (col) of slack variable with respect to A_slacks
        % (NOT A) so the correct position of that slack variable is found
        s_col = find(A_slacks(ii,:) == 1);
        
        % Puts position of slack (in x) and c in basis
        x_positions(ii) = x_positions(num_nonslacks + s_col);
        c(ii) = c(num_nonslacks + s_col);
        
        % Put position of x and c (that was taken out of basis) in nonbasis
        x_positions(num_nonslacks + s_col) = temp;
        c(num_nonslacks + s_col) = temp_c;
        
    else
        
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

end

function position = get_slack_position(slack_row)

    position = 0;
    for ii = 1 : length(slack_row)
        if slack_row(ii) == 1
            position = ii;
        end
    end
    
end