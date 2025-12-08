# Kódová kniha - Dataset 3: Akademický výkon studentů

## Kontext
Datová sada obsahuje informace o studentech univerzity za akademický rok 2023/2024. Data zahrnují studijní návyky, demografické údaje, akademické výsledky a faktory ovlivňující výkon. Sbírána byla na konci zimního semestru.

## Velikost datové sady
N = 280 studentů

## Struktura kauzálních vztahů
- `hodiny_studia` → `skore_zkousky`
- `uroven_motivace` → `hodiny_studia`
- `brigada` → `hodiny_spanku` → `prumer`
- `studijni_program` je backdoor (konfounder)

---

## Proměnné

### Ordinální proměnné

**kategorie_hodin_studia**
- **Typ**: Ordinální (1-4)
- **Popis**: Kategorie průměrného počtu hodin studia týdně
- **Hodnoty**:
  - 1 = 0-10 hodin
  - 2 = 11-20 hodin
  - 3 = 21-30 hodin
  - 4 = 31+ hodin

**uroven_motivace**
- **Typ**: Ordinální (1-5)
- **Popis**: Subjektivní hodnocení motivace ke studiu
- **Hodnoty**:
  - 1 = Velmi nízká
  - 2 = Nízká
  - 3 = Střední
  - 4 = Vysoká
  - 5 = Velmi vysoká

**obtiznost_kurzu**
- **Typ**: Ordinální (1-5)
- **Popis**: Vnímání obtížnosti studijního programu
- **Hodnoty**:
  - 1 = Velmi snadný
  - 2 = Snadný
  - 3 = Průměrný
  - 4 = Obtížný
  - 5 = Velmi obtížný

**mira_dochazky**
- **Typ**: Ordinální (1-4)
- **Popis**: Kategorie docházky na přednášky a semináře
- **Hodnoty**:
  - 1 = Slabá (0-50%)
  - 2 = Dostatečná (51-70%)
  - 3 = Dobrá (71-85%)
  - 4 = Výborná (86-100%)

---

### Nominální proměnné

**studijni_program**
- **Typ**: Nominální (kategoriální)
- **Popis**: Studijní program studenta
- **Hodnoty**: Ekonomie, Inženýrství, Medicína, Umění, Přírodní vědy

**ubytovani**
- **Typ**: Nominální (kategoriální)
- **Popis**: Typ ubytování studenta
- **Hodnoty**: Kolej, Doma s rodiči, Nájem

**brigada**
- **Typ**: Nominální (binární)
- **Popis**: Zda student pracuje na částečný úvazek
- **Hodnoty**: Ano, Ne

**metoda_studia**
- **Typ**: Nominální (kategoriální)
- **Popis**: Primární forma studia
- **Hodnoty**: Tradiční (prezenční), Online, Hybridní

---

### Numerické proměnné

**vek**
- **Typ**: Numerická (diskrétní)
- **Popis**: Věk studenta
- **Jednotka**: roky
- **Rozsah**: 19-28 let

**prumer**
- **Typ**: Numerická (spojitá)
- **Popis**: Studijní průměr (GPA)
- **Jednotka**: body
- **Rozsah**: 1.5-4.0 (americký systém)
- **Poznámka**: 4.0 = A (výborný), 1.0 = F (nedostatečný)

**skore_zkousky**
- **Typ**: Numerická (spojitá)
- **Popis**: Výsledek závěrečné zkoušky ze statistiky
- **Jednotka**: body (0-100)
- **Rozsah**: 45-98

**skore_projektu**
- **Typ**: Numerická (spojitá)
- **Popis**: Bodové hodnocení semestrálního projektu
- **Jednotka**: body (0-100)
- **Rozsah**: 50-100

**navstevy_knihovny**
- **Typ**: Numerická (diskrétní)
- **Popis**: Počet návštěv knihovny za měsíc
- **Jednotka**: návštěvy/měsíc
- **Rozsah**: 0-25

**hodiny_spanku**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrný počet hodin spánku za noc
- **Jednotka**: hodiny
- **Rozsah**: 4-9 hodin

**index_stresu**
- **Typ**: Numerická (spojitá)
- **Popis**: Měřítko úrovně akademického stresu
- **Jednotka**: body (0-100)
- **Rozsah**: 20-95
- **Poznámka**: Vyšší hodnota = vyšší stres
