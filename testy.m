%==========================================================================
% Plik z testami do sieci petriego
%==========================================================================
clear;
z1 = Zadanie([1,2,3,4,5],[1,2,3,4,5]);
z2 = Zadanie([2,3,4,5,1],[1,2,3,4,5]);

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
assert(length(lista) == 2,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 2, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

assert(lista(2).typ_zadania() == 2, 'Test Failed: Zly typ zadania');
assert(lista(2).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(2).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(2).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 3. Transport detalu od LU do M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(2,5,1,1)); % transport detalu od LU do M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 2,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 2, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

assert(lista(2).typ_zadania() == 1, 'Test Failed: Zly typ zadania');
assert(lista(2).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(2).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(2).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 4. Zaladunek detalu do bufora na maszynie w M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(1,1,1,1)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 2,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 2, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

assert(lista(2).typ_zadania() == 4, 'Test Failed: Zly typ zadania');
assert(lista(2).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(2).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(2).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

% 5 Obrobka detalu na maszynie M1 (zadanie 1)
p = p.wykonajSterowanie(Sterowanie(4,1,1,1)); % zaladunek detalu na maszyne w M1
lista = p.listaDostepnychSterowan();
assert(length(lista) == 2,'Test Failed: zla dlugosc listy dostepnych zadan');

assert(lista(1).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(1).numer_maszyny() == 5, 'Test Failed: Zly nr maszyny');
assert(lista(1).numer_zadania() == 2, 'Test Failed: Zly nr zadania');
assert(lista(1).etap_zadania() == 1, 'Test Failed: Zly etap zadania');

assert(lista(2).typ_zadania() == 3, 'Test Failed: Zly typ zadania');
assert(lista(2).numer_maszyny() == 1, 'Test Failed: Zly nr maszyny');
assert(lista(2).numer_zadania() == 1, 'Test Failed: Zly nr zadania');
assert(lista(2).etap_zadania() == 2, 'Test Failed: Zly etap zadania');
