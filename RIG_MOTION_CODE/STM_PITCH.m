function []=STM_PITCH(s1,PITCH_POS_ARR,STEPS_PER_ROT,TARGET_PITCHFREQ,STM_ACC)

PITCH_POS_ARR=round(PITCH_POS_ARR);

fprintf(s1, ['2EG',num2str(STEPS_PER_ROT)]);
fprintf(s1, ['2VE',num2str(TARGET_PITCHFREQ)]);

fprintf(s1, ['2AC',num2str(STM_ACC)]);
fprintf(s1, ['2DE',num2str(STM_ACC)]);

tic
%pause(5)
disp("Motion starts")
tic
for i=1:1:length(PITCH_POS_ARR)
%    if mod(n,)
%     fprintf(s1, "2EP");
%     p(i:5:10) = readline(s1)
%     toc
%     elapsedTimeP(i:5:10) = toc
    fprintf(s1, ['2FP',num2str(PITCH_POS_ARR(i))]);
end
toc
% length(motion_signal)
% ep = erase(p, "2EP=");
% np = double(ep);
% 
% phi = np / (4000 / 360);
% 
% plot(elapsedTimeP, phi)
pause(5)
