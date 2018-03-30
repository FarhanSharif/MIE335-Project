function x = revised_simplex(x, x_positions, cB, cN, B, N)

num_basic = size(B, 2); % # of basic variables
num_nonbasic = size(N, 2); % # of nonbasic variables

% Optimality check
r = cN - ((cB' * (B^-1))*N)';
[value, enter_index] = min(r);

% If negative value exists, then continue until no more negative values
while value < 0
    
    % Make unity vector
    e = zeros(num_nonbasic, 1);
    e(enter_index) = 1;
    
    % Calculate d (needed to find min ratio)
    d = [((-(B^-1)) * N(:, enter_index)); e];
    
    % Calculate ratios
    ratios = (-x) ./ d;
    
    % To find min positive ratio, convert all nonpositive ratios to inf
    % Found notation here: https://www.mathworks.com/matlabcentral/answers/133523-find-minimum-value-greater-than-zero-in-the-rows
    ratios(ratios <= 0) = inf; 
    
    % Find min ratio (a) & corresponding index in basic matrix (exit_index)
    [a, exit_index] = min(ratios);
    
    % Update x
    x = x + (a * d);
    
    % Swap variables so that basic variables are at the top
    temp = x(exit_index);
    x(exit_index) = x(num_basic + enter_index);
    x(num_basic + enter_index) = temp;
    
    temp = x_positions(exit_index);
    x_positions(exit_index) = x_positions(num_basic + enter_index);
    x_positions(num_basic + enter_index) = temp;
    
    % Swap exiting and entering variable columns in B and N matrices
    temp = B(:, exit_index);
    B(:, exit_index) = N(:, enter_index);
    N(:, enter_index) = temp;
    
    % Swap exiting and entering variable positions in cB and cN matrices
    temp = cB(exit_index);
    cB(exit_index) = cN(enter_index);
    cN(enter_index) = temp;
    
    % Optimality Test
    r = cN - ((cB' * (B^-1))*N)';
    [value, enter_index] = min(r);
    
end

x = reorder_x(x, x_positions);


end

function x_final = reorder_x(x, x_positions) 

num_vars = length(x); % Length of x = Number of variables

x_final = zeros(num_vars, 1);

% For each variable, put in correct position according to x_positions (was
% originally ordered from 1 in intialize_BFS.m)
for ii = 1 : num_vars
    x_final(x_positions(ii)) = x(ii);
end

end

