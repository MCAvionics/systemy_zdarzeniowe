classdef Sterowanie
    %STEROWANIE Klasa implementuje pojedyńcze zdarzenie sterowania
    %   
    
    properties (GetAccess = private)
        typ;        % określa typ zadania: 1 - zaladuj do bufora maszyny obrobczej
                    %                      2 - przejazd wózkiem przez tranzycji
                    %                      3 - zaladunek wozka
                    %                      4 - obrobka detalu na maszynie
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
        function nr_maszyny = numer_maszyny(obj)
            nr_maszyny = obj.nr_maszyny;
        end
        function czy_rowne = eq(obj,obj2)
            czy_rowne = true;
            if (obj.typ ~= obj2.typ)
                czy_rowne = false;
            else if (obj.nr_maszyny ~= obj2.nr_maszyny)
                    czy_rowne = false;
                else if (obj.numer ~= obj2.numer)
                        czy_rowne = false;
                    else if (obj.etap ~= obj2.etap)
                            czy_rowne = false;
                        end
                    end
                end
            end
        end
    end
    
end

