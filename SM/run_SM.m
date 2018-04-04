function [z,b,w,p1,p2] = run_SM(M,H,mu)

    dataRow = size(M,1) + size(H,1);
    dataCol = size(M, 2);
    
    [Q, c, A, b] = intialize_URS(M, H, mu);
    [Aeq, beq, x_dim] = lagrangian(Q, c, A, b);
    
    % This is the only combination that yielded feasible solutions to the SVM for this algorithm
    % Only mu-variables will be in the basis for the first n constraints where there are n number of "x" variables 
    % which means that there are also n number of "mu" variables
    combo_code = 2; 
    
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
    
    w = zeros(dataCol, 1); % # cols in M = # cols in H = # w variables 
    for ii = 1 : dataCol
        % w = w_{+} - w_{-}, un-doing the URS condition
        w(ii) = x_simplex((2*ii) - 1) - x_simplex(2*ii); % w = w_{+} - w_{-}
    end

    s = zeros(dataRow, 1); % # rows in M + # rows in H = # s variables
    for ii = 1 : dataRow
       s(ii) = x_simplex(2*dataCol + ii); % no URS condition on s
    end

    % b = b_{+} - b_{-} (last two values of x_simplex), un-doing the URS condition 
    b = x_simplex(dataCol + dataRow + 1) - x_simplex(dataCol + dataRow + 2);

    z = (1/2)*x_simplex'*Q*x_simplex + c'*x_simplex;
    
    % since y(wx+b) >= 1 - s, misclassified if LHS < 0 or s > 1
    p1 = sum(s > 1);
    
    % find p2 = # misclassified points from tune
    % tune is 20% of data input
    numTune = floor(dataRow*0.2);
    splitTune = floor(numTune/2);
    M_tune = M(end-splitTune:end, :);
    H_tune = H(end-(numTune-splitTune):end, :);
    [~, s_tune] = obj_eval(M_tune, H_tune, mu, w, b);
    p2 = sum(s_tune > 1);

end