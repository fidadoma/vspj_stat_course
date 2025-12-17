# Otázky pro Dataset 1: Spokojenost a výkon zaměstnanců

## Předpoklady pro vytvoření otázek

Studenti budou analyzovat data v Jamovi. Každá otázka by měla:
- Být konkrétní a jednoznačná
- Obsahovat správnou odpověď a alternativy (pro MC)
- Pro numerické odpovědi uvést toleranci (např. ±0.01)
- Odkazovat na konkrétní proměnné z datové sady

---

## Kategorie otázek

### 1. DESKRIPTIVNÍ STATISTIKA (4 otázky)

**Otázka 1.1: Průměr platu**
- Jaký je průměrný plat zaměstnanců v datasetu? (Průměr ± SD)
- Odpověď: [vypočítat z dat]
- Tolerance: ±100 CZK

**Otázka 1.2: Medián a rozsah**
- Jaký je medián let pracovních zkušeností?
- Odpověď: [vypočítat]
- Tolerance: ±0.5 let

**Otázka 1.3: Kvartily**
- Jaký je třetí kvartil (Q3) výkonového skóre?
- Odpověď: [vypočítat]
- Tolerance: ±1

**Otázka 1.4: Variabilita**
- Jaká je směrodatná odchylka spokojenosti s prací?
- Odpověď: [vypočítat]
- Tolerance: ±0.05

---

### 2. VIZUALIZACE DAT (4 otázky)

**Otázka 2.1: Histogram interpretace**
Podívejte se na histogram proměnné `plat`. Jaký tvar má rozdělení?
- a) Normální rozdělení
- b) Pravostranně zešikmené
- c) Levostranně zešikmené
- d) Bimodální
Správná odpověď: [určit z dat]

**Otázka 2.2: Krabicový graf**
V krabicovém grafu pro `nemocenske_dny` podle `oddeleni`, které oddělení má nejvyšší medián?
- a) IT
- b) Prodej
- c) HR
- d) Finance
- e) Provoz
Správná odpověď: [určit z dat]

**Otázka 2.3: Bodový graf**
Vytvořte bodový graf (scatter plot) mezi `plat` (X) a `vykon_skore` (Y). Jaký typ vztahu pozorujete?
- a) Pozitivní lineární
- b) Negativní lineární
- c) Žádný vztah
- d) Kvadratický vztah
Správná odpověď: a) Pozitivní lineární

**Otázka 2.4: Sloupcový graf**
Vytvořte sloupcový graf četností pro `vzdelani`. Která kategorie má nejvíce zaměstnanců?
- a) Střední škola
- b) Bakalář
- c) Magistr
- d) PhD
Správná odpověď: [určit z dat]

---

### 3. KORELAČNÍ ANALÝZA (3 otázky)

**Otázka 3.1: Pearsonova korelace**
Spočítejte Pearsonovu korelaci mezi `plat` a `roky_praxe`. Korelační koeficient r = ?
- Odpověď: [vypočítat]
- Tolerance: ±0.02
- Je korelace statisticky významná (p < 0.05)? ANO/NE

**Otázka 3.2: Spearmanova korelace**
Spočítejte Spearmanovu korelaci mezi `spokojenost_prace` (ordinální) a `vykon_skore`.
- ρ = ?
- Odpověď: [vypočítat]
- Tolerance: ±0.02

**Otázka 3.3: Síla korelace**
Mezi kterými dvěma proměnnými je nejsilnější korelace?
- a) plat a vek
- b) vykon_skore a spokojenost_prace
- c) uroven_stresu a nemocenske_dny
- d) work_life_balance a uroven_stresu
Správná odpověď: [určit z dat - porovnat absolutní hodnoty r]

---

### 4. LINEÁRNÍ REGRESE (4 otázky)

**Otázka 4.1: Jednoduchá regrese - koeficient**
Vytvořte lineární regresi s `vykon_skore` jako závislou proměnnou a `spokojenost_prace` jako nezávislou.
Jaká je hodnota regresního koeficientu (slope/směrnice) pro `spokojenost_prace`?
- Odpověď: [vypočítat]
- Tolerance: ±0.5

**Otázka 4.2: Kvalita modelu**
Pro stejný model, jaké je R² (koeficient determinace)?
- Odpověď: [vypočítat]
- Tolerance: ±0.02

**Otázka 4.3: Mnohonásobná regrese**
Vytvořte mnohonásobnou regresi: `vykon_skore` ~ `spokojenost_prace` + `hodnoceni_skoleni` + `oddeleni`
Který prediktor má největší standardizovaný koeficient (beta)?
- a) spokojenost_prace
- b) hodnoceni_skoleni
- c) oddeleni
Správná odpověď: [určit z dat]

