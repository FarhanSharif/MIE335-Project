function test_QP_instances()
% This function takes instance_num as a string from '1' to '5' to test the
% 5 provided QP instances

combination = ["All x", "All mu", "x,mu,x,mu...", "mu,x,mu,x..."];

% Test non-OR3 example (suffix 1), then test OR3 example (suffix 2)
G1 = 2*eye(2);
g1 = [-2; -3];
A1 = [1 1; 2 1];
b1 = [2; 3];

[Aeq, beq, x_dim] = lagrangian(G1, g1, -A1, -b1);

for combo_code = 1 : 4
    combination(combo_code)
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);

    [x_quadprog, fval, exitflag, output, lambda] = quadprog(G1, g1, A1, b1, [], [], zeros(2, 1), inf(2, 1));

    x_quadprog_vs_simplex = [x_quadprog x_simplex]
end

G2 = [0.4 0.1 0.04; 0.1 0.16 0.06; 0.04 0.06 0.36];
g2 = zeros(3, 1);
A2 = [-0.14 -0.11 -0.1; 1 1 1];
b2 = [-120; 1000];

[Aeq, beq, x_dim] = lagrangian(G2, g2, -A2, -b2);

for combo_code = 1 : 4
    combination(combo_code)
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);

    [x_quadprog, fval, exitflag, output, lambda] = quadprog(G2, g2, A2, b2, [], [], zeros(3, 1), inf(3, 1));

    x_quadprog_vs_simplex = [x_quadprog x_simplex]
end

for instance_num = ["1", "2", "3", "4", "5"]
% Make filename based on instance_num
instance_num

instance_filename = strcat('QP_', instance_num, '.mat');

% Load Q, f, LB, UB
load(instance_filename);

% Since loaded data has no constraints, the only constraint are x's <= UB
% So, A (constraint matrix) will just be an identity matrix and b = UB
A = eye(size(Q,1));
b = UB;

% Run quadprog, solution for only x values stored as x_quadprog
[x_quadprog, fval, exitflag, output, lambda] = quadprog(Q, f, A, b, [], [], LB, UB);

% Run simplex method (combining lagrangian, initialize_BFS and
% revised_simplex)
% Solution for only x values stored as x_simplex, and computation time
% stored as time_simplex
%tic
[Aeq, beq, x_dim] = lagrangian(Q, f, -A, -b);
%[x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(Aeq, beq, x_dim);
%[x_simplex, lambda_simplex, mu_simplex, slack_simplex] = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N, x_dim);

for combo_code = 1 : 4
    combination(combo_code)
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, combo_code, x_dim);
    vars_in_basis
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
%time_simplex = toc

    % Put x_quadprog and x_simplex side by side for comparison
    x_quadprog_vs_simplex = [x_quadprog x_simplex]
end
end

end

