function [OSC_TIME_END]=STM_TRAPZONLY(PITCH_POS_ARR,STEPS_PER_ROT,TARGET_PITCHFREQ,STM_ACC,STM_DE)

writeline(s1, ['EG',num2str(STEPS_PER_ROT)]);
writeline(s1, ['VE',num2str(TARGET_PITCHFREQ)]);

% Set accel and deccel for actual motion
writeline(s1,['AC',num2str(STM_ACC)]);
writeline(s1,['DE',num2str(STM_DE)]);
%pause(5)

disp("Motion starts")

OSC_TIME_START=tic;
for i=1:1:length(PITCH_POS_ARR)
%    if mod(n,)
%     fprintf(s1, "2EP");
%     p(i:5:10) = readline(s1)
%     toc
%     elapsedTimeP(i:5:10) = toc
    writeline(s1, ['FP',num2str(PITCH_POS_ARR(i))]);
end

OSC_TIME_END=toc(OSC_TIME_START);
% length(motion_signal)
% ep = erase(p, "2EP=");
% np = double(ep);
% 
% phi = np / (4000 / 360);
% 
% plot(elapsedTimeP, phi)
pause(5)