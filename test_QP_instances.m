function [x_quadprog_vs_simplex, time_simplex] = test_QP_instances(instance_num)
% This function takes instance_num as a string from '1' to '5' to test the
% 5 provided QP instances

% Make filename based on instance_num
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
tic
[Aeq, beq, x_dim] = lagrangian(Q, f, -A, -b);
[x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N] = initialize_BFS(Aeq, beq, x_dim);
[x_simplex, lambda_simplex, mu_simplex, slack_simplex] = revised_simplex(x, x_positions, complementary_positions, basis_lookup, cB, cN, B, N, x_dim);
time_simplex = toc;

% Put x_quadprog and x_simplex side by side for comparison
x_quadprog_vs_simplex = [x_quadprog x_simplex];

end

