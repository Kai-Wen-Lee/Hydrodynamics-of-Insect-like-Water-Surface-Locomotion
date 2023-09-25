function [POS_T]=ARR_MOD(ARR,TARR,END_TIME)

% Matrix manipulation to compine time array and positional array into one
% matrix, then delete rows where 0<=t<=end time

% Positional arrays
ARR_CHANGED=reshape(ARR,[numel(ARR),1]);

% Time arrays
TARR_CHANGED=reshape(TARR,[numel(TARR),1]);

% Combine time and positional arrays into a 1x2 multidim array
POS_T = cat(2,TARR_CHANGED, ARR_CHANGED);

% Delete rows where t < 0 and t > end time, round pos column to nearest
% whole number
POS_T=POS_T((POS_T(:,1) >=0) & (POS_T(:,1) <= END_TIME),:);
POS_T(:,2) = round(POS_T(:,2));

% Replace original positional arrays with edited ones
ARR_CHANGED=POS_T(:,2);