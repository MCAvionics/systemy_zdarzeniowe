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
Lista_zadan(Sterowanie.numer_zadania()).ilosc(Sterowanie.numer_etapu()) = Lista_zadan(Sterowanie.numer_zadania()).ilosc(Sterowanie.numer_etapu()) - 1;
if( (Sterowanie.numer_etapu()+1) <= max(size(Lista_zadan(Sterowanie.numer_zadania()).ilosc)) ) 
    Lista_zadan(Sterowanie.numer_zadania()).ilosc(Sterowanie.numer_etapu()) = Lista_zadan(Sterowanie.numer_zadania()).ilosc(Sterowanie.numer_etapu()+1) + 1;
end
	

% ============================ Algorytm Bankiera ============================
Bankier = [ Wielkosc_buforow, Wielkosc_buforow, Wielkosc_buforow ]; % [ M1, M2, M3 ]

%wylicz max_zasobów
for i = 1:size(Lista_zadan,2) 
    IleZadan = IleZadanNaLiscie(Lista_zadan(i)); % liczy ile zadan typu "i" pozostalo do zrealizowania
    Lista_zadan(i).zasoby_etap = zeros(IleZadan,1);
    Lista_zadan(i).zasoby = zeros(IleZadan,3);   % tablica zadania x maszyny
    Lista_zadan(i).zasoby_max = Lista_zadan(i).zasoby;
    index_zas = 0;
    
        for j = 1:size(Lista_zadan(i).ilosc,2) % iteruj po etapach
            for k = 1:Lista_zadan(i).ilosc(j) % iteruj po ilosci sztuk detalu

    	        if(Lista_zadan(i).ilosc(j) > 0)
                    index_zas = index_zas + 1; % wez zasob
                end
                Lista_zadan(i).zasoby_etap( index_zas ) = j; % zapisz etap
    	        % dodaj detal do maszyny na ktorej aktualnie jest obrabiany
                if(j>1) 
                    Lista_zadan(i).zasoby( index_zas, Lista_zadan(i).maszyny(j-1)) = 1;
                end
    	        % oblicz maksymalne wymagane zasoby
                Bankier = Bankier - Lista_zadan(i).zasoby( index_zas, :);    
                for l = (j-1):size(Lista_zadan(i).ilosc,2)
                    if(l>0) 
                        % chciej po jednym miejscu w kazdej nastepnej wymaganej maszynie
                        Lista_zadan(i).zasoby_max( index_zas, Lista_zadan(i).maszyny(l)) = Lista_zadan(i).zasoby_max( index_zas, Lista_zadan(i).maszyny(l)) + 1;
                    end
                end
            end
        end
    
end
% #################################    DOTAD ZDEBUGOWANO    #################################

%Przydzielaj zasoby
while(IleZadanNaLiscie(Lista_zadan) > 0)
    przydzielono = false;
    for i = 1:size(Lista_zadan,2) 
        iterator = 0;

        while ( (~przydzielono) & (iterator <= size(Lista_zadan(i).zasoby_etap,1)))
	    iterator = iterator + 1;
	    if(prod( (Bankier -  (Lista_zadan(i).zasoby_max(iterator,:) - Lista_zadan(i).zasoby(iterator,:)) )) > 0 ) % sprawdz warunek bankiera
	        przydzielono = true;
		
		% oddaj jego zasoby
		Bankier = Bankier + Lista_zadan(i).zasoby;

		%usuń zadanie z listy
		Lista_zadan(i).ilosc(Lista_zadan(i).etap(iterator)) = Lista_zadan(i).ilosc(Lista_zadan(i).etap(iterator)) -1;
		Lista_zadan(i).etap(iterator)= [];
		Lista_zadan(i).zasoby(iterator,:)= [];
		Lista_zadan(i).zasoby_max(iterator,:)= [];
            end

        end

	if(przydzielono) % jeśli w pętli przydzielono to zakoncz for'a po liscie zadan
	   break;
	end
    end

    if(~przydzielono) 
        decyzja = false;
     	return;
    end
end

decyzja = true;
