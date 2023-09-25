clc 
clear all
close all 

%%Closing the serial port
% disp('Closing the serial port')
% a = instrfind();
% fclose(a)
% delete(a)
% clear a 
serialportlist("available")

%% Initialise serial port object
disp('Opening serial port communications');
s1 = serialport('COM6', 9600);            % Choose motor port

fopen(s1);                      % Open the port
pause(0.25);
configureTerminator(s1, "CR");
s1.Terminator;

%fprintf(s1, "1EP0"); %reset motor positions
%fprintf(s1, "2EP0");
fprintf(s1, 'IFD');

% fprintf(s1, 'AC0.1'); 
% fprintf(s1, 'DE0.1'); 
% fprintf(s1, 'VE1');
% %fprintf(s1, 'DI-250');
% %fprintf(s1, '2FL');
% 
% %only the first time
% fprintf(s1, '2FP0');
% pause(5);
% % % % 
% 

%% 

%%%%% THINGS TO CHANGE %%%%%%%%

rpm = 10; %rpm of rotor
rps = rpm/60; %rps of rotor
jog_vel = rps * 2.28590664; %rps of motor
exp_mot_rpm = rpm * 2.28590664; %rpm of motor

frequency = 0.5;
amplitude_deg = 180;
cycleNumber = 10;

%%%%% THINGS TO CHANGE %%%%%%%%


stop_points=0;
eg = 25000; %STEPS PER REV
amplitude = amplitude_deg*pi/180;
points_per_cycle=173.48*(frequency^2) - 507*(frequency) + 462.67+1;
acceleration=500;
    
pause(1)


%% SELECT MOTION TYPE

%motion_function_jogging(s1,eg,jog_vel)
%pause(10);
%motion_function_triangular(s1,cycleNumber,amplitude_deg,eg,frequency)
[motion_signal,motion_signal_deg,dt,t,pause_enc]=generate_signal_cosine_stepper(eg,frequency,amplitude_deg,cycleNumber,points_per_cycle,stop_points);
motion_function_cosine_incremental(s1,motion_signal,dt,eg,amplitude_deg,frequency,pause_enc,acceleration)
fprintf(s1, 'SJ');
 %% MOTOR 1 BEHAVIOUR FEEDBACK
