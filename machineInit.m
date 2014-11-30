function [ machine ] = machineInit(machineSize)
%MACHINEINIT Summary of this function goes here
%   Detailed explanation goes here

inputBuffSize = machineSize.i; 
outputBuffSize = machineSize.o; 
node = struct();
node.task = 0;
node.phase = 0; %1,2,3
node.time = 0;

machine = struct();

inputBuff = struct();
for i=1:inputBuffSize
    inputBuff(i).node = node;
end

outputBuff = struct();
for i=1:outputBuffSize
    outputBuff(i).node = node;
end

machine.inputBuff = inputBuff;
machine.socket = node;
machine.outputBuff = outputBuff;

end

