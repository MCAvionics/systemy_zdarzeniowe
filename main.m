% #####################################################
% # SYSTEMY ZDAZENIOWE - prow. dr Elżbieta Roszkowska #
% #                                                   #
% # Program emuluje działanie robotycznego systemu    #
% # obróbczego w orientacji kołowej oraz implementuje #
% # sterownik zdarzeniowy zarządzający siecią         #
% #                                                   #
% # Skład grupy:                                      #
% # 1. Marcin Ciopcia                                 #
% # 2. Daniel Gut                                     #
% # 3. Pior Sembercki                                 #
% # 4. Hanna Sienkiewicz                              #
% #                                                   #
% #####################################################

clear all;
close all;
clc;

Lista_zadan(1).maszyny = [  1,  2,  3,  4];
Lista_zadan(1).czasy   = [ 20,  8, 35,  5];
Lista_zadan(1).ilosc   = [  5,  0,  0,  0];

Lista_zadan(2).maszyny = [  2,  1,  2,  3];
Lista_zadan(2).czasy   = [  7, 14,  5, 40];
Lista_zadan(2).ilosc   = [  5,  0,  0,  0];

Wielkosc_buforow = 2;

while(true)
	% iteruj symulator
	% ( Zdarzenie, ...) = SymulatorRun( Sterowanie )
	
	% iteruj siec petriego
	% Lista_sterowan = PetriNet.costam( Zdarzenie, ....)

	% selekcja zadan
	Sterowanie = agent(Lista_Sterowan, Lista_zadan, Wielkosc_buforow);
	
	% aktualizowanie sieci w oparciu o Sterowanie
	% PetriNet.costam( Sterowanie )
end
