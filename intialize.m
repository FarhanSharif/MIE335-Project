function [Q, c, A, b, LB, UB] = intialize(M, H, mu)
% [Q, c, A, b, LB, UB] = initialize(M, H, mu)
%
% H is for label = 1 
% M is for label = -1
%
% Initializes matrices of QP formulation
%
% Q and c correspond to objective function parameters
% A and b correspond to constraint parameters
% LB and UB are the decision variable bounds

% Dimension of w will be same as the dimension for each xi = 70 (# columns
% of M) = wDim
% Dimension of s will be number of xi's = #rows of M + #rows of H = sDim (N
% in project description)
% Dimension of b is 1

HDim = size(H, 1);
MDim = size(M, 1);
wDim = size(M, 2); % Hardcode to reduce time?
sDim = HDim + MDim;

totalDim = wDim + sDim + 1; % Total # of decision variables?

% Construct Q
Q = zeros(totalDim);
for ii = 1 : wDim 
   Q(ii) = mu; 
end

% Construct c
c = zeros(1, totalDim);
for ii = wDim+1 : wDim + sDim
   c(ii) = 1/sDim; 
end

% Construct b
b = -ones(sDim, 1);

% Construct A
A = [-H; M];
A = [A -eye(sDim)];
A = [A [-ones(HDim,1); ones(MDim,1)]];

% Construct LB
LB = [-Inf(wDim, 1); zeros(sDim, 1); -inf];

% Construct UB
UB = Inf(wDim + sDim + 1, 1);

end

