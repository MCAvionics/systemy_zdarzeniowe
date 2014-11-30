function [ machine ] = loadOnMachineSocket( machine, task )
%LOADONBUF Summary of this function goes here
%   Detailed explanation goes here

if(machine.socket.task==0)
    machine.socket.task = task;
else
    error('no place in socket of machine');
end


end

