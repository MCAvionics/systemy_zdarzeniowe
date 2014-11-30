classdef PetriNet                                                          %=================================================================================== 
    properties(GetAccess=private)                                          % 1 wiersz sieci to transport do maszyny 1
        ListaZadan = [];                                                   % 2 wiersz sieci to transport do maszyny 2
        Siec = zeros(11,5);                                                % 3 wiersz sieci to transport do maszyny 3
        ListaDostepnychSterowan = [];                                      % 4 wiersz sieci to transport do maszyny 4
        ListaSkonczonychZadan = [];
    end                                                                    % 5 wiersz sieci to transport do LU
    methods(Access=public)                                                 % 6 wiersz sieci to oznaczenie miejsca z pustym wó¿kiem
        function obj = PetriNet(listaZadan)                                % 7 wiersz sieci to bufory wejœciowe dla ka¿dej z maszyn
            obj.ListaZadan = listaZadan;                                   % 8 wiersz sieci to liczby pustych miejsc w buforach wejœciowych dla ka¿dej z maszyn
            obj.Siec(6,5) = 1; % domyslnie jeden pusty wozek przy LU
            for i = 1:length(obj.ListaZadan)
                obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan Sterowanie(3,5,obj.ListaZadan(i).numer(),1)]; % dodajemy mozliwosc zaladunku detalu w LU
            end
            obj.Siec(10,1) = 1; % domyslnie wszystkie maszyny sa dostepne
            obj.Siec(10,2) = 1;
            obj.Siec(10,3) = 1;
            obj.Siec(10,4) = 1;
        end                                                                % 9 wiersz sieci to liczby pustych miejsc w buforach wyjœciowych dla ka¿dej z maszyn
                                                                           % 10 wiersz sieci to dostepnosc maszyn
                                                                           % 11 wiersz sieci to obrobka na maszynie       
        function obj = ustawRozmiarBuforowWejsciowych(obj, rozmiar)
            obj.Siec(8,1) = rozmiar;
            obj.Siec(8,2) = rozmiar;
            obj.Siec(8,3) = rozmiar;
            obj.Siec(8,4) = rozmiar;
        end
        function obj = ustawRozmiarBuforowWyjsciowych(obj, rozmiar)
            obj.Siec(9,1) = rozmiar;
            obj.Siec(9,2) = rozmiar;
            obj.Siec(9,3) = rozmiar;
            obj.Siec(9,4) = rozmiar;
        end
        function obj = wykonajSterowanie(obj, sterowanie)
            czy_znaleziono = 0;
            
            j=1;
            for i=1:length(obj.ListaDostepnychSterowan)
                if (obj.ListaDostepnychSterowan(i) == sterowanie)
                    czy_znaleziono = 1;
                else
                    obj.ListaDostepnychSterowan(j) = obj.ListaDostepnychSterowan(i);
                    j = j+1;
                end
            end
            obj.ListaDostepnychSterowan = obj.ListaDostepnychSterowan(1:j-1);
            assert(czy_znaleziono == 1,'Sterowania nie mozna wykonac');
            typ_zadania = sterowanie.typ_zadania;                          
            numer_zadania = sterowanie.numer_zadania;                      
            nr_maszyny = sterowanie.numer_maszyny;
            etap = sterowanie.etap_zadania;
            if (typ_zadania == 1)
                obj = zaladujDetalNaMaszyne(obj, numer_zadania, etap, nr_maszyny);
            else if (typ_zadania == 2)
                    obj = wykonajTransport(obj, numer_zadania, etap, nr_maszyny);
                else if (typ_zadania == 3)
                        obj = zaladujWozek(obj, numer_zadania, etap, nr_maszyny);
                    else if (typ_zadania == 4)
                            obj = WykonajObrobke(obj, numer_zadania, etap, nr_maszyny);
                        end
                    end
                end
            end
        end
        function lista = listaDostepnychSterowan(obj)
            lista = obj.ListaDostepnychSterowan;
        end
    end
    methods(Access=private)
        function obj = WykonajObrobke(obj, numer_zadania, etap, nr_maszyny)
            obj.Siec(10, nr_maszyny) = 1; % odblokowanie dostep do maszyny
            obj.Siec(11, nr_maszyny) = 0; % zglaszamy ze element nie jest obrabiany na maszynie
            obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(3, nr_maszyny, numer_zadania, etap+1)]; % zglaszamy mozliwosc zaladunku i zwiekszamy etap o 1
        end
        function obj = zaladujDetalNaMaszyne(obj, numer_zadania, etap, nr_maszyny)
            if (obj.Siec(10, nr_maszyny) == 1 && obj.Siec(9,nr_maszyny) > 0) % maszyna jest dostepna i jest meiejsce w buforze wyjsciowym
                obj.Siec(10, nr_maszyny) = 0; % blokujemy dostep do maszyny
                obj.Siec(9, nr_maszyny) = obj.Siec(9, nr_maszyny) - 1; % zmniejszamy liczbe miejsc w buforze wyjsciowym o 1
                obj.Siec(8, nr_maszyny) = obj.Siec(8, nr_maszyny) + 1; % zmniejszamy liczbe miejsc w buforze wejsciowym o 1
                obj.Siec(11, nr_maszyny) = 1; % zglaszamy ze element jest obrabiany na maszynie
                obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(4, nr_maszyny, numer_zadania, etap)]; % zglaszamy mozliwosc obrobki
            end
            if (nr_maszyny == 5 && etap == 5)
                obj.Siec(9,5) = obj.Siec(9,5) + 1;
               obj.ListaSkonczonychZadan = [obj.ListaSkonczonychZadan, numer_zadania];
               lista_zadan_do_zrobienia = obj.ListaZadan;
               for i = 1:length(obj.ListaSkonczonychZadan)
                    k=1;
                    for j=1:length(lista_zadan_do_zrobienia)
                        if (lista_zadan_do_zrobienia(j).numer() ~= obj.ListaSkonczonychZadan(i))
                            lista_zadan_do_zrobienia(k) = lista_zadan_do_zrobienia(j);
                            k = k+1;
                        end
                    end
                    lista_zadan_do_zrobienia = lista_zadan_do_zrobienia(1:k-1);
               end
               for i=1:length(lista_zadan_do_zrobienia)
                    obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(3, 5, lista_zadan_do_zrobienia(i).numer(), 1)];
               end
            end
        end
        function obj = zaladujWozek(obj, numer_zadania, etap, nr_maszyny)
            maszyna_docelowa = obj.ListaZadan(numer_zadania).maszyna(etap); % okresla wiersz w tabeli z siecia petriego
            if (obj.Siec(6, nr_maszyny) == 1 && obj.Siec(8, maszyna_docelowa) > 0) %sprawdzamy czy mamy pusty wozek przy maszynie i czy jest miejsce w buforze wejsciowym maszyny docelowej
                obj.Siec(6, nr_maszyny) = 0; % ladujemy wozek(likwidujemy pusty)
                obj.Siec(8, maszyna_docelowa) = obj.Siec(8, maszyna_docelowa) - 1; % zmniejszamy liczbe dostepnych miejsc w buforze wejsciowym maszyny docelowej o 1
                obj.Siec(maszyna_docelowa, nr_maszyny) = 1;
                if (nr_maszyny ~= 5)
                    obj.Siec(8, nr_maszyny) = obj.Siec(8, nr_maszyny) + 1; % zwiekszamy miejsce w buforze wejsciowym dla maszyny kora opuszcza detal
                end
            end
            lista_dostepnych = [];
            j=1;
            for i=1:length(obj.ListaDostepnychSterowan)
                if (obj.ListaDostepnychSterowan(i).typ_zadania() ~= 3 || obj.ListaDostepnychSterowan(i).numer_maszyny() ~= nr_maszyny)
                    lista_dostepnych(j) = obj.ListaDostepnychSterowan(i);
                    j = j+1;
                end
            end
            obj.ListaDostepnychSterowan = [lista_dostepnych, Sterowanie(2, nr_maszyny, numer_zadania, etap)]; % dodajemy mozliwe zadanie transportowe do sterowan
        end
        function obj = wykonajTransport(obj, nr_zadania, etap_zadania, nr_maszyny)
            maszyna_docelowa = obj.ListaZadan(nr_zadania).maszyna(etap_zadania); % okresla wiersz w tabeli z siecia petriego
            obj = wykonajPrzejazd(obj, nr_maszyny, maszyna_docelowa);
            if (nr_maszyny ~= 5)
                if (nr_maszyny + 1 ~= maszyna_docelowa)
                    obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(2, nr_maszyny+1, nr_zadania, etap_zadania)]; % transport dalej po petli
                else
                    obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(1, nr_maszyny+1, nr_zadania, etap_zadania)]; % zaladunek na maszyne
                end
            else
                if (maszyna_docelowa == 1)
                    obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(1, 1, nr_zadania, etap_zadania)]; % zaladunek na maszyne
                else
                    obj.ListaDostepnychSterowan = [obj.ListaDostepnychSterowan, Sterowanie(2, 1, nr_zadania, etap_zadania)]; % transport dalej po petli
                end
            end
        end
        function obj = wykonajPrzejazd(obj, maszyna_aktualna, maszyna_docelowa)
            if (maszyna_docelowa == 1)
                obj = wykonajPrzejazdDoMaszyny1(obj, maszyna_aktualna);
            else if (maszyna_docelowa == 2)
                    obj = wykonajPrzejazdDoMaszyny2(obj, maszyna_aktualna);
                else if (maszyna_docelowa == 3)
                        obj = wykonajPrzejazdDoMaszyny3(obj, maszyna_aktualna);
                    else if (maszyna_docelowa == 4)
                        obj = wykonajPrzejazdDoMaszyny4(obj, maszyna_aktualna);
                        else if (maszyna_docelowa == 5)
                                obj = wykonajPrzejazdDoLU(obj, maszyna_aktualna);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny1(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1DoM1(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2DoM1(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3DoM1(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4DoM1(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUDoM1(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny2(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1DoM2(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2DoM2(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3DoM2(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4DoM2(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUDoM2(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny3(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1DoM3(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2DoM3(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3DoM3(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4DoM3(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUDoM3(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny4(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1DoM4(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2DoM4(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3DoM4(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4DoM4(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUDoM4(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoLU(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1doLU(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2DoLU(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3DoLU(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4DoLU(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUDoLU(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = TranzycjaM1DoM1(obj)
            if (obj.Siec(1,1) == 1);
                Obj.Siec(1,1) = 0;
                Obj.Siec(6,1) = 1; %pusty wozek przy maszynie 1
                Obj.Siec(7,1) = 1; %detal w buforze wejœciowym maszyny 1
            end
        end
        function obj = TranzycjaM2DoM1(obj)
            if (obj.Siec(1,2) == 1)
                obj.Siec(1,2) = 0;
                obj.Siec(1,3) = 1;
            end;
        end
        function obj = TranzycjaM3DoM1(obj)
            if (obj.Siec(1,3) == 1)
                obj.Siec(1,3) = 0;
                obj.Siec(1,4) = 1;
            end;
        end
        function obj = TranzycjaM4DoM1(obj)
            if (obj.Siec(1,4) == 1)
                obj.Siec(1,4) = 0;
                obj.Siec(1,5) = 1;
            end;
        end
        function obj = TranzycjaLUDoM1(obj)
            if (obj.Siec(1,5) == 1)
                obj.Siec(1,5) = 0;
                obj.Siec(1,1) = 1;
            end;
        end
        function obj = TranzycjaM1DoM2(obj)
            if (obj.Siec(2,1) == 1)
                obj.Siec(2,1) = 0;
                obj.Siec(2,2) = 1;
            end;
        end
        function obj = TranzycjaM2DoM2(obj)
            if (obj.Siec(2,2) == 1);
                Obj.Siec(2,2) = 0;
                Obj.Siec(6,2) = 1; %pusty wozek przy maszynie 2
                Obj.Siec(7,2) = 1; %detal w buforze wejœciowym maszyny 2
            end
        end
        function obj = TranzycjaM3DoM2(obj)
            if (obj.Siec(2,3) == 1)
                obj.Siec(2,3) = 0;
                obj.Siec(2,4) = 1;
            end;
        end
        function obj = TranzycjaM4DoM2(obj)
            if (obj.Siec(2,4) == 1)
                obj.Siec(2,4) = 0;
                obj.Siec(2,5) = 1;
            end;
        end
        function obj = TranzycjaLUDoM2(obj)
            if (obj.Siec(2,5) == 1)
                obj.Siec(2,5) = 0;
                obj.Siec(2,1) = 1;
            end;
        end
        function obj = TranzycjaM1DoM3(obj)
            if (obj.Siec(3,1) == 1)
                obj.Siec(3,1) = 0;
                obj.Siec(3,2) = 1;
            end;
        end
        function obj = TranzycjaM2DoM3(obj)
            if (obj.Siec(3,2) == 1)
                obj.Siec(3,2) = 0;
                obj.Siec(3,3) = 1;
            end;
        end
        function obj = TranzycjaM3DoM3(obj)
            if (obj.Siec(3,3) == 1);
                Obj.Siec(3,3) = 0;
                Obj.Siec(6,3) = 1; %pusty wozek przy maszynie 3
                Obj.Siec(7,3) = 1; %detal w buforze wejœciowym maszyny 3
            end
        end
        function obj = TranzycjaM4DoM3(obj)
            if (obj.Siec(3,4) == 1)
                obj.Siec(3,4) = 0;
                obj.Siec(3,5) = 1;
            end;
        end
        function obj = TranzycjaLUDoM3(obj)
            if (obj.Siec(3,5) == 1)
                obj.Siec(3,5) = 0;
                obj.Siec(3,1) = 1;
            end;
        end
        function obj = TranzycjaM1DoM4(obj)
            if (obj.Siec(4,1) == 1)
                obj.Siec(4,1) = 0;
                obj.Siec(4,2) = 1;
            end;
        end
        function obj = TranzycjaM2DoM4(obj)
            if (obj.Siec(4,2) == 1)
                obj.Siec(4,2) = 0;
                obj.Siec(4,3) = 1;
            end;
        end
        function obj = TranzycjaM3DoM4(obj)
            if (obj.Siec(3,3) == 1)
                obj.Siec(3,3) = 0;
                obj.Siec(3,4) = 1;
            end;
        end
        function obj = TranzycjaM4DoM4(obj)
            if (obj.Siec(4,4) == 1);
                Obj.Siec(4,4) = 0;
                Obj.Siec(6,4) = 1; %pusty wozek przy maszynie 4
                Obj.Siec(7,4) = 1; %detal w buforze wejœciowym maszyny 4
            end
        end
        function obj = TranzycjaLUDoM4(obj)
            if (obj.Siec(4,5) == 1)
                obj.Siec(4,5) = 0;
                obj.Siec(4,1) = 1;
            end;
        end
        function obj = TranzycjaM1DoLU(obj)
            if (obj.Siec(5,1) == 1)
                obj.Siec(5,1) = 0;
                obj.Siec(5,2) = 1;
            end;
        end
        function obj = TranzycjaM2DoLU(obj)
            if (obj.Siec(5,2) == 1)
                obj.Siec(5,2) = 0;
                obj.Siec(5,3) = 1;
            end;
        end
        function obj = TranzycjaM3DoLU(obj)
            if (obj.Siec(5,3) == 1)
                obj.Siec(5,3) = 0;
                obj.Siec(3,4) = 1;
            end
        end
        function obj = TranzycjaM4DoLU(obj)
            if (obj.Siec(3,4) == 1)
                obj.Siec(3,4) = 0;
                obj.Siec(3,5) = 1;
            end;
        end
        function obj = TranzycjaLUDoLU(obj)
            if (obj.Siec(5,5) == 1);
                Obj.Siec(5,5) = 0;
                Obj.Siec(6,5) = 1; %pusty wozek przy maszynie LU
                Obj.Siec(7,5) = Obj.Siec(7,5)+1; %detal w buforze wejœciowym maszyny LU
            end
        end
    end
end