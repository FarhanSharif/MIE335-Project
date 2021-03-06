function [z,b,w,p1,p2] = run_quadprog(M,H,mu)

    dataRow = size(M,1) + size(H,1);
    dataCol = size(M, 2);
    [Q, c, A, b, LB, UB] = intialize(M, H, mu);
    [X, z] = quadprog(Q, c, A, b, [], [], LB, UB, [], optimoptions('quadprog','Display', 'off'));
    % X has form [w; s; b]
    w = X(1:dataCol);
    s = X(dataCol+1 : dataCol+dataRow);
    b = X(end);
    
    % since y(wx+b) >= 1 - s, misclassified if LHS < 0 or s > 1
    p1 = sum(s > 1);
    
    % find p2 = # misclassified points from tune
    % tune is 20% of data input
    numTune = floor(dataRow*0.2);
    splitTune = floor(numTune/2);
    M_tune = M(end-splitTune:end, :);
    H_tune = H(end-(numTune-splitTune):end, :);
    [~, s_tune] = obj_eval(M_tune, H_tune, mu, w, b);
    p2 = sum(s_tune > 1);

end