function [x_quadprog_vs_simplex, time_simplex] = test_SVM(mu)

[train,tune,test,dataDim] = getFederalistData;
[M, H] = getMH(train);

[Q_simplex, c_simplex, A_simplex, b_simplex] = intialize_URS(M, H, mu);

tic
[Aeq, beq, x_dim] = lagrangian(Q_simplex, c_simplex, A_simplex, b_simplex);
[x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(Aeq, beq, x_dim);
[x_simplex, lambda_simplex, mu_simplex, slack_simplex] = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N, x_dim);
time_simplex = toc;


[Q_quadprog, c_quadprog, A_quadprog, b_quadprog, LB_quadprog, UB_quadprog] = initialize(M, H, mu);

[x_quadprog, fval, exitflag, output, lambda] = quadprog(Q_quadprog, c_quadprog, A_quadprog, b_quadprog, [], [], LB_quadprog, UB_quadprog);

% Put x_quadprog and x_simplex side by side for comparison
x_quadprog_vs_simplex = [x_quadprog x_simplex];



end

