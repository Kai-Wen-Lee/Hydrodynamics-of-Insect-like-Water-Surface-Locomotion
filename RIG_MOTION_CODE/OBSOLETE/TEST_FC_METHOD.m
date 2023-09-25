%{
Motion control script (MATLAB) for Honeybee Hydrofoil Locomotion Project

STEPPER MOTOR:      STM23S-3RE
Serial Protocol:    RS485
Baud Rate:          9600

kwl :>

%}

%% Clear & Close all Serial Ports to prevent conflicts
clc 
clear all
close all 
serialportlist("available")

%% Initialise serial port object

disp('Opening serial port communications');
s1 = serialport('COM5', 9600);              % Choose motor port
pause(0.25);

configureTerminator(s1, "CR");              % Configure Terminator Bit to Carriage Change
s1.Terminator;

configureCallback(s1,"terminator",@readSerialData);

%% Excecute 
% Input freq, amplitude
% Output AC, DE, VE
FREQ=2; %Hz
AMP_DEG=180; %DEG
AMP_RAD=(AMP_DEG/180)*pi;

TOTAL_CYCLE=100;

steps_per_r=20000;
steps_per_rad=steps_per_r/(2*pi);
steps_per_deg=steps_per_r/360;

resolution=100; % number of steps per cycle

DI=steps_per_rad*AMP_RAD;
time_ARR=linspace(0,TOTAL_CYCLE/FREQ, resolution*(TOTAL_CYCLE/FREQ));

POS=AMP_RAD*steps_per_rad*sin(2*pi*FREQ*time_ARR);
POS_R=POS/(steps_per_r);
VEL_STEPS=gradient(POS,time_ARR);       % Velocity in terms of steps/sec
VEL_R=gradient(POS_R,time_ARR);         % Velocity in terms of rps
ACC_R=gradient(VEL_R,time_ARR);         % Acceleration in rps

plot(time_ARR,VEL_STEPS);
% Return to zero:
writeline(s1, 'FP0');

% Run motion
for i=1:5000
    writeline(s1,['AC',num2str(round(VEL_R(i)))]);
    writeline(s1,['VE',num2str(round(ACC_R(i)))]);
    writeline(s1, ['FL',num2str(round(POS(i)))]);
end

% Reset to zero again
writeline(s1, 'FP0');

%% Functions

% Function to read STM23S-3RE callback
function readSerialData(src,~)
    data = readline(src);
    src.UserData = data;
    disp(data)
end
