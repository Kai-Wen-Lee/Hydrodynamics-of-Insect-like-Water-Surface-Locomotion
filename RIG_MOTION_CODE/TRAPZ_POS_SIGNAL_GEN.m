% Contains functions to generate trapezoidal motion
% Input: Cycle, offset h + v, period, tarr, amp
% Output: Position array 

function[pos,dt,ttot]=TRAPZ_POS_SIGNAL_GEN(TARGET_PITCHAMP,PITCH_T,PITCH_H_T,TARGET_CYCLES,TARGET_PITCH_HOFF,TARGET_PITCH_VOFF,POINTS_PER_CYCLE_PITCH)

T1=PITCH_H_T;
T2=((PITCH_T-(2*PITCH_H_T))/2)+T1;
T3=PITCH_H_T+T2;
T4=((PITCH_T-(2*PITCH_H_T))/2)+T3;
dt=PITCH_T/round(POINTS_PER_CYCLE_PITCH);
tval=0:dt:T4;
TARGET_CYCLES=TARGET_CYCLES+1;
ttot=linspace(0+TARGET_PITCH_HOFF,(TARGET_CYCLES)*T4+TARGET_PITCH_HOFF,(TARGET_CYCLES)*numel(tval));

syms t real
z(t) = piecewise( ...
    (0 <= t <= T1),0, ...
    (T1 < t <= T2),TARGET_PITCHAMP/(T2-T1)*(t-T1), ...
    (T2 < t <= T3), TARGET_PITCHAMP, ...
    (T3 < t <= T4),-TARGET_PITCHAMP/(T4-T3)*(t-T3)+TARGET_PITCHAMP);


pos_1c=double(z(tval));
pos=repmat(pos_1c,1,TARGET_CYCLES);
pos=pos-TARGET_PITCHAMP/2+TARGET_PITCH_VOFF;