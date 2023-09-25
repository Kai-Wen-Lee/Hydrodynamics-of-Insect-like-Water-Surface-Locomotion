clc 
clear all
close all 
serialportlist("available")

%% Initialise serial port object

disp('Opening serial port communications');
s1 = serialport('COM6', 9600);            % Choose motor port
pause(0.25);
configureTerminator(s1, "CR");
s1.Terminator;

configureCallback(s1,"terminator",@readSerialData)

%%
writeline(s1,'JS0.5');
writeline(s1,'VE0.5');
disp('Speed Set');
pause(5);
disp('1MOTOR CJ');
writeline(s1,'1CJ');
pause(5);
disp('2MOTOR CJ');
writeline(s1,'2CJ');
pause(5);

writeline(s1,'1SJ');
pause(5);
writeline(s1,'2SJ');
pause(5);
writeline(s1,'FP0');

%% Functions
function readSerialData(src,~)
    data = readline(src);
    src.UserData = data;
    disp(data)
end

