%==========================================================================
% Plik z testami do sieci petriego
%==========================================================================
clear;
z1 = Zadanie([1,2,3,4,5],[1,2,3,4,5],1);
z2 = Zadanie([2,3,4,1,5],[1,2,3,4,5],2);

%==========================================================================
% Test 1
% Opis scenariusza:
% - tworzymy sieæ z lista zadan zawierajaca z1 i z2
% - ladujemy detal w LU
% - jedziemy kolejno przez maszyny M2,M3,M4,LU az trafimy do M1
% - odkladamy element do bufora wejsciowego M1 i zwalniamy wozek
p = PetriNet([z1,z2]); % Przyjmuje listê zadan
p = p.ustawRozmiarBuforowWejsciowych(1); % ustawiamy rozmiar buforów wejsciowych dla kazdej z maszyn
p = p.ustawRozmiarBuforowWyjsciowych(1); % ustawiamy rozmiar buforów wejsciowych dla kazdej z maszyn

% 1. Sprawdzenie dostepnych poczatkowych sterowan
lista = p.listaDostepnychSterowan();
assert(length(lista) == 2,'Test Failed: zla dlugosc listy dostepnych zadan');
for i = 1:length(lista)
    assert(lista(i).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
    assert(lista(i).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
    assert(lista(i).numer_zadania() == i, 'Test Failed: Zly nr zadania');
    assert(lista(i).etap_zadania() == 1, 'Test Failed: Zly etap zadania');
end

% 2. Zaladunek elementu w LU (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(3,5,1,1)); % zaladowanie wozka w LU
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 3. Transport detalu od LU do M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(2,5,1,1)); % transport detalu od LU do M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 4. Zaladunek detalu do bufora na maszynie w M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(1,1,1,1)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 4, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 5 Obrobka detalu na maszynie M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(4,1,1,1)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 2, 'Test Failed: Zly etap zadania');

% 6 Zaladunek detalu na maszynie M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(3,1,1,2)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 2, 'Test Failed: Zly etap zadania');

% 7 Transport detalu od maszyny M1 do M2 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(2,1,1,2)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 2, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 2, 'Test Failed: Zly etap zadania');

% 8 Zaladunek na maszyne M2 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(1,2,1,2)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 4, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 2, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 2, 'Test Failed: Zly etap zadania');

% 9 Obrobka na maszynie M2 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(4,2,1,2)); % obrobka detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 2, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 3, 'Test Failed: Zly etap zadania');

% 10 Zaladunek detalu na maszynie M2 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(3,2,1,3));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 2, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 3, 'Test Failed: Zly etap zadania');

% 11. Transport detalu z maszyny M2 do M3
p = p.wykonajSterowanie(Sterowanie(2,2,1,3));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 3, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 3, 'Test Failed: Zly etap zadania');

% 12. Zaladowanie detalu do bufora M3
p = p.wykonajSterowanie(Sterowanie(1,3,1,3));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 4, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 3, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 3, 'Test Failed: Zly etap zadania');

% 13. Obrobka detalu na maszynie M3
p = p.wykonajSterowanie(Sterowanie(4,3,1,3));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 3, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 4, 'Test Failed: Zly etap zadania');

% 14 Zaladunek detalu na wozek M3 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(3,3,1,4));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 3, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 4, 'Test Failed: Zly etap zadania');

%15. Transport detalu z M3 do M4
p = p.wykonajSterowanie(Sterowanie(2,3,1,4));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 4, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 4, 'Test Failed: Zly etap zadania');

%16. zaladunek detalu do M4
p = p.wykonajSterowanie(Sterowanie(1,4,1,4));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 4, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 4, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 4, 'Test Failed: Zly etap zadania');

%17 Obrobka detalu w M4
p = p.wykonajSterowanie(Sterowanie(4,4,1,4));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 4, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 5, 'Test Failed: Zly etap zadania');

%18 Zaladunek detalu na wozek w M4
p = p.wykonajSterowanie(Sterowanie(3,4,1,5));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 4, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 5, 'Test Failed: Zly etap zadania');

% 19 Transport detalu do LU
p = p.wykonajSterowanie(Sterowanie(2,4,1,5));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 5, 'Test Failed: Zly etap zadania');

% 20 Rozladunek detalu w LU
p = p.wykonajSterowanie(Sterowanie(1,5,1,5));
lista = p.listaDostepnychSterowan();
assert(length(lista) == 1,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania'); % Tylko jedno zadanie do zrobienia.
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 2, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

