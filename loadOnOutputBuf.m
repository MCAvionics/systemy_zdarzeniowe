function [ machine ] = loadOnInputBuf(machine, bufNumber, task )
%LOADONBUF Summary of this function goes here
%   Detailed explanation goes here

if(machine.outputBuff(bufNumber).node.task==0)
    machine.outputBuff(bufNumber).node.task = task;
    
else
    error('no place in output buffer of machine');
end


end