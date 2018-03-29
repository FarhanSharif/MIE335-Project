function [Aeq, beq] = lagrangian(G, g, A, b)

% general QP -> KKT conditions
% formulation from IPM.pdf, note that their "A" is A^T

% where the inputs are from the general QP formulation
% min (1/2)(x^T)Gx + (g^T)x
% s.t. Ax >= b , x >= 0 (converted to equality cons later)
% g, x, b are column vectors
% Note: non negativity constraints (x >= 0) are placed in Ax >= b

% *** outputs are matrices of equations, should all be set = 0 when used
% L is the converted objective containing the lagrangian variables, lambda
% L is Gx - (A^T)*lam + g = 0
% F is the converted constraints containing slack variables t, so as not to
% confuse with s_i in SVM
% F is s - Ax + b = 0
% C are the complementary constraints, since lambda are shadow prices,
% slack t must be 0 if lambda is positive and vice versa
% C is lam*t = 0 for all constraints

% returned: (leave out C cons, enforce manually)
% add (lam,t) for x >= 0 cons
% Aeq = [L; F; x_nonneg_A] = [G -A^T 0; -A 0 I; I 0 -I]
% beq = [-g; -b; 0]
% x would be [x; lam; t]

L_matrix = [G -A' -eye(size(G,1),size(G,1)) zeros(size(G,1),size(A,1)+size(G,1))]; 
F_matrix = [-A zeros(size(A,1),size(A,1)+size(G,1)) eye(size(A,1),size(A,1)) zeros(size(A,1),size(G,1))];
x_nonneg_A = [eye(size(G,1),size(G,1)) zeros(size(G,1),size(G,1)+size(A,1)) zeros(size(G,1),size(A,1)) -eye(size(G,1),size(G,1))];

Aeq = [L_matrix; F_matrix; x_nonneg_A];
beq = [-g; -b; zeros(size(G,1),1)];

end