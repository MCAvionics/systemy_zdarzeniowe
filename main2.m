clear;
%%czesc symulatora
M1=struct();
M2=struct();
M3=struct();
M4=struct();
LU=struct();

M1.i=1; M1.o=1; %bufory wejsciowe i wyjsciiowe
M2.i=1; M2.o=1;
M3.i=1; M3.o=1;
M4.i=1; M4.o=1;
LU.i=1; LU.o=1;

machinesSize=[LU M1 M2 M3 M4]; %lista maszyn
agvsNumber=1; %list wozkow

%inicjalizacja symulatora
[machines, agvs] = simInit(machinesSize, agvsNumber);
machines=vertcat(machines.machine); %inaczej jest problem z iterowaniem 

%% struktura Marcina
%Sterowanie(typ_zadania, numer_maszyny, numer_zadania, etap_realizacji)
%         typ;        % określa typ zadania: 1 - zaladuj do bufora maszyny obrobczej
%                     %                      2 - przejazd wózkiem przez tranzycji
%                     %                      3 - zaladunek wozka
%                     %                      4 - obrobka detalu na maszynie
%         nr_maszyny; % określa numer maszyny przy której zdarzenie wystąpiło


%% przykladowa lista sterowan w postaci struktur, te same pola co w klasie Sterowanie
s1 = struct(); s2=struct();
s1.typ=2; s1.nr_maszyny=2; s1.numer=1; s1.etap=0; %wozek sie przemieszcza
s2.typ=1; s2.nr_maszyny=2; s2.numer=1; s2.etap=0; %wozek laduje towar
s3.typ=3; s3.nr_maszyny=2; s3.numer=1; s3.etap=0; %nastepuje obrobka
s4.typ=2; s4.nr_maszyny=4; s4.numer=1; s4.etap=0; %wozek jedzie do nastepnej maszyny
%w nastepnej maszynie
%s5.typ=2; s5.nr_maszyny=3; s5.numer=1; s5.etap=1; %wozek sie przemieszcza
s5.typ=1; s5.nr_maszyny=4; s5.numer=1; s5.etap=1; %wozek laduje towar
s6.typ=3; s6.nr_maszyny=4; s6.numer=1; s6.etap=1; %nastepuje obrobka
s7.typ=2; s7.nr_maszyny=5; s7.numer=1; s7.etap=1; %nastepuje obrobka

s0.typ=2; s0.nr_maszyny=1; s0.numer=1; s0.etap=2; %nastepuje obrobka
stery = [s1  s2 s3 s4 s5 s6 s7 s0];
%stery = [s1 s2 s3  s0];

listaZdarzen = [0,0,0; %buf we, gniazdo, buf wy
                0,0,0;
                0,0,0;
                0,0,0;
                0,0,0;
                0,1,1]; %wozek: stan, maszyna, segment

%parametry wozka
%0 - nic sie nie dzieje
%1 - wozek w ruchu

%parametery maszyn
%0 - nic sie nie dzieje 
%1 - nastepuje ladowanie lub zmiana stanu
%2 - zakonczono ladowanie

%% parametry symulacji
t=0;
endTime=50; %czas symulacji
bufInTime=2; %czas w buforach we
machineWork=3; %czas obrobki
bufOutTime=1; %czas w buforach wy

