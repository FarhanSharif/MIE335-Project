function [x_quadprog_vs_simplex, time_simplex] = test_SVM(mu)

[train,tune,test,dataDim] = getFederalistData;
[M, H] = getMH(train);

[Q, c, A, b, LB, UB] = intialize(M, H, mu);

tic
[Aeq, beq, x_dim] = lagrangian(Q, c, A, b);
% [x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(Aeq, beq, x_dim);
% [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N, x_dim);
[tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_regular_simplex(Aeq, beq, x_dim);
[x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
time_simplex = toc;

[x_quadprog, fval, exitflag, output, lambda] = quadprog(Q, c, A, b, [], [], LB, UB);

% Put x_quadprog and x_simplex side by side for comparison
x_quadprog_vs_simplex = [x_quadprog x_simplex];



end

