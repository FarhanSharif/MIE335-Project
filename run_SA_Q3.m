function [z,b,w,p1,p2] = run_SA_Q3(M,H,mu)

    % for Q3, not as many iters needed -> R = 1

    dataRow = size(M,1) + size(H,1);
    dataCol = size(M, 2);
    [z, w, b, s] = SA_recursive(M, H, mu, zeros(dataCol+1, 1), 1, 0.95, 200, 1000, 1);
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