function [x, cBT, cN, B, N] = initialize_BFS(A, b, x_dim)

num_rows = size(A, 1); % # of constraints = # rows in A
num_cols = size(A, 2); % Initial # of columns in A (initial # of variables)

x_positions = [1 : num_cols]'; % x_positions keep track of variables' indices
c = zeros(num_cols, 1); % c keeps track of z coefficients (current no a's)

for ii = 1 : num_rows 
    
    % Temporarily hold current position of x and c
    temp = x_positions(ii);
    temp_c = c(ii);
    
    if A(ii, x_dim + ii) == 1
        
        % Swap positions of x and s, and corresponding c (put in basis)
        x_positions(ii) = x_positions(x_dim + ii);
        c(ii) = c(x_dim + ii);
        
        % Complete swapping (put x and corresponding c in nonbasis)
        x_positions(x_dim + ii) = temp;
        c(x_dim + ii) = temp_c;
        
    else
        
        % Swap positions with newly added position (artificial variable)
        x_positions(ii) = length(x_positions) + 1;
        c(ii) = 1; % Artificial variable has coefficient = 1 in objective
        
        % Increase x and c with newly added artificial variable
        x_positions = [x_positions; temp];
        c = [c; temp_c];
        
        % Increase A with column for newly added artificial variable
        a_col = zeros(num_rows, 1);
        a_col(ii) = 1;
        A = [A a_col];
        
    end
end

num_cols = size(A, 2); % # of columns will change after adding a's

% Makes B based on basic variables positions 
for ii = 1 : num_rows
    B(:, ii) = A(:, x_positions(ii)); 
end

% Makes N based on nonbasic variables positions    
for ii = num_rows+1 : num_cols
    N(:, ii-num_rows) = A(:, x_positions(ii)); 
end

% # rows = # basic variables, top num_rows of c corresponds to basic variables
cBT = c(1 : num_rows); 

% Rest of rows after num_rows of c corresponds to nonbasic variables
cN = c(num_rows+1 : num_cols); 

% First num_rows of x will be basic (so = b); rest of the rows will be
% nonbasic (so = 0);
x = [b; zeros(num_cols - num_rows, 1)];

end

