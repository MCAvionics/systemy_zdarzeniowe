%==========================================================================
% Plik z testami do sieci petriego
%==========================================================================

% Wykonuje przykladowe sterowanie (przejazd wozka 

% typ zadania - 2
% maszyna przy ktorej wystapuje zdarzenie - 1
% nr maszyny - 2
% nr zadania - 1
% etap zadania zadania - 1
clear;
z1 = Zadanie([1,2,3,4,5],[1,2,3,4,5]);
z2 = Zadanie([2,3,4,5,1],[1,2,3,4,5]);

s = Sterowanie(2, 2, 1, 1); % wozek powinien jechaæ do maszyny 1, jest przy maszynie 2 wiec powinien jechac do maszyny 3
p = PetriNet([z1,z2]); % Przyjmuje listê zadan
p.wykonajSterowanie(s);
lista = p.ListaDostepnychSterowan();