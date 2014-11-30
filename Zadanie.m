classdef Zadanie
    properties(SetAccess = private)
        maszyny
        czasy
        numer_zadania
    end
    methods
        function obj = Zadanie(maszyny, czasy, numer)
            obj.maszyny = maszyny;
            obj.czasy = czasy;
            obj.numer_zadania = numer;
        end
        function nast = maszyna(obj, etap)
            nast = obj.maszyny(etap);
        end
        function nr = numer(obj)
            nr = obj.numer_zadania;
        end
    end
end