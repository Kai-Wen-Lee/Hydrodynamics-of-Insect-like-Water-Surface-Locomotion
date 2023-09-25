%% Clear all before starting
clear all;
clc;
clf;

%% Input motor parameters

STEPS_PER_ROT = 20000;
STEPS_PER_DEG = 360/STEPS_PER_ROT;

%% Input desired freq + amplitude + number of cycles + !!offset
% Get amplitude in steps + period

% Input
TARGET_STROKEALFA = 60;
TARGET_STROKEFREQ = 0.1;

TARGET_PITCHALFA = 30;
TARGET_PITCHFREQ = 0.1;

TARGET_CYCLES = 10;

% Calculate in terms of steps
TARGET_STROKEAMP = TARGET_STROKEALFA*STEPS_PER_DEG;
TARGET_PITCHAMP = TARGET_PITCHALFA*STEPS_PER_DEG;

% Calculate period
STROKE_T = 1/TARGET_STROKEFREQ;
PITCH_T = 1/TARGET_PITCHFREQ;

%% Governing equations

syms t;
STROKE_MOTION = TARGET_STROKEAMP*sin(2*pi*TARGET_STROKEFREQ*t+3*pi/2)+TARGET_STROKEAMP;
STROKE_VEL_PROFILE = diff(STROKE_MOTION);
STROKE_ACC_PROFILE = diff(STROKE_VEL_PROFILE);

hold on;
    fplot(STROKE_MOTION,[0,10]);
    fplot(STROKE_VEL_PROFILE,[0,10]);
    fplot(STROKE_ACC_PROFILE,[0,10]);
hold off;

%% Iterate to obtain appriopriate step acceleration duration and magnitude