**Otázka 4.4: Interpretace**
V modelu `plat` ~ `vzdelani` + `roky_praxe`, je vliv vzdělání statisticky významný (p < 0.05)?
- ANO / NE
Správná odpověď: [určit z dat]

---

### 5. T-TEST (3 otázky)

**Otázka 5.1: Nezávislý t-test**
Porovnejte průměrný `plat` mezi zaměstnanci s možností `prace_na_dalku` (Ano vs. Ne).
- t = ?
- p = ?
- Odpověď t: [vypočítat], Tolerance: ±0.2
- Odpověď p: [vypočítat], Tolerance: ±0.01
- Je rozdíl významný? ANO/NE

**Otázka 5.2: Předpoklady t-testu**
Před provedením t-testu otestujte normalitu dat pomocí Shapiro-Wilkova testu pro `vykon_skore`.
Je předpoklad normality splněn (p > 0.05)?
- ANO / NE
Odpověď: [určit z dat]

**Otázka 5.3: Velikost efektu**
Pro srovnání `spokojenost_prace` mezi `typ_uvazku` (Plný vs. Částečný), jaká je Cohenova d?
- Odpověď: [vypočítat]
- Tolerance: ±0.1

---

### 6. ANOVA (3 otázky)

**Otázka 6.1: Jednocestná ANOVA**
Proveďte jednocestnou ANOVA: je rozdíl v `vykon_skore` mezi jednotlivými `oddeleni`?
- F = ?
- p = ?
- Odpověď F: [vypočítat], Tolerance: ±0.5
- Odpověď p: [vypočítat], Tolerance: ±0.01

**Otázka 6.2: Post-hoc testy**
Po provedení ANOVA pro `plat` ~ `vzdelani`, použijte Tukey HSD post-hoc test.
Mezi kterými dvěma skupinami je největší rozdíl?
- a) Střední škola vs. Bakalář
- b) Bakalář vs. Magistr
- c) Střední škola vs. PhD
- d) Magistr vs. PhD
Správná odpověď: [určit z dat]

**Otázka 6.3: Eta-squared**
Pro ANOVA `nemocenske_dny` ~ `uroven_stresu`, jaké je η² (eta-squared)?
- Odpověď: [vypočítat]
- Tolerance: ±0.02

---

### 7. CHÍ-KVADRÁT TEST (3 otázky)

**Otázka 7.1: Test nezávislosti**
Otestujte nezávislost mezi `oddeleni` a `prace_na_dalku` pomocí chí-kvadrát testu.
- χ² = ?
- p = ?
- Odpověď χ²: [vypočítat], Tolerance: ±0.5
- Odpověď p: [vypočítat], Tolerance: ±0.01

**Otázka 7.2: Kontingenční tabulka**
Vytvořte kontingenční tabulku pro `vzdelani` × `oddeleni`.
Která kombinace má nejvyšší četnost?
- Odpověď: [určit z dat, např. "Bakalář, IT"]

**Otázka 7.3: Cramerovo V**
Pro test mezi `typ_uvazku` a `prace_na_dalku`, jaké je Cramerovo V (míra asociace)?
- Odpověď: [vypočítat]
- Tolerance: ±0.05

---

## Dodatečné otázky pro pokrytí DAG/kauzalita (volitelné)

**Otázka Extra 1: Konfounder**
Podle DAG v codebooku je `oddeleni` konfounder pro vztah mezi `plat` a `vykon_skore`.
Co se stane s korelací mezi `plat` a `vykon_skore`, když kontrolujeme `oddeleni`?
- a) Korelace zůstane stejná
- b) Korelace se zvýší
- c) Korelace se sníží
- d) Korelace zmizí
Správná odpověď: c) Korelace se sníží (částečná korelace)

**Otázka Extra 2: Mediace**
Podle DAG: `uroven_stresu` → `nemocenske_dny`.
Je `uroven_stresu` mediátor mezi nějakou jinou proměnnou a `nemocenske_dny`?
- Odpověď: Ano, mezi `work_life_balance` a `nemocenske_dny`

---

## Poznámky k implementaci

1. Pro každou otázku je nutné:
   - Spočítat správnou odpověď z generovaných dat
   - Vytvořit XML v Moodle formátu
   - Přidat obrázky/screenshoty z Jamovi kde je to vhodné

2. Alternativní odpovědi by měly být:
   - Blízké správné odpovědi (ale ne příliš)
   - Realistické (ne zřejmě špatné)

3. Pro numerické odpovědi:
   - Použít NM format: {1:NM:=správná_hodnota:tolerance}

4. Pro multiple choice:
   - Použít MCS format: {1:MCS:=správná~špatná1~špatná2~špatná3}
