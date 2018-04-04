function [avg_time_quadprog_vs_simplex] = avg_time_feasible_simplex(mu)

num_iterations = 100;
avg_time_quadprog_vs_simplex = [0 0]; % Initialize avg time (first is quadprog, second is simplex)
combo_code = 2;

[train,tune,test,dataDim] = getFederalistData;
[M, H] = getMH(train);

[Q, c, A, b] = intialize_URS(M, H, mu);
[Q_qp, c_qp, A_qp, b_qp, LB, UB] = intialize(M, H, mu);

for ii = 1 : num_iterations
    % Run feasible combination for simplex (all mu's: combo_code = 2)
    tic
    [Aeq, beq, x_dim] = lagrangian(Q, c, A, b);
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
    time_simplex = toc;

    % Run quadprog
    tic
    [x_quadprog, fval, exitflag, output, lambda] = quadprog(Q_qp, c_qp, A_qp, b_qp, [], [], LB, UB);
    time_quadprog = toc;
    
    avg_time_quadprog_vs_simplex = avg_time_quadprog_vs_simplex + [time_quadprog time_simplex];
end

avg_time_quadprog_vs_simplex = avg_time_quadprog_vs_simplex / num_iterations;

end

