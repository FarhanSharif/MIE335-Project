function [z,b,w,p1,p2] = Q3_SM(combo_opt)

    [train,tune,~,~] = getFederalistData;
    [M, H] = getMH_tune_combo(train, tune, combo_opt);
    [z,b,w,p1,p2] = run_SM(M,H,0.1);
    
end