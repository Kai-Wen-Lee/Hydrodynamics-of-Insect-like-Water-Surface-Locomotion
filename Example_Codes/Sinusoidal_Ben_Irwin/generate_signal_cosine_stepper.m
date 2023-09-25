function [position,positionDeg,dt,t,pause_enc]=generate_signal_cosine_stepper(eg,frequency,amplitude,cycleNumber,points_per_cycle,stop_points)


endTime = (cycleNumber/frequency);
dt = (1/frequency)/round(points_per_cycle);
t = 0:dt:endTime;

time_1_cycle=(round(points_per_cycle)+1);
time_1_cycle;
position = round((sin(2*pi*frequency*t))*(amplitude*eg/360));
%%

%%

%%

% 

count_delete=0

 

count=0

incremental=diff(position);

for i=1:length(position)-1
    if (incremental(i)<stop_points) && (incremental(i)> -stop_points);
        pause_enc(i)=dt;
        count=count+1
    else
        pause_enc(i)=0;

    end
end
aa=length(position)
pause_enc(aa)=0;






positionDeg = position/(eg/60);
% plot(positionDeg)
% xlim([0, 1500]);

%dt=(revs_increments/(frequency));




%position = [position(points_per_cycle/4+1:end)]

