# Dataset 1: Kompletní sada otázek - Souhrn

## ✅ HOTOVO - 16 OTÁZEK CELKEM

### Změny provedené:
1. ✅ **Penalty nastaveno na 0** pro všechny otázky
2. ✅ **6 nových otázek s filtry** (otázky 11-16)
3. ✅ **Všechny hodnoty vypočítány z reálných dat**

---

## 📊 STRUKTURA OTÁZEK

### ČÁST A: Základní analýzy (Otázky 1-10)

| # | Název | Oblasti | Penalty |
|---|-------|---------|---------|
| 1 | Deskriptivní statistika platu | Průměr, medián, SD, Q3, šikmost | 0 |
| 2 | T-test: Práce na dálku | t-test, Cohen's d, interpretace | 0 |
| 3 | ANOVA: Výkon podle oddělení | F-test, Tukey, eta-squared | 0 |
| 4 | Korelace: Plat a zkušenosti | Pearson r, CI, síla vztahu | 0 |
| 5 | Jednoduchá regrese | Slope, intercept, R² | 0 |
| 6 | Mnohonásobná regrese | Více prediktorů, std. koeficienty | 0 |
| 7 | Chi-square: Oddělení × Remote | Test nezávislosti, Cramer's V | 0 |
| 8 | Spearman: Stres a nemocnost | Ordinální korelace, kauzalita | 0 |
| 9 | Kontingenční tabulka | Četnosti, mediány | 0 |
| 10 | Konfounder analýza | DAG, parciální korelace | 0 |

### ČÁST B: Otázky s filtry (Otázky 11-16) ⭐ NOVÉ

| # | Název | Filtr | Test | N po filtru |
|---|-------|-------|------|-------------|
| 11 | T-test výkonu | Exclude Contract | t-test | 224 |
| 12 | ANOVA platu | IT, Sales, Finance only | ANOVA | 171 |
| 13 | Korelace vzdělanců | Master & PhD only | Pearson r | 108 |
| 14 | Chi-square bez PhD | Exclude PhD | Chi-square | 228 |
| 15 | Regrese starších | Age ≥ 35 | Regrese | 167 |
| 16 | ANOVA kombinovaný filtr | Remote=Yes AND Full-time | ANOVA | 110 |

---

## 🎯 PŘÍKLADY FILTRŮ V OTÁZKÁCH

### Otázka 11: Jednoduchý filtr (vyloučení kategorie)
```
Filtr: employment_type != 'Contract'
Důvod: Nechceme analyzovat třetí skupinu (Contract)
```

### Otázka 12: Výběr pouze některých kategorií
```
Filtr: department == 'IT' | department == 'Sales' | department == 'Finance'
Důvod: Chceme porovnat pouze vybraná oddělení
```

### Otázka 13: Filtr pro specifickou subpopulaci
```
Filtr: education == 'Master' | education == 'PhD'
Důvod: Analýza pouze vysokoškoláků
```

### Otázka 14: Vyloučení malé skupiny
```
Filtr: education != 'PhD'
Důvod: Malé skupiny mohou narušit předpoklady testu
```

### Otázka 15: Numerický filtr
```
Filtr: age >= 35
Důvod: Testování vztahu v podskupině podle věku
```

### Otázka 16: Kombinovaný filtr (DVĚ podmínky)
```
Filtr: remote_work == 'Yes' & employment_type == 'Full-time'
Důvod: Izolace specifické podskupiny pro detailní analýzu
```

---

## 📝 INSTRUKCE PRO FILTROVÁNÍ V JAMOVI

### Základní postup:
1. **Data** → **Filters**
2. Zadejte podmínku filtru
3. Filtr se aktivuje automaticky
4. Proveďte analýzu jako obvykle

### Operátory:
- `==` : rovná se
- `!=` : nerovná se
- `>`, `<`, `>=`, `<=` : větší, menší, větší nebo rovno, menší nebo rovno
- `|` : NEBO (alespoň jedna podmínka platí)
- `&` : A ZÁROVEŇ (obě podmínky musí platit)

### Příklady:
```r
# Jednoduchý filtr
age >= 35

# Výběr kategorií
department == 'IT' | department == 'Sales'

# Vyloučení kategorie
education != 'PhD'

# Kombinovaný filtr
remote_work == 'Yes' & age >= 35
```

---

## 📊 STATISTIKY FILTROVANÝCH ANALÝZ

### Otázka 11: T-test (Full-time vs Part-time)
- **N**: 224 (vyloučeno 26 Contract)
- **t(91)** = -0.36, p = 0.720
- **Závěr**: NENÍ významný rozdíl

### Otázka 12: ANOVA (IT, Sales, Finance)
- **N**: 171 (vyloučeno HR, Operations)
- **F(2, 168)** = 12.39, p < 0.001
- **Největší rozdíl**: IT vs Finance (-15,107 CZK)

