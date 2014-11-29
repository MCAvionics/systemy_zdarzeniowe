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

Lista_zadan(2).maszyny = [  2,  1,  2,  3];
Lista_zadan(2).czasy   = [  7, 14,  5, 40];

% Ilosc detali, indeks = numer zadania
Ilosc = [ 5, 15];

