function Q1_quadprog()

[train,tune,test,dataDim] = getFederalistData;
[M, H] = getMH_tune(train, tune);

for mu = [0 0.001 0.01 0.1 1 10 100]

    mu

    [z,b,w,p1,p2] = run_quadprog(M,H,mu)
    
    w_2 = sum(w.*w)
    
    for paper = 1 : 12
        
        x = test(paper, :);
        
        paper
        
        margin = x*w + b
        
        if (margin > 0)
            author = 'Hamilton'
        
        elseif (margin < 0)
            author = 'Madison'
        
        end
    end
end


end