### Otázka 13: Korelace (Master & PhD)
- **N**: 108 (vyloučeno Bachelor, High School)
- **r** = 0.349, p = 0.0002
- **Porovnání**: Vyšší než bez filtru (0.318)

### Otázka 14: Chi-square (bez PhD)
- **N**: 228 (vyloučeno 22 PhD)
- **χ²(2)** = 3.46, p = 0.178
- **Závěr**: Proměnné jsou NEZÁVISLÉ

### Otázka 15: Regrese (věk ≥ 35)
- **N**: 167 (vyloučeno 83 mladších)
- **Slope** = 5.36, **R²** = 0.377
- **Porovnání**: Mírně nižší než bez filtru

### Otázka 16: ANOVA (Remote=Yes AND Full-time)
- **N**: 110 (velmi specifická podskupina)
- **F(4, 105)** = 10.00, p < 0.001
- **η²** = 0.276 (střední efekt)
- **Trend**: Sick days roste se stresem (5 → 11.6 dní)

---

## 🎓 PEDAGOGICKÁ HODNOTA FILTRŮ

### Proč používat filtry v otázkách:

1. **Reálný výzkum**: V praxi často analyzujeme pouze část dat
2. **Předpoklady testů**: Vyloučení malých skupin kvůli předpokladům
3. **Subpopulační analýzy**: Testování vztahů v podskupinách
4. **Citlivost výsledků**: Ukázat, jak se výsledky mění s filtry
5. **Praktické dovednosti**: Student se naučí filtrovat v Jamovi

### Co studenti naučí:
- ✅ Jak filtrovat data v Jamovi
- ✅ Kdy je filtrování nutné / vhodné
- ✅ Jak interpretovat N po filtru
- ✅ Jak se výsledky liší s/bez filtru
- ✅ Logické operátory (AND, OR)

---

## 📁 SOUBORY

### Hlavní soubory:
- `moodle_questions_dataset_1_complete.xml` - **16 otázek, penalty=0, s filtry**
- `calculate_answers_dataset_1.R` - Výpočty pro otázky 1-10
- `calculate_answers_with_filters_dataset_1.R` - Výpočty pro otázky 11-16

### Podporující soubory:
- `dataset_1_employee_satisfaction.csv` (CZ)
- `dataset_1_employee_satisfaction_EN.csv` (EN)
- `codebook_1_employee_satisfaction.md`

---

## ✨ PŘÍŠTÍ KROKY

### Pro Dataset 1:
- ✅ 16 otázek hotovo
- 🔄 Možné rozšíření na 20+ otázek (přidat 4-6 dalších)
- 🔄 Přidat screenshoty z Jamovi do feedback sekcí

### Pro Datasets 2, 3, 4:
- ⏳ Vytvořit podobnou strukturu
- ⏳ 10 základních + 6 filtrovaných otázek pro každý
- ⏳ Celkem 48 dalších otázek (3 × 16)

---

## 🎯 COVERAGE MATICE - Dataset 1

| Statistická technika | Základní (1-10) | S filtrem (11-16) | Celkem |
|---------------------|-----------------|-------------------|--------|
| Deskriptivní statistika | ✓ (Q1, Q9) | - | 2 |
| T-test | ✓ (Q2) | ✓ (Q11) | 2 |
| ANOVA | ✓ (Q3) | ✓ (Q12, Q16) | 3 |
| Pearson korelace | ✓ (Q4) | ✓ (Q13) | 2 |
| Spearman korelace | ✓ (Q8) | - | 1 |
| Jednoduchá regrese | ✓ (Q5) | ✓ (Q15) | 2 |
| Mnohonásobná regrese | ✓ (Q6) | - | 1 |
| Chi-square test | ✓ (Q7) | ✓ (Q14) | 2 |
| Kauzální inference | ✓ (Q10) | - | 1 |
| **CELKEM** | **10** | **6** | **16** |

---

## 📊 DŮLEŽITÉ POZNÁMKY

### Formát Moodle Cloze:
- **Numerické**: `{1:NM:=hodnota:tolerance}`
- **Multiple Choice**: `{1:MCS:=správná~špatná1~špatná2}`
- **Penalty**: Nastaveno na **0** (bez penalizace)

### Kontrola před importem:
1. ✓ Všechny penalty=0
2. ✓ Všechny hodnoty z reálných výpočtů
3. ✓ Tolerance nastaveny rozumně
4. ✓ Feedback obsahuje návod na řešení
5. ✓ Filtry jasně popsány v zadání

---

Datum: 2025-12-07
Status: **DATASET 1 KOMPLETNÍ** (16/16 otázek)
Připraveno k importu do Moodle
