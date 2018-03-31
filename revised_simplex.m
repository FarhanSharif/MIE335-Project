function x = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N)

num_basic = size(B, 2); % # of basic variables
num_nonbasic = size(N, 2); % # of nonbasic variables

% Optimality check
r = cN - ((cB' * (B^-1))*N)';
[value, enter_index] = min(r);

% Check if entering candidate has complementary in basis
candidate_position = x_positions(num_basic + enter_index);
complement_position = complementary_positions(candidate_position);

% If basic complement is not 0 (artificial vars have no complement)
% AND a basic complement exists, assigns new min (candidate) 
% until one that doesnt have a basic complement is found
while complement_position ~= 0 && basis_lookup(complement_position) == 1
    
    r(enter_index) = inf; % Make the candidate inf, so new min can be found
    [value, enter_index] = min(r); % Returns index at *first* min occurence
    
    % Check if new entering candidate has a basic complement
    candidate_position = x_positions(num_basic + enter_index);
    complement_position = complementary_positions(candidate_position);
    
end

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
    
    % Swap variable RHS so that basic variables are at the top
    temp = x(exit_index);
    x(exit_index) = x(num_basic + enter_index);
    x(num_basic + enter_index) = temp;
    
    % Correct basis lookup "dictionary" (exiting now = 0, entering now = 1)
    basis_lookup(x_positions(exit_index)) = 0; 
    basis_lookup(x_positions(num_basic + enter_index)) = 1; 

    % Swap corresponding variable positions to keep track 
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
    
    if value >= 0 % If min >= 0, optimal solution found, break out of loop
        break;
    end
    
    % Check if entering candidate has complementary in basis
    candidate_position = x_positions(num_basic + enter_index);
    complement_position = complementary_positions(candidate_position);

    % If basic complement exists, assigns new min (candidate) 
    % until one that doesnt have a basic complement is found
    while complement_position ~= 0 && basis_lookup(complement_position) == 1

        r(enter_index) = inf; % Make the candidate inf, so new min can be found
        [value, enter_index] = min(r); % Returns index at *first* min occurence

        % Check if new entering candidate has a basic complement
        candidate_position = x_positions(num_basic + enter_index);
        complement_position = complementary_positions(candidate_position);

    end
    
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

function doesExist = isComplementBasic(basic_positions, complement_position)

doesExist = 0;

% Checks if complement_position is in basic_positions (does is exist?)
for ii = 1 : length(basic_positions)
    if basic_positions(ii) == complement_position
        doesExist = 1;
        break;
    end
end

end

