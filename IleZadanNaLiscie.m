function ilosc = IleZadanNaLiscie(Lista_zadan)
%ILEZADANNALISCIE Funkcja liczy ile zadań pozostało do realizacji na danej Liscie Zadan:
% 
%   1. Lista_zadań - lista struktur zawierajaca:
%        .maszyny - lista numerów maszyn, na których będą wykonywane
%                   poszczególne etapy zadania
%        .czasy   - czasy wykonania poszczególnych etapów zadania
%        .ilosc   - ilosc zadan czekajaca na dany etap realizacji(indeksowana etapem)

ilosc = 0;

for i=1:size(Lista_zadan,2)
    for j=1:size(Lista_zadan(i).ilosc,2)
        ilosc = ilosc + Lista_zadan(i).ilosc(j);
    end
end



	
