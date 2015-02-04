function [machines, agvs] = simInit(machinesSize , agvsNumber)

machines=struct();
machinesNumber = size(machinesSize,2);
for i=1: machinesNumber
    machines(i).machine = machineInit(machinesSize(i));
end

agvs= struct();

% for i=1:agvsNumber %default the last machine will be the start machine
%     agvs(i).agv = agvInit(machines(machinesNumber).machine);
% end

%for i=1:agvsNumber %default the last machine will be the start machine
agvs(1).agv = agvInit(1);
%end

end