function test_SVM(mu)

combination = ["All x", "All mu", "x,mu,x,mu...", "mu,x,mu,x..."];

[train,tune,test,dataDim] = getFederalistData;
[M, H] = getMH(train);

[Q, c, A, b] = intialize_URS(M, H, mu);


for combo_code = 1 : 4
    tic
    [Aeq, beq, x_dim] = lagrangian(Q, c, A, b);
    
    % [x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(Aeq, beq, x_dim);
    % [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N, x_dim);

    combination(combo_code)
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
    time_simplex = toc

    x_final = zeros(70+86+1, 1);
    for ii = 1 : 70
        x_final(ii) = x_simplex((2*ii) - 1) - x_simplex(2*ii);
    end

    for ii = 1:86
        x_final(ii) = x_simplex(140 + ii);
    end

    x_final(57) = x_simplex(227) - x_simplex(228);

    simplex_val = (1/2)*x_simplex'*Q*x_simplex + c'*x_simplex;

    [Q_qp, c_qp, A_qp, b_qp, LB, UB] = intialize(M, H, mu);
    
    tic
    [x_quadprog, fval, exitflag, output, lambda] = quadprog(Q_qp, c_qp, A_qp, b_qp, [], [], LB, UB);
    time_quadprog = toc;
    
    time_quadprog
    
    % Put x_quadprog and x_simplex side by side for comparison
    x_quadprog_vs_simplex = [x_quadprog x_final];
    
    fval_quadprog_vs_simplex = [fval simplex_val];
    
    x_quadprog_vs_simplex
    fval_quadprog_vs_simplex
end



end

