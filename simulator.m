% Przyk³adowa inicjalizacja informacji o sieci
clear;
M1=struct();
M2=struct();
M3=struct();
M4=struct();
LU=struct();

M1.i=1; M1.o=1;
M2.i=2; M2.o=1;
M3.i=1; M3.o=3;
M4.i=4; M4.o=4;
LU.i=1; LU.o=1;

machinesSize=[M1 M2 M3 M4 LU];
agvsNumber=1;

%inicjalizacja symulatora
[machines, agvs] = simInit(machinesSize, agvsNumber);
machines=vertcat(machines.machine); %inaczej jest problem z iterowaniem 
%uruchomienie zadania na maszynie

machines(1)= loadOnInputBuf( machines(1), 1, 3);

%³adowanie z bufora do maszyny
machines(1)= loadOnMachineSocket(machines(1), 3);

%³adowania z maszyny na wózek
%agv= loadOnAgv(machines(1), 3);


%przejazd z a do b






