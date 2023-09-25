function []=motion_function_jogging(s1,eg, jog_vel)

writeline(s1, ['2EG20',num2str(eg)]);
writeline(s1, '2DI20');
writeline(s1, '2JA0.1');
writeline(s1, '2JL0.1');
writeline(s1, ['2JS',num2str(jog_vel)]);
writeline(s1, '2CJ');
disp(eg);
disp(jog_vel);
disp(s1);


% tic
% fprintf(s1, '1IV'); %command encoder to give us velocity
% v0(i) = readline(s1); %reads motor velocity
% toc;
% elapsedTimeV(i) = toc; 




