function [x,y,z,time]=simulatedannealing()
loopcounter=0;
scalardeltaf=inf;
eps=0.00001;
tic
syms x y
f=0.5*x^2+3*x*y+5*y^2-x-2*y;
vec=[diff(f,x);diff(f,y)];
vec=matlabFunction(vec);
f=matlabFunction(f);
while(scalardeltaf>=eps)
%direction
%how tf do we hardcode it so we dont have to manually type x=1,... in
if loopcounter==0
x=0;
y=0;
else
xold=xnew;
x=xnew(1);
y=xnew(2); 
end
xold=[x;y];
deltaf=vec(x,y);
%do a loop statement later
scalardeltaf=sqrt(deltaf(1)^2+deltaf(2)^2);
d=-1*deltaf./scalardeltaf;
syms lam;
x=x+lam*d(1);
y=y+lam*d(2);
theta=f(x,y);
difftheta=diff(theta);
eqn=difftheta==0;
stepsize=solve(eqn,lam);
xnew=xold+stepsize*d;
loopcounter=loopcounter+1;
end
x=xnew(1);
y=xnew(2);
z=f(x,y);
time=toc;
end
