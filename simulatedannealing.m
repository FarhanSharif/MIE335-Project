function [x,y,z]=simulatedannealing()
eps=0.001;

syms x y
f=0.5*x^2+3*x*y+5*y^2-x-2*y;
vec=[diff(f,x);diff(f,y)];
%direction
%how tf do we hardcode it so we dont have to manually type x=1,... in
x=0;
y=0;
xold=[x;y];
deltaf=eval(vec);
%do a loop statement later
scalardeltaf=sqrt(deltaf(1)^2+deltaf(2)^2);
d=-1*deltaf./scalardeltaf;
syms lam;
x=x+lam*d(1);
y=y+lam*d(2);
theta=eval(f);
difftheta=diff(theta);
eqn=difftheta==0;
stepsize=solve(eqn,lam);
xnew=xold+stepsize*d;
while(scalardeltaf>=eps)
    
    xold=xnew;
    syms x y
f=0.5*x^2+3*x*y+5*y^2-x-2*y;
vec=[diff(f,x);diff(f,y)];
%direction
%how tf do we hardcode it so we dont have to manually type x=1,... in
x=xnew(1);
y=xnew(2);
xold=[x;y];
deltaf=eval(vec);
%do a loop statement later
scalardeltaf=sqrt(deltaf(1)^2+deltaf(2)^2);
d=-1*deltaf./scalardeltaf;
syms lam;
x=x+lam*d(1);
y=y+lam*d(2);
theta=eval(f);
difftheta=diff(theta);
eqn=difftheta==0;
stepsize=solve(eqn,lam);
xnew=xold+stepsize*d;
end
x=xnew(1);
y=xnew(2);
z=eval(f);
end
