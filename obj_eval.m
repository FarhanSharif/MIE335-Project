function z = obj_eval(M, H, mu, w, b)

% evaluates the SVM objective value given inputs
% M, H contain the feature vector for 1 paper in each row
% solution (w,b), w is a column vector, b is scalar

% s is a column vector = [s values for H; s values for M]
% s = max{0, 1-y(wx+b)}, y = 1 for H, -1 for M
% s for H matrix only
s = [ones(size(H,1),1)-(H*w)-(b*ones(size(H,1),1))];
% add in s for M matrix
s = [s; ones(size(M,1),1)+(M*w)+(b*ones(size(M,1),1))];
s(s < 0) = 0;

% min z = mean(s) + (mu/2)*w'*w
z = mean(s) + (mu/2)*(w' * w);

end