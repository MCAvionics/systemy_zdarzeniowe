function decyzja = AlgBankiera(Lista_zadan,Sterowanie, Wielkosc_buforow)
%ALGBANKIERA Funkcja implementuje algorytm bankiera dla maszyn z zadania
%   Agent przyjmuje jako paramtry kolejno:
%   
%   1. Lista_sterowan - lista zadań, jakie mogą być wykonane w danym kroku
%   czasowym. Powinna składać się z listy obiektów typu Sterowanie
%
%   2. Lista_zadań - lista struktur zawierajaca:
%        .maszyny - lista numerów maszyn, na których będą wykonywane
%                   poszczególne etapy zadania
%        .czasy   - czasy wykonania poszczególnych etapów zadania

if(Sterowanie.typ_zadania() ~= 4)
    decyzja = true;
end

% Wykonaj sterowanie
Lista_zadan(Sterowanie.numer_zadania()).ilosc(Sterowanie.numer_etapu());
	

% algorytm bankiera
Bankier = [ Wielkosc_buforow, Wielkosc_buforow, Wielkosc_buforow ]; % [ M1, M2, M3 ]

%wylicz max_zasobów
for i = 1:size(Lista_zadan,2) 
    Lista_zadan(i).ilosc_max = Lista_zadan(i).ilosc;
    for j = 1:size(Lista_zadan.ilosc,2)
        if(j>2)
    	    Lista_zadan(i).ilosc_max(j) = Lista_zadan(i).ilosc_max(j) + Lista_zadan(i).ilosc_max(j-1);
    	end 
    end
end

for 
