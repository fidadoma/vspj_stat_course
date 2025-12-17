# Kódová kniha - Dataset 1: Spokojenost a výkon zaměstnanců

## Kontext
Datová sada obsahuje informace o zaměstnancích střední až velké firmy. Data zahrnují demografické charakteristiky, pracovní podmínky, hodnocení spokojenosti a výkonnostní metriky. Data byla sbírána v průběhu roku 2024.

## Velikost datové sady
N = 250 zaměstnanců

## Struktura kauzálních vztahů
- `plat` ← `vzdelani` + `roky_praxe`
- `vykon_skore` ← `spokojenost_prace` + `hodnoceni_skoleni`
- `uroven_stresu` → `nemocenske_dny`
- `oddeleni` je konfounder (backdoor) pro vztah `plat` → `vykon_skore`

---

## Proměnné

### Ordinální proměnné

**spokojenost_prace**
- **Typ**: Ordinální (1-5)
- **Popis**: Celková spokojenost zaměstnance s prací
- **Hodnoty**:
  - 1 = Velmi nespokojený
  - 2 = Nespokojený
  - 3 = Neutrální
  - 4 = Spokojený
  - 5 = Velmi spokojený

**work_life_balance**
- **Typ**: Ordinální (1-5)
- **Popis**: Hodnocení rovnováhy mezi pracovním a osobním životem
- **Hodnoty**:
  - 1 = Velmi špatná
  - 2 = Špatná
  - 3 = Průměrná
  - 4 = Dobrá
  - 5 = Velmi dobrá

**uroven_stresu**
- **Typ**: Ordinální (1-5)
- **Popis**: Subjektivní hodnocení úrovně stresu v práci
- **Hodnoty**:
  - 1 = Minimální stres
  - 2 = Nízký stres
  - 3 = Střední stres
  - 4 = Vysoký stres
  - 5 = Velmi vysoký stres

**hodnoceni_skoleni**
- **Typ**: Ordinální (1-5)
- **Popis**: Hodnocení kvality a užitečnosti firemních školení
- **Hodnoty**:
  - 1 = Velmi špatné
  - 2 = Špatné
  - 3 = Průměrné
  - 4 = Dobré
  - 5 = Velmi dobré

---

### Nominální proměnné

**oddeleni**
- **Typ**: Nominální (kategoriální)
- **Popis**: Oddělení, na kterém zaměstnanec pracuje
- **Hodnoty**: IT, Prodej, HR, Finance, Provoz

**typ_uvazku**
- **Typ**: Nominální (kategoriální)
- **Popis**: Typ pracovního úvazku
- **Hodnoty**: Plný úvazek, Částečný úvazek, Kontrakt

**vzdelani**
- **Typ**: Nominální (kategoriální/ordinální)
- **Popis**: Nejvyšší dosažené vzdělání
- **Hodnoty**: Střední škola, Bakalář, Magistr, PhD

**prace_na_dalku**
- **Typ**: Nominální (binární)
- **Popis**: Možnost pracovat z domova
- **Hodnoty**: Ano, Ne

---

### Numerické proměnné

**vek**
- **Typ**: Numerická (diskrétní)
- **Popis**: Věk zaměstnance
- **Jednotka**: roky
- **Rozsah**: 22-65 let

**plat**
- **Typ**: Numerická (spojitá)
- **Popis**: Měsíční hrubý plat
- **Jednotka**: CZK
- **Rozsah**: 25 000 - 120 000 CZK

**roky_praxe**
- **Typ**: Numerická (spojitá)
- **Popis**: Celkový počet let pracovních zkušeností
- **Jednotka**: roky
- **Rozsah**: 0-40 let

**vykon_skore**
- **Typ**: Numerická (spojitá)
- **Popis**: Roční hodnocení výkonu zaměstnance
- **Jednotka**: body (0-100)
- **Rozsah**: 35-98

**nemocenske_dny**
- **Typ**: Numerická (diskrétní)
- **Popis**: Počet dnů nemocenské za poslední rok
- **Jednotka**: dny
- **Rozsah**: 0-30 dní

**prectasy_hodiny**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrný počet přesčasových hodin za měsíc
- **Jednotka**: hodiny/měsíc
- **Rozsah**: 0-60 hodin
