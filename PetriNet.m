classdef PetriNet                                                          %=================================================================================== 
    properties(GetAccess=private)                                          % 1 wiersz sieci to transport do maszyny 1
        ListaZadan                                                         % 2 wiersz sieci to transport do maszyny 2
        Siec                                                               % 3 wiersz sieci to transport do maszyny 3
    end                                                                    % 4 wiersz sieci to transport do maszyny 4
    methods(Access=public)                                                 % 5 wiersz sieci to transport do LU
        function obj = PetriNet(listaZadan)                                % 6 wiersz sieci to oznaczenie miejsca z pustym wó¿kiem
            obj.ListaZadan = listaZadan;                                   % 7 wiersz sieci to bufory wejœciowe dla ka¿dej z maszyn
        end                                                                % 8 wiersz sieci to liczby pustych miejsc w buforach wejœciowych dla ka¿dej z maszyn
        function obj = wykonajSterowanie(obj, sterowanie)                  % 9 wiersz sieci to liczby pustych miejsc w buforach wyjœciowych dla ka¿dej z maszyn
            typ_zadania = sterowanie.typ_zadania;                          % 10 wiersz sieci to dostepnosc maszyn
            numer_zadania = sterowanie.numer_zadania;                      % 11 wiersz sieci to obrobka na maszynie
            nr_maszyny = sterowanie.numer_maszyny;
            etap = sterowanie.etap_zadania;
            if (typ_zadania == 2)
                obj = wykonajTransport(obj, numer_zadania, etap, nr_maszyny);
            end
        end
        function lista = ListaDostepnychSterowan(obj)
            lista = [];
        end
    end
    methods(Access=private)
        function obj = wykonajTransport(obj, nr_zadania, etap_zadania, nr_maszyny)
            maszyna_docelowa = obj.ListaZadan(nr_zadania).maszyna(etap_zadania); % okresla wiersz w tabeli z siecia petriego
            obj = wykonajPrzejazd(obj, nr_maszyny, maszyna_docelowa);
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
                obj = TranzycjaM1doM1(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2doM1(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3doM1(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4doM1(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUdoM1(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny2(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1doM2(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2doM2(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3doM2(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4doM2(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUdoM2(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny3(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1doM3(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2doM3(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3doM3(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4doM3(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUdoM3(obj);
                            end
                        end
                    end
                end
            end
        end
        function obj = wykonajPrzejazdDoMaszyny4(obj, maszyna_aktualna)
            if (maszyna_aktualna == 1)
                obj = TranzycjaM1doM4(obj);
            else if (maszyna_aktualna == 2)
                    obj = TranzycjaM2doM4(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3doM4(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4doM4(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUdoM4(obj);
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
                    obj = TranzycjaM2doLU(obj);
                else if (maszyna_aktualna == 3)
                        obj = TranzycjaM3doLU(obj);
                    else if (maszyna_aktualna == 4)
                            obj = TranzycjaM4doLU(obj);
                        else if (maszyna_aktualna == 5)
                                obj = TranzycjaLUdoLU(obj);
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