function [Q, c, A, b] = intialize_URS(M, H, mu)
% [Q, c, A, b] = initialize_URS(M, H, mu)
%
% H is for label = 1 
% M is for label = -1
%
% Initializes matrices of QP formulation accounting for Unrestricted Vars
%
% Q and c correspond to objective function parameters
% A and b correspond to constraint parameters

% Dimension of w will be same as the dimension for each xi = 70 (# columns
% of M) = wDim
% Dimension of s will be number of xi's = #rows of M + #rows of H = sDim (N
% in project description)
% Dimension of b is 1

HDim = size(H, 1); % # constraints for y = 1
MDim = size(M, 1); % # of constraints for y = -1
wDim = 2*size(M, 2); % Hardcode to reduce time? 2*70 accounts for w URS
sDim = HDim + MDim; % Total # constraints

totalDim = wDim + sDim + 2; % Total # of decision vars (2 accounts for b URS)

% Construct Q
Q = zeros(totalDim);
for ii = 1 : 2 : wDim 
   Q(ii, ii) = mu; 
   Q(ii+1, ii+1) = mu;
   Q(ii, ii+1) = -mu;
   Q(ii+1, ii) = -mu;
end

% Construct c
c = zeros(totalDim, 1);
for ii = wDim+1 : wDim + sDim
   c(ii) = 1/sDim; 
end

% Construct b
b = ones(sDim, 1);

% Construct H_expanded (for A) -> H expanded accordingly
H_expanded = zeros(HDim, wDim);

for ii = 1 : size(H, 2)
    H_expanded(:, 2*ii - 1) = H(:, ii);
    H_expanded(:, 2*ii) = -H(:, ii);
end

% Construct M_expanded (for A) -> M expanded accordingly
M_expanded = zeros(MDim, wDim);

for ii = 1 : size(M, 2)
    M_expanded(:, 2*ii - 1) = -M(:, ii);
    M_expanded(:, 2*ii) = M(:, ii);
end

% Construct A
A = [[H_expanded; M_expanded] eye(sDim) [ones(HDim, 1) -ones(HDim, 1); -ones(MDim, 1) ones(MDim, 1)]];

end