% pause(5)
% % fprintf(s1, '1SJ');
% 
% %1
% tic
% for i = 1:1000
%     fprintf(s1, '1IP'); %commands motor to give position
%     p(i) = readline(s1); %reads motor postion
%     toc
%     elapsedTimeP = toc;
%     fprintf(s1, '1IV');
%     v(i) = readline(s1); %reads motor velocity
%     toc;
%     elapsedTimeV(i) = toc;
%     pause(0.01)
% end
% 
% fprintf(s1, '1SJ');
% pause(10);
% 
% for i = 10:20:990
%     freq(i) = elapsedTimeV(i);
% end
% nzFreq = nonzeros(freq);
% 
% ev = erase(v, "1IV="); %removes unnecessary characters from string array
% ep = erase(p, "1IP="); 
% nv = double(ev); %converts string array to number array
% np = double(ep);
% 
% for n = 10:20:990
%     sampleMean(n) = mean(nv(n:n+10));
% end
% nzMean = nonzeros(sampleMean);
% 
% a = mean(nv)
% 
% rpm = 65; %rpm of rotor
% rps = rpm/60; %rps of rotor
% jog_vel = rps * 2.28590664; %rps of motor
% exp_mot_rpm1 = rpm * 2.28590664 %rpm of motor
% motion_function_jogging(s1,eg,jog_vel)
% pause(10)
% 
% %2
% tic
% for i = 1:1000
%     fprintf(s1, '1IP'); %commands motor to give position
%     p1(i) = readline(s1); %reads motor postion
%     toc
%     elapsedTimeP1 = toc;
%     fprintf(s1, '1IV'); %commands motor to give velocity
%     v1(i) = readline(s1); %reads motor velocity
%     toc
%     elapsedTimeV1(i) = toc;
%     pause(0.01);
% end
% 
% fprintf(s1, '1SJ');
% pause(10);
% 
% for i = 10:20:990
%     freq1(i) = elapsedTimeV1(i);
% end
% nzFreq1 = nonzeros(freq1);
% 
% ev1 = erase(v1, "1IV="); %removes unnecessary characters from string array
% ep1 = erase(p1, "1IP="); 
% nv1 = double(ev1); %converts string array to number array
% np1 = double(ep1);
% 
% for n = 10:20:990
%     sampleMean1(n) = mean(nv1(n:n+10));
% end
% nzMean1 = nonzeros(sampleMean1);
% 
% b = mean(nv1)
% 
% rpm = 120; %rpm of rotor
% rps = rpm/60; %rps of rotor
% jog_vel = rps * 2.28590664; %rps of motor
% exp_mot_rpm2 = rpm * 2.28590664 %rpm of motor
% motion_function_jogging(s1,eg,jog_vel)
% 
% pause(10)
% 
% %3
% tic
% for i = 1:1000
%     fprintf(s1, '1IP'); %commands motor to give position
%     p2(i) = readline(s1); %reads motor postion
%     toc;
%     elapsedTimeP2 = toc;
%     fprintf(s1, '1IV'); %commands motor to give velocity
%     v2(i) = readline(s1); %reads motor velocity
%     toc;
%     elapsedTimeV2(i) = toc;
%     pause(0.01);
% end
% 
% fprintf(s1, '1SJ');
% pause(10);
% 
% for i = 10:20:990
%     freq2(i) = elapsedTimeV2(i);
% end
% nzFreq2 = nonzeros(freq2);
% 
% ev2 = erase(v2, "1IV="); %removes unnecessary characters from string array
% ep2 = erase(p2, "1IP="); 
% nv2 = double(ev2); %converts string array to number array
% np2 = double(ep2);
% 
% for n = 10:20:990
%     sampleMean2(n) = mean(nv2(n:n+10));
% end
% nzMean2 = nonzeros(sampleMean2);
% 
% c = mean(nv2)
% 
% %% PLOTTING MOTOR FEEDBACK GRAPHS
% 
% psi = np / (eg / 360);
% psi1 = np1 / (eg / 360);
% psi2 = np2 / (eg / 360);
% 
% t = tiledlayout(3,2);
% title(t,"Motor Feedback");
% 
% %1
% nexttile
% plot(psi);
% title("Angular displacement") ;
% 
% nexttile
% plot(nzFreq, nzMean);
% xlim([0 80])
% xlabel("Time elapsed (s)")
% ylabel("Velocity (rpm)")
% ylim([0 50]);
% hold on
% yline(exp_mot_rpm);
% title("Expected velocity of 23 rpm");
% 
% %2
% nexttile
% plot(psi1);
% title("Position");
% 
% nexttile
% plot(nzFreq1, nzMean1);
% xlim([0 80])
% xlabel("Time elapsed (s)")
% ylabel("Velocity (rpm)")
% ylim([125 175]);
% hold on
% yline(exp_mot_rpm1);
% title("Expected velocity of 149 rpm");
% 
% %3
% nexttile
% plot(psi2);
% title("Position");
% 
% nexttile
% plot(nzFreq2, nzMean2);
% xlim([0 80])
% xlabel("Time elapsed (s)")
% ylabel("Velocity (rpm)")
% ylim([250 300]);
% hold on
% yline(exp_mot_rpm2);
% title("Expected velocity of 274 rpm");
% hold off
% %% 
% expx = [exp_mot_rpm exp_mot_rpm1 exp_mot_rpm2]
% exp = [exp_mot_rpm exp_mot_rpm1 exp_mot_rpm2]
% actual = [a b c]
% scatter(expx, actual)
% xlabel('Expected velocity (rpm)')
% ylabel("Velocity (rpm)")
% hold on
% scatter(expx, exp)
% legend("Actual", "Expected", "Location", "southeast")
% hold off
%% 


% disp('Closing the serial port')
% a = instrfind();
% fclose(a)
% delete(a)



% % %%
% clear all
% close all
