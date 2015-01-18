function [ machine ] = loadOnMachineSocket( machine, task,bufNumber )
%LOADONBUF Summary of this function goes here
%   Detailed explanation goes here

if(machine.socket.task==0)
    machine.socket.task = task;
	machine.inputBuff(bufNumber).node.task = 0;
else
    error('no place in socket of machine');
end


end

