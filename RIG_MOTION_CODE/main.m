%{
Motion control script (MATLAB) for Honeybee Hydrofoil Locomotion Project

STEPPER MOTOR:      STM23S-3RE
Serial Protocol:    RS485
Baud Rate:          9600

PRE-REQUISITES (SOFTWARE):
    1. Symbolic Math Toolbox

TO DO:
    1.  ADD gearbox calculation on amplitude and speed
    3.  DO motor control (SCL commands)
    4.  ADD motor position monitoring
    5.  TUNE PPC using tic/toc parameters (more info needed)

kwl :>

%}

%% Clear & Close all Serial Ports to prevent conflicts
clc 
clf
clear all
close all 
serialportlist("available")

%% Initialise serial port object

disp('Opening serial port communications');
s1 = serialport('COM6', 9600);              % Choose motor port
pause(0.25);

configureTerminator(s1, "CR");              % Configure Terminator Bit to Carriage Change
s1.Terminator;

configureCallback(s1,"terminator",@readSerialData);

%% Input motor parameters

STEPS_PER_ROT = 20000;
STEPS_PER_DEG = STEPS_PER_ROT/360;

% AC, DE
STM_ACC = 500;
STM_DE = STM_ACC;
%% INPUTS

% Stroke motion AoA, frequency, period and get amplitude in units of steps
TARGET_STROKEALFA = 180;
TARGET_STROKEFREQ = 0.1;
STROKE_T = 1/TARGET_STROKEFREQ;
TARGET_STROKEAMP = TARGET_STROKEALFA*STEPS_PER_DEG;

% Pitch motion AoA, frequency, period and get amplitude in units of steps
TARGET_PITCHALFA = 180;
TARGET_PITCHFREQ = 0.1;
PITCH_T = 1/TARGET_PITCHFREQ;           % This is total pitching period, not to be confused with PITCH_H_T
TARGET_PITCHAMP = 2*TARGET_PITCHALFA*STEPS_PER_DEG;
PITCH_H_T = STROKE_T/6;                 % As per literature, duration of wing pitch stop time is 1/3 of half-stroke period

% Number of cycles to run
TARGET_CYCLES = 10;

%% OFFSETS
%{
For pitch temporal offset:
    -2*STROKE_T/6   =   Symmetrical case
    -3*STROKE_T/6   =   Advanced case
    -1*STROKE_T/6   =   Delayed case
%}

% STROKE OFFSETS
TARGET_STROKE_OFFSET = -2*pi/4;         % Phase offset (rad)

% PITCH OFFSETS
TARGET_PITCH_HOFF = -1*STROKE_T/6;      % Horizontal offset (t). NEGATIVE VALUES ONLY!
TARGET_PITCH_VOFF = 0;                  % Vertical offset (steps)

%% PPC

% Array pos elements per cycle (FROM BEN IRWIN, NEEDS ADDITIONAL TUNING)
POINTS_PER_CYCLE_STROKE=173.48*(TARGET_STROKEFREQ^2) - 507*(TARGET_STROKEFREQ) + 462.67+1;
% POINTS_PER_CYCLE_PITCH=173.48*(TARGET_PITCHFREQ^2) - 507*(TARGET_PITCHFREQ) + 462.67+1;
POINTS_PER_CYCLE_PITCH=1000;
%% Print inputs
% Give user a summary of input parameters
fprintf('Motor Parameters:\n');
fprintf('\t Steps per rotation: \t %g \n',STEPS_PER_ROT);
fprintf('\t Steps per degree: \t\t %g \n\n',STEPS_PER_DEG);
fprintf('\t Accel (rev/s^2): \t\t %g \n',STM_ACC);
fprintf('\t Deccel (rev/s^2): \t\t %g \n\n',STM_DE);

fprintf('Target Motion Profile Parameters:\n');
fprintf('\t Number of cycles: \t\t %g \n\n',TARGET_CYCLES);

fprintf('\t Stroking Motion:\n');
fprintf('\t Amplitude (deg):\t\t %g \n',TARGET_STROKEALFA);
fprintf('\t Frequency (Hz): \t\t %g \n',TARGET_STROKEFREQ);
fprintf('\t Period (s): \t\t\t %g \n',STROKE_T);
fprintf('\t STM Amp (steps): \t\t %g \n',TARGET_STROKEAMP);
fprintf('\t Phase offset: \t\t\t %g \n\n',TARGET_STROKE_OFFSET);

fprintf('Pitching Motion:\n');
fprintf('\t Amplitude (deg):\t\t %g \n',TARGET_PITCHALFA);
fprintf('\t Frequency (Hz): \t\t %g \n',TARGET_PITCHFREQ);
fprintf('\t Period (s): \t\t\t %g \n',PITCH_T);
fprintf('\t STM Amp (steps): \t\t %g \n',TARGET_PITCHAMP);
fprintf('\t Hold time (s): \t\t %g \n',PITCH_H_T);
fprintf('\t Temporal offset (s): \t %g \n',TARGET_PITCH_HOFF);
fprintf('\t Vertical offset (steps): \t %g \n\n',TARGET_PITCH_VOFF);

fprintf('PPC:\n');
fprintf('\t Stroke STM PPC: \t\t %g \n',POINTS_PER_CYCLE_STROKE);
fprintf('\t Pitch STM PPC: \t\t %g \n\n',POINTS_PER_CYCLE_PITCH);

