set Eszkozok;
set Teruletek;

param felszerelheto{Teruletek, Eszkozok};
param arak{Eszkozok};
param terulet{Teruletek};
param hatotavm2{Eszkozok};
param szereldij{Eszkozok};
param karbantart{Eszkozok};

param dblimit;
param karbanlimit;

var felszerel{t in Teruletek, e in Eszkozok}, integer >= 0;

#teljesen le kell fedn�nk a k�l�nb�z� ter�leteket (�tfed�ssel nem foglalkozunk)
s.t. TeljesenLefed {t in Teruletek} :
	sum{e in Eszkozok} felszerel[t, e] * hatotavm2[e] >= terulet[t];

#akkor szerelhet�nk fel egy eszk�zt, ha az oda val�
s.t. FelszerelesLimit {t in Teruletek, e in Eszkozok} :
	felszerel[t,e] <= felszerelheto[t,e] * felszerel[t,e];

#a legnagyobb be�p�thet� eszk�zmennyis�get nem l�phetj�k t�l
s.t. dbLimit :
	sum{t in Teruletek, e in Eszkozok} felszerel[t,e] <= dblimit;

#az �ves karbantart�si k�lts�g nem l�phet� t�l
s.t. karbanLimit :
	sum{e in Eszkozok, t in Teruletek} felszerel[t,e] * karbantart[e] <= karbanlimit;


#sz�ks�ges a k�lts�gek minimaliz�l�sa
minimize Koltseg : sum{t in Teruletek, e in Eszkozok} (felszerel[t, e] * arak[e] + felszerel[t, e] * szereldij[e] + felszerel[t, e] * karbantart[e]);

solve;

for {t in Teruletek} {
	for {e in Eszkozok : felszerel[t,e]}{
		printf "%s teruleten %d db %s eszkozt kellett felszerelni.\n", t, felszerel[t,e], e;
	}
	printf "\n";
}