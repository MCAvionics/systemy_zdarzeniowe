wezel = struct();
wezel.zadanie = 0;
wezel.faza = 0;
wezel.czas = 0;



maszyna = struct();
maszyna.buforWe = wezel;
maszyna.gniazdo = wezel;
maszyna.buforWy = wezel;


AGV = struct();
AGV.segment = 0;
AGV.czasOdjazdu = 0;
AGV.maszyna = maszyna;

zakonczone.listMaszyn  = [maszyna maszyna maszyna];
zakonczone.listaAGV = [AGV AGV];


