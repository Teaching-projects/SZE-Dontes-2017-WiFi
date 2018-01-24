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

set Valaszthato := setof{t in Teruletek, e in Eszkozok : felszerelheto[t,e] = 1}(t,e);

var felszerel{Valaszthato}, integer >= 0;

#teljesen le kell fednünk a különbözõ területeket (átfedéssel nem foglalkozunk)
s.t. TeljesenLefed {t in Teruletek} :
	sum{(t,e) in Valaszthato} felszerel[t, e] * hatotavm2[e] >= terulet[t];

#akkor szerelhetünk fel egy eszközt, ha az oda való
s.t. FelszerelesLimit {(t,e) in Valaszthato} :
	felszerel[t,e] <= felszerel[t,e];

#a legnagyobb beépíthetõ eszközmennyiséget nem léphetjük túl
s.t. dbLimit :
	sum{(t,e) in Valaszthato} felszerel[t,e] <= dblimit;
	
#az éves karbantartási költség nem léphetõ túl
s.t. karbanLimit :
	sum{(t,e) in Valaszthato} felszerel[t,e] * karbantart[e] <= karbanlimit;


#szükséges a költségek minimalizálása
minimize Koltseg : sum{(t,e) in Valaszthato} (felszerel[t, e] * arak[e] + felszerel[t, e] * szereldij[e]);

solve;

for {(t,e) in Valaszthato : felszerel[t,e]} {
		printf "%s teruleten %d db %s eszkozt kellett felszerelni.\n", t, felszerel[t,e], e;
}