function[]=STM_JOGTOSTART(POS_ARR)

% FP to starting pos with slow ACCEL AND DE AND VE
writeline(s1,'AC1');
writeline(s1,'DE1');
writeline(s1,'VE2');
writeline(s1,['FP',num2str(POS_ARR(1))]);