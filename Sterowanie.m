classdef Sterowanie
    %STEROWANIE Klasa implementuje pojedyńcze zdarzenie sterowania
    %   
    
    properties (GetAccess = private)
        typ;        % określa typ zadania: 1 - załaduj na gniazdo obróbcze,
                    %                      2 - przejazd wózkiem przez tranzycję
                    %                      3 - załadunek wózka
        nr_maszyny; % określa numer maszyny przy której zdarzenie wystąpiło
        numer;      % nr zadania
        etap;       % nr etapu zadania 
    end
    
    methods
        % Konstruktor
        function obj=Sterowanie(typ_zadania, numer_maszyny, numer_zadania, etap_realizacji)
            obj.typ = typ_zadania;
            obj.nr_maszyny = numer_maszyny;
            obj.numer = numer_zadania;
            obj.etap = etap_realizacji;
        end
        
        % weź typ zadania
        function zadanie = typ_zadania(obj)
            zadanie = obj.typ;
        end
        
        % weź numer zadania
        function numer = numer_zadania(obj)
           numer  = obj.numer;
        end
        
        % weź etap zadania
        function etap = etap_zadania(obj)
            etap = obj.etap;
        end
    end
    
end

