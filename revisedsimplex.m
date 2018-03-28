function [z,xb]= revisedsimplex()
%revised simplex is for maximize. if we want to minimize it we must
%multiply the objective by -1
b=[16;7];
c=[1;2];
A=[1 3 1 0; 1 1 0 1];
%xn=[;];
%xb=[;]
%iteration 0, set everything up first
N=A(:,1:size(A,2)/2);
B=A(:,1+size(A,2)/2:size(A,2));
ct=transpose(c);
ct=[ct zeros(1,size(ct,2))];
ctn=ct(:,1:size(ct,2)/2);
ctb=ct(:,1+size(ct,2)/2:size(ct,2));
enter=ctb*(B\N)-ctn;
temp=min(enter);
for i=1:size(enter,2)
    if temp==enter(i)
        temppos=i;
    end
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
%iterations beyond 0
%construct a while loop to create a process
%until we get our desired numbers
while(temp<=0) 
    %entering basis
B=[B(:,1:temppos) Ntemp(:,temppos) B(:,temppos+1:size(B,2))];
B(:, temppos)=[];
%leaving basis
N=[N(:,1:temp2pos) Btemp(:,temp2pos) N(:,temp2pos+1:size(N,2))];
N(:, temp2pos)=[];
A=[N B];
%entering basis
ctb=[ctb(:,1:temppos) ctntemp(:,temppos) ctb(:,temppos+1:size(ctb,2))];
ctb(:, temppos)=[];
%leaving basis
ctn=[ctn(:,1:temp2pos) ctbtemp(:,temp2pos) ctn(:,temp2pos+1:size(ctn,2))];
ctn(:, temp2pos)=[];
ct=[ctn ctb];
%^^^^^^this shit works up to this point ^^^^^^
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
xb=B\b;
z=ctb*xb;

end
