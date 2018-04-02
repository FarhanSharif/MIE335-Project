function [z,b,w,p1,p2,combo_opt] = Q3_quadprog

    [train,tune,~,~] = getFederalistData;
    % generate all combos
    numCols = size(train,2)-1;
    combos = combnk(1:numCols, 2);
    
    z_opt = inf;   %some arbitrary large number
    b_opt = [];
    w_opt = [];
    p1_opt = [];
    p2_opt = [];
    combo_opt = [];
    
    for ii = 1:size(combos,1)
        [M, H] = getMH_tune_combo(train, tune, combos(ii,:));
        [z_cand,b_cand,w_cand,p1_cand,p2_cand] = run_quadprog(M,H,0.1);
        
        if z_cand < z_opt
            z_opt = z_cand;   %some arbitrary large number
            b_opt = b_cand;
            w_opt = w_cand;
            p1_opt = p1_cand;
            p2_opt = p2_cand;
            combo_opt = combos(ii,:);
        end
    end
    
    z = z_opt;   %some arbitrary large number
    b = b_opt;
    w = w_opt;
    p1 = p1_opt;
    p2 = p2_opt;
    
end