% Add DE, AC

% Prompt the user with a yes/no question to allow for correction of
% parameters if necessary
userResponse = input('Do you want to continue with current parameters (Y/N)? ', 's');
if strcmpi(userResponse, 'Y')
    disp('Proceeding with current parameters ');

else
    disp('Terminating ...');
    clc 
    clf
    clear all
    close all 
    return;
end

%% Generate waveform and get position arrays

disp('Generating signal ... ');

[STROKE_POS_ARR,STROKE_DT,STROKE_TARR, END_TIME]=SIN_POS_SIGNAL_GEN(TARGET_STROKEAMP,TARGET_STROKEFREQ,TARGET_STROKE_OFFSET, TARGET_CYCLES,POINTS_PER_CYCLE_STROKE);
[PITCH_POS_ARR,PITCH_DT,PITCH_TARR]=TRAPZ_POS_SIGNAL_GEN(TARGET_PITCHAMP,PITCH_T,PITCH_H_T,TARGET_CYCLES,TARGET_PITCH_HOFF,TARGET_PITCH_VOFF,POINTS_PER_CYCLE_PITCH);

[STROKE_POS_T]=ARR_MOD(STROKE_POS_ARR,STROKE_TARR,END_TIME);
[PITCH_POS_T]=ARR_MOD(PITCH_POS_ARR,PITCH_TARR,END_TIME);

% Plot target motion profiles for easy visuallisation
disp('Plotting Target Motion profiles ... ');
hold on;
    plot(STROKE_POS_T(:,1),STROKE_POS_T(:,2));
    plot(PITCH_POS_T(:,1),PITCH_POS_T(:,2));
hold off;

% Prompt the user with a yes/no question to allow for correction of
% parameters if necessary
userResponse = input('Do you want to continue with current motion profiles(Y/N)? ', 's');
if strcmpi(userResponse, 'Y')
    disp('Proceeding with current motion profiles ... ');
else
    disp('Terminating ...');
    clc 
    clf
    clear all
    close all 
    return;
end

%% Stepper motor control (test code)

% Zero the position
disp('CJ TO ZERO');
writeline(s1,'VE0.5');
writeline(s1,'FP0');
% writeline(s1,'FP0');

disp('START MOTION');
pause(5);
STM_PITCH(s1,PITCH_POS_ARR,STEPS_PER_ROT,TARGET_PITCHFREQ,STM_ACC);
disp('MOTION ENDED');
pause(5);

disp('CJ TO ZERO');
% Jog back to zero
writeline(s1,'AC1');
writeline(s1,'DE1');
writeline(s1,'VE2');
writeline(s1,'FP0');
% writeline(s1,'FP0');


% %% Stepper motor control (calibration phase, TBD)
% 
% % Zero the position
% writeline(s1,'VE0.5');
% writeline(s1,'FP0');
% % writeline(s1,'FP0');
% 
% % Start motion
% % Prompt the user with a yes/no question to choose to do stroke + pitch or
% % pitch only
% userResponse = input('For STROKE & PITCH press (C), for PITCH only press (P)? ', 's');
% if strcmpi(userResponse, 'C')
%     disp('Calibrating for combined motion ... ');
%     STM_COMBINED()
%     [STROKE_POS_ARR,~,STROKE_TARR, END_TIME]=SIN_POS_SIGNAL_GEN(TARGET_STROKEAMP,TARGET_STROKEFREQ,TARGET_STROKE_OFFSET, 1,POINTS_PER_CYCLE_STROKE);
%     [PITCH_POS_ARR,~,PITCH_TARR]=TRAPZ_POS_SIGNAL_GEN(TARGET_PITCHAMP,PITCH_T,PITCH_H_T,1,TARGET_PITCH_HOFF,TARGET_PITCH_VOFF,POINTS_PER_CYCLE_PITCH);
%     [STROKE_POS_T]=ARR_MOD(STROKE_POS_ARR,STROKE_TARR,END_TIME);
%     [PITCH_POS_T]=ARR_MOD(PITCH_POS_ARR,PITCH_TARR,END_TIME);
% 
% elseif strcmpi(userResponse, 'P')
%     disp('Calibrating for pitch only motion ... ');
%     [PITCH_POS_ARR,~,PITCH_TARR]=TRAPZ_POS_SIGNAL_GEN(TARGET_PITCHAMP,PITCH_T,PITCH_H_T,1,TARGET_PITCH_HOFF,TARGET_PITCH_VOFF,POINTS_PER_CYCLE_PITCH);
%     [PITCH_POS_T]=ARR_MOD(PITCH_POS_ARR,PITCH_TARR,END_TIME);
%     [MOTION_T_C]=STM_TRAPZONLY(PITCH_POS_ARR,STEPS_PER_ROT,TARGET_PITCHFREQ,STM_ACC,STM_DE);
% 
% else
%     clc 
%     clf
%     clear all
%     close all 
%     return;
% end
% 
% % Pause when end
% % pause(2);
% 
% % Jog back to zero
% writeline(s1,'AC1');
% writeline(s1,'DE1');
% writeline(s1,'VE2');
% writeline(s1,'FP0');
% % writeline(s1,'FP0');

%% Functions
% Function to read STM23S-3RE callback
function readSerialData(src,~)
    data = readline(src);
    src.UserData = data;
    disp(data)
end
