function [z, w, b, s] = SA(M, H, mu, x_0, T_0, alpha, N, P)

% M, H, mu needed to build objective function z for SVM
% M, H contain the feature vector for 1 paper in each row
% x_0, T_0, alpha, N, P needed for SA algorithm in general
%   x_0 is initial solution as a column vector [w; b]
%   T_0 is initial "temperature", affects escape probability
%   alpha is how fast T decreases; T(k+1) = alpha*T(k)
%   N is # of iter, number of steps
%   P is # of iter for a given k or step size, so we give it more chance to move well
% return final values for z, w, b
% see "Simulated Annealing.docx" for notes

[z_0, s_0] = feval('obj_eval', M, H, mu, x_0(1:end-1), x_0(end));
x_opt = x_0;
z_opt = z_0;
s_opt = s_0;

x_curr = x_0;
z_curr = z_0;
T_curr = T_0;
x_dim = length(x_0);

for k = 0:N
    for jj = 0:P
        % generate random neighbour, defined as x(k+1) = x(k) + T(k)*u
        % direction is uniform(-1,1) random unit vector, step size is T(k)
        u_cand = (rand(x_dim,1)*2)-1;
        u_cand = u_cand/norm(u_cand);
        x_cand = x_curr + T_curr*u_cand;
        [z_cand, s_cand] = feval('obj_eval', M, H, mu, x_cand(1:end-1), x_cand(end));
        
        if z_cand < z_curr
            x_curr = x_cand;
            z_curr = z_cand;
            if z_cand < z_opt
                x_opt = x_cand;
                z_opt = z_cand;
                s_opt = s_cand;
            end
        else
            % probability of moving to a worse point to possibly escape
            % reaching a local instead of global minimum
            escape_prob = exp((z_curr-z_cand)/T_curr);
            if rand < escape_prob
                x_curr = x_cand;
                z_curr = z_cand;
            end
        end
    end
    T_curr = alpha*T_curr;
end

z = z_opt;
w = x_opt(1:end-1);
b = x_opt(end);
s = s_opt;

end