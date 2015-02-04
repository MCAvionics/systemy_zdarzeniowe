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

machinesSize=[M1 M2 M3 M4 LU]; %lista maszyn
agvsNumber=1; %list wozkow

%inicjalizacja symulatora
[machines, agvs] = simInit(machinesSize, agvsNumber);
machines=vertcat(machines.machine); %inaczej jest problem z iterowaniem 

%% czesc sterownika i sieci
Lista_zadan(1).maszyny = [  1,  2,  3];
Lista_zadan(1).czasy   = [ 20,  8, 35];
Lista_zadan(1).ilosc   = [  5,  0,  0];

Lista_zadan(2).maszyny = [  2,  1,  2,  3];
Lista_zadan(2).czasy   = [  7, 14,  5, 40];
Lista_zadan(2).ilosc   = [  5,  0,  0,  0];


IleZadanNaStart = IleZadanNaLiscie(Lista_zadan(1));
IleZadanW_U = 0;

Wielkosc_buforow = 2;

z1 = Zadanie([1,2,3,4,5],[1,2,3,4,5],1);
z2 = Zadanie([2,3,4,1,5],[1,2,3,4,5],2);

p = PetriNet([z1,z2]); % Przyjmuje listÍ zadan
p = p.ustawRozmiarBuforowWejsciowych(1); % ustawiamy rozmiar buforÛw wejsciowych dla kazdej z maszyn
p = p.ustawRozmiarBuforowWyjsciowych(1); % ustawiamy rozmiar buforÛw wejsciowych dla kazdej z maszyn

%p = p.wykonajSterowanie(Sterowanie(3,5,1,1)); % zaladowanie wozka w LU

%Sterowanie(typ_zadania, numer_maszyny, numer_zadania, etap_realizacji)
%         typ;        % okre≈õla typ zadania: 1 - zaladuj do bufora maszyny obrobczej
%                     %                      2 - przejazd w√≥zkiem przez tranzycji
%                     %                      3 - zaladunek wozka
%                     %                      4 - obrobka detalu na maszynie
%         nr_maszyny; % okre≈õla numer maszyny przy kt√≥rej zdarzenie wystƒÖpi≈Ço
%         numer;      % nr zadania
%         etap;       % nr etapu zadania 

% u mnie
% task=0, puste
% task= task + 0.5 w trakcie realizacji
% task=1,2,3
%% przykladowa lista sterowan w postaci struktur, te same pola co w klasie Sterpwamoe
s1 = struct(); s2=struct();
s1.typ=1; s1.nr_maszyny=1; s1.numer=1; s1.etap=0;
s2.typ=4; s2.nr_maszyny=1; s2.numer=1; s2.etap=0;
s3.typ=1; s3.nr_maszyny=2; s3.numer=2; s3.etap=0;
s4.typ=4; s4.nr_maszyny=2; s4.numer=2; s4.etap=0;
%s1 = Sterowanie(1,1,1,1);
stery = [ s1 s2 s3 s4];

%parametry zdarzen
%0 - zaladowano na maszyne (na bufor wejsciowy, mozna ladowac na gniazdo)
%1 - wozek dojechal
%2 - wozek zaladowano
%4 - skonczono obroke - detal do odbioru z bufora wyjsciowego
%5 - brak nowych zdarzen
%6 - transport z maszyny do buf wy
%7 - detal gotowy do obrobki w gnieüdzie
listZdarzen = [5,5,5,5,5];

%% parametry symulacji
t=0;
endTime=15; %czas symulacji
bufInTime=2;
machineWork=3;
bufOutTime=1;
while(t<endTime)
    %aktualizacja stanu sieci, bez nowych zadan
    fprintf(strcat('t ', num2str(t) ,'\n'));   
    for i=1:5         
        %aktualizacja buforow wejsciowych     
        if (machines(i).inputBuff(1).node.task>0 && listZdarzen(i)==5)  %jesli jest jakies zadanie
            if (machines(i).inputBuff(1).node.time < bufInTime) 
                 machines(i).inputBuff(1).node.time= machines(i).inputBuff(1).node.time+1;
                 fprintf(strcat('ladowanie bufin maszyny:', num2str(i), '\n'));                 
            else
                 fprintf(strcat('zaladowano na bufin:', num2str(i), '\n'));  
                 machines(i).inputBuff(1).node.task=0;               
                 listZdarzen(i)=7;  %zaladowano na gniazdo
            end
        end  
        
        %aktualizacja gniazd obroczych             
        if (listZdarzen(i)==0)  % jesli jakies zadanie zostalo zaladowane
            if (machines(i).socket.time < machineWork)
                 machines(i).socket.time= machines(i).socket.time+1;
                 fprintf(strcat('obrobka na ', num2str(i), '\n'));                 
            else
                 fprintf(strcat('zakonczona obroka na ', num2str(i), '\n'));  
                 machines(i).socket.task=0;   
                 listZdarzen(i)=6; %transport z gniazda do wyjscia

            end                
        end

        %aktualizacja buforÛw wyjsciowych       
        if (listZdarzen(i)==6)  %jesli cos jest zrobione w gniezdzie
            if (machines(i).outputBuff(1).node.time < bufInTime) 
                 machines(i).outputBuff(1).node.time= machines(i).outputBuff(1).node.time+1;
                 fprintf(strcat('ladowanie bufout maszyny:', num2str(i), '\n'));                 
            else
                 fprintf(strcat('zaladowano na bufout:', num2str(i), '\n'));  
                 machines(i).outputBuff(1).node.task=0;               
                 listZdarzen(i)=4; %detal gotowy do odbioru
            end
        end   

    end         
    %rozpoczecie nowych dzialan sterownika
    %Sterowanie = agent(p.listaDostepnychSterowan(), Lista_zadan, Wielkosc_buforow)
    for ss=1:size(stery,2) 
        ster = stery(ss);  
        if (ster.typ==1) %ladowanie do bufora wejsciowego
            if  (machines(ster.nr_maszyny).inputBuff(1).node.task ==0)
                machines(ster.nr_maszyny)= loadOnInputBuf( machines(ster.nr_maszyny), 1, ster.numer);   
                fprintf(strcat('start ladowanie bufin maszyny:', num2str(ster.nr_maszyny) ,'\n'));    
            end
        end
        if(ster.typ==4 &&listZdarzen(ster.nr_maszyny)==7) %start obroki na maszynie
            if  (machines(ster.nr_maszyny).socket.task ==0 && ... %jeúli maszyna ma wolne
                    machines(ster.nr_maszyny).inputBuff(1).node.task > 0) % i sa gotowe zadania na wejsciu             
                machines(ster.nr_maszyny)= loadOnMachineSocket( machines(ster.nr_maszyny), 1, ster.numer);   
                fprintf(strcat('start obrobka na ', num2str(ster.nr_maszyny) ,'\n'));    
                
                machines(ster.nr_maszyny).inputBuff(1).node.task=0; %oproznienie bufora wejsciego
                listZdarzen(ster.nr_maszyny)=0;

            end 
        end
    end
      
    %end %koniec sterowan
    fprintf(strcat('lista zdarzen:', num2str(listZdarzen) ,'\n'));    
    
    %listZdarzen = [5,5,5,5,5]; %zerowanie eventow
    t = t+1;
    pause(1);
    
end





