% Approximating sine curve using s curve

% Using Bhaskara I's approximation of sin x:
%{
syms x;
sine_f=(16*x*(pi-x))/(5*pi^2-4*x*(pi-x));
fplot(sine_f);

u = @(t) double(t>=0);
h = @(t) u(t-3);
g = @(t) u(t-4);

ff =@(t) h(t) - g(t); % just to demonstrate how it works
%f = @(t) integral(h,-Inf,Inf);
int_h=@(t) integral(ff,-Inf,Inf);

hold on;

fplot(ff,[0,10]);
fplot(int_h,[0,10]);

hold off;

%}

clear all
clc
clf

FREQ=0.1; %Hz
PERIOD=1/FREQ;

AMP_DEG=180; %DEG
AMP_RAD=(AMP_DEG/180)*pi;

TOTAL_CYCLE=10;

steps_per_r=20000;
steps_per_rad=steps_per_r/(2*pi);
steps_per_deg=steps_per_r/360;

resolution=100; % number of steps per cycle
DI=steps_per_rad*AMP_RAD;

ACC_T1=PERIOD/4;
DEC_T1=PERIOD/4;
ACC_T2=PERIOD/4;
DEC_T2=PERIOD/4;

ACC_M1=2;
DEC_M1=2;
ACC_M2=2;
DEC_M2=2;

Ta=ACC_T1;
Tb=Ta+DEC_T1;
Tc=Tb+ACC_T2;
Td=Tc+DEC_T2;

syms t w;
ACC_P1=ACC_M1*heaviside(t)-ACC_M1*heaviside(t-Ta);
DEC_P1=-DEC_M1*heaviside(t-Ta)+DEC_M1*heaviside(t-Tb);
ACC_P2=-1*(ACC_M2*heaviside(t-Tb)-ACC_M2*heaviside(t-Tc));
DEC_P2=-1*(-DEC_M2*heaviside(t-Tc)+DEC_M2*heaviside(t-Td));

ACCEL_PROFILE=ACC_P1+DEC_P1+ACC_P2+DEC_P2;
VEL_PROFILE=int(ACCEL_PROFILE);
POS_PROFILE=int(VEL_PROFILE);
POS_TRUE=12.5/2*sin(2*pi*FREQ*t+3*pi/2)+12.5/2;
POS_PROFILE_FUNC=fourier(POS_PROFILE);


hold on;
    fplot(ACCEL_PROFILE);
    fplot(VEL_PROFILE);
    fplot(POS_PROFILE);
    fplot(POS_TRUE);
hold off;


POS_FH=matlabFunction(POS_PROFILE);
disp(POS_FH);
%fplot(POS_FH);

T=0:0.01:25;
POS_ARR=POS_FH(T);
POS_FFT=fft(POS_ARR);
[POS_MIN,POS_MAX]=bounds(POS_ARR);
disp(POS_MIN);
disp(POS_MAX);
%plot(POS_ARR);



