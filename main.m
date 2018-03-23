function main()
% main() - main function, runs other methods

% Get data
[train,tune,test,dataDim] = getFederalistData;

% The above returns...
% train = 86x71 double
% tune = 20x71 double
% test = 12x70 double
% dataDim = 70

% First index of train and tune have labels
% 1 = Hamilton
% 2 = Madison

% We want to convert the labels to: 1 = Hamilton, 2 = Madison

end

