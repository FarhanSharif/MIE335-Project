function [z,xb]= revisedsimplex()
%revised simplex is for maximize. if we want to minimize it we must
%multiply the objective by -1
b=[18;42;24];
c=[3;2];
A=[2 1 1 0 0;2 3 0 1 0;3 1 0 0 1];

%iteration 0, set everything up first
%to initialize non basic matrix, split based on how many variables there are in the obj function 
%could also be seen as the left hand side of A
N=A(:,1:size(c,1));
%the right hand side of A.
B=A(:,1+size(c,1):size(A,2));
%transpose the c variable
ct=transpose(c);
%we are adding 0s to create the basic component of ct
%the number of 0s is the same number of the rows of A because there are 3
%constraints, indicated by the row length of A
ct=[ct zeros(1,size(A,1))];
%split into non basic, the non zero terms, and basic, the zero terms. Non
%basic could be interpreted once again as the left hand side, and basic as
%the right hand side
ctn=ct(:,1:size(c,1));
ctb=ct(:,1+size(c,1):size(ct,2));
%find the matrix of values entering matrix
enter=ctb*(B\N)-ctn;
%finds the value of the minimum value entering matrix
temp=min(enter);
%temppos finds the position of the minimum value in the matrix
for i=1:size(enter,2)
    if temp==enter(i)
        temppos=i;
    end
end
%finding ae, what we will use to find the matrix of the departing values    
ae=N(:,temppos);
%finds the matrix for the departing values
exit=B\b./(B\ae);
%note to self: make sure the ratios are all positive and bounded
%finds the minimum value of all the departing values
temp2=min(exit);
%convert to horizontal form to make the loop easier
exitt=exit';
%temp2pos is the position of the departing variable
for j=1:size(exitt,2)
    if temp2==exitt(j)
        temp2pos=j;
    end
end
%creating temporary matrices to make the update of the basis easier
Btemp=B;
Ntemp=N;
ctbtemp=ctb;
ctntemp=ctn;
%iterations beyond 0
%construct a while loop to create a process
%until we get the objective value
while(temp<0) 
    %entering basis
B=[B(:,1:temp2pos) Ntemp(:,temppos) B(:,temp2pos+1:size(B,2))];
B(:, temp2pos)=[];
%leaving basis
N=[N(:,1:temppos) Btemp(:,temp2pos) N(:,temppos+1:size(N,2))];
N(:, temppos)=[];
A=[N B];
%entering basis
ctb=[ctb(:,1:temp2pos) ctntemp(:,temppos) ctb(:,temp2pos+1:size(ctb,2))];
ctb(:, temp2pos)=[];
%leaving basis
ctn=[ctn(:,1:temppos) ctbtemp(:,temp2pos) ctn(:,temppos+1:size(ctn,2))];
ctn(:, temppos)=[];
ct=[ctn ctb];
%repeat process of finding entering and departing variables
%very similar to above method
enter=ctb*(B\N)-ctn;
temp=min(enter);
for i=1:size(enter,2)
    if temp==enter(i)
        temppos=i;
    end
end
  if temp>=0
    break
  end  
ae=N(:,temppos);
exit=B\b./(B\ae);
temp2=min(exit);
exitt=exit';
for j=1:size(exitt,2)
    if temp2==exitt(j)
        temp2pos=j;
    end
end
Btemp=B;
Ntemp=N;
ctbtemp=ctb;
ctntemp=ctn;
end
%finds the values of optimal variables and objective value
xb=B\b;
z=ctb*xb;

end











