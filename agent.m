function [ zadanie ] = agent( Lista_sterowan, Lista_zadan)
%AGENT Funkcja implementuje agenta decyzyjnego sterownka zdarzeniowego
%   Agent przyjmuje jako paramtry kolejno:
%   
%   1. Lista_sterowan - lista zadań, jakie mogą być wykonane w danym kroku
%   czasowym. powinna składać się z listy obiektów typu Sterowanie
%
%   2. Lista_zadań - lista struktur zawierajaca:
%        .maszyny - lista numerów maszyn, na których będą wykonywane
%                   poszczególne etapy zadania
%        .czasy   - czasy wykonania poszczególnych etapów zadania

    rozmiar = max(size(Lista_zadan));
    
    zadanie = [];
    if rozmiar == 0
        return
    end
    
    if rozmiar == 1
        zadanie = Lista_zadan(1);
        return;
    end
    
    najlepsza_ocena = inf; % zadanie jest puste a ocena maksymalnie niekorzystna
    % przejrzyj listę zadań
    for i=1:rozmiar
        numer_zadania = Lista_sterowan(i).numer_zadania();        % odczytaj numer zadania
        liczba_etapow = size(Lista_zadan(numer_zadania).czasy,2); % odczytaj ile etapów ma zadanie 
        ocena = 0;
        for j=(Lista_sterowan(i).etap_zadania):liczba_etapow      % iteruj po pozostałych etapach zadaniach
            ocena = ocena +  Lista_zadan(numer_zadania).czasy(j); % zlicz czasy ich trwania
        end
        if ocena < najlepsza_ocena
            zadanie = Lista_zadan(i);                             % Zapisz nowe najlepsze zadanie
            najlepsza_ocena = ocena;                              % nadpisz ocenę
        end
    end
end

