function [z, w, b, s] = SA_recursive(M, H, mu, x_0, T_0, alpha, N, P, R)

% Do SA with minimal (N, P) to get a better starting point then iterate
% Resets the step size moves actually have chance to escape, R = # resets
% Yields better results quicker, but diminishes after R > 2
% Can cut down time vs running once with larger (N, P)
% N = 200, P = 1000 are adequate start parameters

[z, w, b, s] = feval('SA', M, H, mu, x_0, T_0, alpha, N, P);

for ii = 1:R
    fprintf('Iter %d: z = %.4f, b = %.4f\n', ii, z, b)
    [z, w, b, s] = feval('SA', M, H, mu, [w;b], T_0, alpha, N+ii*100, P+ii*3000);
end
fprintf('Iter %d: z = %.4f, b = %.4f\n', R+1, z, b)

end