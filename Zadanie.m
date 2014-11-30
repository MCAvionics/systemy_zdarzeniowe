classdef Zadanie
    properties(SetAccess = private)
        maszyny
        czasy
    end
    methods
        function obj = Zadanie(maszyny, czasy)
            obj.maszyny = maszyny;
            obj.czasy = czasy;
        end
        function nast = maszyna(obj, etap)
            nast = obj.maszyny(etap);
        end
    end
end