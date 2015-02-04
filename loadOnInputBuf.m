function [ machine ] = loadOnInputBuf(machine, bufNumber, task )
%LOADONBUF Summary of this function goes here
%   Detailed explanation goes here

if(machine.inputBuff(bufNumber).node.task==0)
    machine.inputBuff(bufNumber).node.task = task;
    machine.inputBuff(bufNumber).node.time = 0;
    
else
    error('no place in input buffer of machine');
end


end

