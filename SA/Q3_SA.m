function [z,b,w,p1,p2] = Q3_SA(combo_opt)

    [train,tune,~,~] = getFederalistData;
    [M, H] = getMH_tune_combo(train, tune, combo_opt);
    [z,b,w,p1,p2] = run_SA_Q3(M,H,0.1);
    
end