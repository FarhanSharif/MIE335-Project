function [M, H] = getMH_tune(train, tune)
% [M, H] = getMH(train)
% Splits train data into M and H matrices (splits Madison and Hamilton)
% edit: input both train and tune data and split 20% for tune later

% First index of train has labels 1 = Hamilton, 2 = Madison

% We want to convert the labels to: 1 = Hamilton, -1 = Madison

% For each data point in train...
% if label = 1, put data in H, if label = 2, put data in M

all = [train; tune];

H = all(all(:,1) == 1, 2:end);
M = all(all(:,1) == 2, 2:end);

end

