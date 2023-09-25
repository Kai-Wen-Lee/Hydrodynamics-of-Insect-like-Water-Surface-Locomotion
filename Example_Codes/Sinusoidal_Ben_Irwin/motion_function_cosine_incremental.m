function []=motion_function_cosine_incremental(s1,motion_signal,dt,eg,amplitude_deg,frequency,pause_enc,acceleration)

fprintf(s1, ['2EG',num2str(eg)]);
fprintf(s1, ['2VE',num2str(frequency)]);



fprintf(s1, ['2AC',num2str(acceleration)]);
fprintf(s1, ['2DE',num2str(acceleration)]);

tic
%pause(5)
disp("Motion starts")
tic
for i=1:1:length(motion_signal);
%    if mod(n,)
%     fprintf(s1, "2EP");
%     p(i:5:10) = readline(s1)
%     toc
%     elapsedTimeP(i:5:10) = toc
    fprintf(s1, ['2FP',num2str(motion_signal(i))]);
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
