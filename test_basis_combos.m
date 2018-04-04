function test_basis_combos()

G2 = [0.4 0.1 0.04; 0.1 0.16 0.06; 0.04 0.06 0.36];
g2 = zeros(3, 1);
A2 = [-0.14 -0.11 -0.1; 1 1 1];
b2 = [-120; 1000];

[Aeq, beq, x_dim] = lagrangian(G2, g2, -A2, -b2);
basis_combos = [1 2 3 0 0; 1 7 3 0 0; 6 2 8 0 0; 1 7 8 0 0; 6 2 3 0 0; 6 7 3 0 0; 6 7 8 0 0]';

for ii = 1 : 7
    
    disp("combo")
    basis_combos(:, ii)'
    
    [tableau, vars_in_basis, complementary_positions, basis_lookup] = find_IBFS_alternate_x_mu(Aeq, beq, basis_combos(:, ii), x_dim);
    [x_simplex, lambda_simplex, mu_simplex, slack_simplex] = simplex(tableau, vars_in_basis, complementary_positions, basis_lookup, x_dim);
    simplex_val = (1/2)*((x_simplex')*(G2*(x_simplex))) + g2'*x_simplex;
    
    [x_quadprog, fval, exitflag, output, lambda] = quadprog(G2, g2, A2, b2, [], [], zeros(3, 1), inf(3, 1));

    x_quadprog_vs_simplex = [x_quadprog x_simplex; fval simplex_val]

end