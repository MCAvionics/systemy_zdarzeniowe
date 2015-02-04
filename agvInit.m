function [ agv ] = agvInit( start_machine )
%AGVINIT Summary of this function goes here
%   Detailed explanation goes here
agv = struct();
agv.segment = 1;
agv.departureTime = 0;
agv.machine = start_machine; 

end

