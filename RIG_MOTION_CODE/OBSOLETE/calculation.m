clear all;
clc;
clf;


N=1;

T1=1;
T2=2;
T3=3;
T4=4;
gap=5;
p=100;
tval=0:0.01:T4;
amp=10;
amp_b=10;
offset=-amp/2;
syms t real
z(t) = piecewise( ...
    (0 <= t <= T1),0, ...
    (T1 < t <= T2),amp*(t-T1), ...
    (T2 < t <= T3), amp*(T2-T1), ...
    (T3 < t <= T4),-amp*(t-T3)+amp);

%f(x) = 0, if (0 < x < t1); 
% a*(x-t1), if (t1 < x < t2); 
% a*(t2-t1), if (t2 < x < t3); 
% -b * (x-t3), if (t3 < x < p); 
% f(x-p), if (p < x);
arr=double(z(tval));
B=repmat(arr,1,N);
%B=B+offset;

tval_2=linspace(0,100,N*numel(tval));
plot(tval_2,B)