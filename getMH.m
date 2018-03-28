function [M, H] = getMH(train)
% [M, H] = getMH(train)
% Splits train data into M and H matrices (splits Madison and Hamilton)

% First index of train has labels 1 = Hamilton, 2 = Madison

% We want to convert the labels to: 1 = Hamilton, -1 = Madison

% For each data point in train...
% if label = 1, put data in H, if label = 2, put data in M

H = [];
M = [];

for ii = 1 : size(train, 1)
    
   currentRow = train(ii, :);
   
   if currentRow(1) == 1
       % Put data from 2,: in H
       H = [H; currentRow(2:size(currentRow,2))];
       
   elseif currentRow(1) == 2
       % Put data from 2,: in M
       M = [M; currentRow(2:size(currentRow,2))];
       
   end
    
end


end