while(t<endTime)
    fprintf(strcat('t ', num2str(t) ,'\n'));   
    eval=0;
    docel=0;
    for ss=1:size(stery,2)      
        ster = stery(ss);          
        if(ster.typ==2) %przejdz tranzyje

            if(listaZdarzen(6)==0) % && agvs(1).agv.machine< ster.nr_maszyny) %wozek pojedzie dalej jesli nic nie robil
                agvs.agv(1).departureTime=3;   % i jesli nie trafil do tej maszyny, ktorej chcial
                listaZdarzen(6)=1;
                eval=ss;
            end           
        end    
        if (ster.typ==1) %ladowanie do bufora wejsciowego
            %wozek musi byc na miejscu,musi dojechac do bufora, bufor musi byc wolny
            if  (machines(ster.nr_maszyny).inputBuff(1).node.task ==0 && ...
                    agvs.agv(1).machine== ster.nr_maszyny && agvs.agv(1).segment == 1 && ...
                       listaZdarzen(6,1)==0)
                %ustawienie nowego zadania obrabianego, zerowanie czasu
                machines(ster.nr_maszyny) = loadOnInputBuf(machines(ster.nr_maszyny),1, ster.numer);
                fprintf(strcat('start ladowanie bufin maszyny:', num2str(ster.nr_maszyny) ,'\n'));
                listaZdarzen(ster.nr_maszyny,1)=1;
                listaZdarzen(6,1)=1; %wozek musi stac zeby mozna bylo go rozladowac
            end
        end            
        if (ster.typ==3) %rozpoczecie oborki
            %bufor we musi byc zaladowany, gniazdo musi byc wolne
            if( machines(ster.nr_maszyny).inputBuff(1).node.task >0 && machines(ster.nr_maszyny).socket.task==0 &&  ...
                listaZdarzen(ster.nr_maszyny,1)==2 )                        
                fprintf(strcat('start obrobka na ', num2str(ster.nr_maszyny) ,'\n'));    
                machines(ster.nr_maszyny) = loadOnMachineSocket(  machines(ster.nr_maszyny), 1, ster.numer );
                listaZdarzen(ster.nr_maszyny,2)=1;   %rozpoczecie obroki 
                listaZdarzen(ster.nr_maszyny,1)=0;   %zerowanie bufora we                
            end
        end 
    end              
    if(eval~=0)       %usuwanie tranzycji z ruchem, tak aby zadzia�a�o nawracanie
        %wznawiaja one ruch, gdy gdy wozek nie jest u celu
        if(stery(eval).typ==2 && agvs(1).agv.machine==stery(eval).nr_maszyny-1)
            newSter = stery;
            newSter(eval)=[];
            stery=newSter;
        elseif  (stery(eval).typ==2 && agvs(1).agv.machine==5 && stery(eval).nr_maszyny==1)
            newSter = stery;
            newSter(eval)=[];
            stery=newSter;
        end
    end

    for i=1:5     
        %obsluga ruchu wozka
        %wozek jest na danej maszynie i dostal polecenie o ruchu
        if(agvs.agv(1).machine==i && agvs.agv(1).departureTime>0 && listaZdarzen(6)==1)
            if (agvs.agv(1).departureTime>1) %jesli wozek ma sie ruszac
                 agvs.agv(1).departureTime = agvs.agv(1).departureTime - 1;
                 fprintf(strcat('ruch wozka:', num2str(i), '\n'));  
            else
                 agvs.agv(1).departureTime = agvs.agv(1).departureTime - 1;
                 if(agvs.agv(1).machine<5)
                    agvs.agv(1).machine=i+1;
                 else
                    agvs.agv(1).machine=1;
                 end
                 fprintf(strcat('wozek dojechal do:', num2str(agvs.agv(1).machine), '\n'));                    
                 listaZdarzen(6,:)=[0,agvs.agv(1).machine,1];  
                 agvs.agv(1).segment=1;
            end
        end 
         %aktualizacja buforow wejsciowych  
         %w buforze jest wozek, bufor ma wolne miejsce i jest zadanie do
         %wykonania
        if (machines(i).inputBuff(1).node.task>0 && ...% listaZdarzen(i)==5 && ...
            agvs.agv(1).segment==1 && agvs.agv(1).machine==i)  %jesli jest jakies zadanie i wozek jest z detalem dla tej maszyny
            if (machines(i).inputBuff(1).node.time < bufInTime) 
                 machines(i).inputBuff(1).node.time= machines(i).inputBuff(1).node.time+1;
                 fprintf(strcat('ladowanie bufin maszyny:', num2str(i), '\n'));    
            else
                 fprintf(strcat('zaladowano na bufin:', num2str(i), '\n'));  
                 %machines(i).inputBuff(1).node.task=0;      
                 agvs.agv(1).segment=2;
                 listaZdarzen(i,1)=2;  %zaladowano na gniazdo              
                 listaZdarzen(6,3)=2; %wozek przemieszcza sie na bufor wyjsciowy
            end
        end
        
        %aktualizacja gniazd obroczych     
        if (listaZdarzen(i,2)>0)  % jesli jakies zadanie zostalo zaladowane
            if (machines(i).socket.time < machineWork)
                 machines(i).socket.time= machines(i).socket.time+1;
                 fprintf(strcat('obrobka na ', num2str(i), '\n')); 
            else
                 fprintf(strcat('zakonczona obrobka na ', num2str(i), '\n'));                 
                 listaZdarzen(i,2)=2; %transport z gniazda do wyjscia
            end                
        end       
        %jesli zadanie zostalo obrobione i bufor wy jest wolny to nastepuje
        %ladowanie
        if (listaZdarzen(i,2)==2 && machines(i).outputBuff(1).node.task==0)  
            if (machines(i).outputBuff(1).node.time < bufInTime) 
                 machines(i).outputBuff(1).node.time= machines(i).outputBuff(1).node.time+1;
                 fprintf(strcat('ladowanie bufout maszyny:', num2str(i), '\n'));            
                 listaZdarzen(i,3)=1; %rozpoczecie procesu ladowania na wyjscie
            else
                 fprintf(strcat('zaladowano na bufout:', num2str(i), '\n'));  
                 machines(i).outputBuff(1).node.task=0;    
                 machines(i).socket.task=0;   
                 listaZdarzen(i,2)=0; %usuwanie z gniazda
                 listaZdarzen(i,3)=0; %detal gotowy do odbioru           
                 listaZdarzen(6,1)=0; %wozek moze jechac

            end
        end 
  
    end  
        
    %end %koniec sterowan
    fprintf(strcat('LU:',num2str(listaZdarzen(1,:)) ,'\n'));    
    fprintf(strcat('M1:',num2str(listaZdarzen(2,:)) ,'\n'));  
    fprintf(strcat('M2:',num2str(listaZdarzen(3,:)) ,'\n')); 
    fprintf(strcat('M3:',num2str(listaZdarzen(4,:)) ,'\n'));
    fprintf(strcat('M4:',num2str(listaZdarzen(5,:)) ,'\n'));
    fprintf(strcat('Wz:',num2str(listaZdarzen(6,:)) ,'\n\n'));
    t = t+1;
    pause(1);
    
end





