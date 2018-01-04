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

#teljesen le kell fednünk a különbözõ területeket (átfedéssel nem foglalkozunk)
s.t. TeljesenLefed {t in Teruletek} :
	sum{e in Eszkozok} felszerel[t, e] * hatotavm2[e] >= terulet[t];

#akkor szerelhetünk fel egy eszközt, ha az oda való
s.t. FelszerelesLimit {t in Teruletek, e in Eszkozok} :
	felszerel[t,e] <= felszerelheto[t,e] * felszerel[t,e];

#a legnagyobb beépíthetõ eszközmennyiséget nem léphetjük túl
s.t. dbLimit :
	sum{t in Teruletek, e in Eszkozok} felszerel[t,e] <= dblimit;

#az éves karbantartási költség nem léphetõ túl
s.t. karbanLimit :
	sum{e in Eszkozok, t in Teruletek} felszerel[t,e] * karbantart[e] <= karbanlimit;


#szükséges a költségek minimalizálása
minimize Koltseg : sum{t in Teruletek, e in Eszkozok} (felszerel[t, e] * arak[e] + felszerel[t, e] * szereldij[e] + felszerel[t, e] * karbantart[e]);

solve;

for {t in Teruletek} {
	for {e in Eszkozok : felszerel[t,e]}{
		printf "%s teruleten %d db %s eszkozt kellett felszerelni.\n", t, felszerel[t,e], e;
	}
	printf "\n";
}