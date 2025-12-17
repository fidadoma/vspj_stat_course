# Status projektu: Generování testových otázek pro Moodle

## ✅ DOKONČENO

### 1. Datové sady (4×)
Všechny sady vygenerovány s kauzálními vztahy, dostupné v českém i anglickém formátu:

- **Dataset 1**: Spokojenost a výkon zaměstnanců (250 pozorování)
  - `dataset_1_employee_satisfaction.csv` (CZ)
  - `dataset_1_employee_satisfaction_EN.csv` (EN)

- **Dataset 2**: Zotavení pacientů po chirurgickém zákroku (300 pozorování)
  - `dataset_2_patient_recovery.csv` (CZ)
  - `dataset_2_patient_recovery_EN.csv` (EN)

- **Dataset 3**: Akademický výkon studentů (280 pozorování)
  - `dataset_3_student_performance.csv` (CZ)
  - `dataset_3_student_performance_EN.csv` (EN)

- **Dataset 4**: Spotřebitelské chování a prodej (320 pozorování)
  - `dataset_4_consumer_behavior.csv` (CZ)
  - `dataset_4_consumer_behavior_EN.csv` (EN)

### 2. Kódové knihy (4×)
Detailní popis proměnných v češtině včetně DAG struktur:

- `codebook_1_employee_satisfaction.md`
- `codebook_2_patient_recovery.md`
- `codebook_3_student_performance.md`
- `codebook_4_consumer_behavior.md`

### 3. Otázky pro Dataset 1 (10 otázek)

#### Soubory:
- `calculate_answers_dataset_1.R` - R skript pro výpočet všech správných odpovědí
- `moodle_questions_dataset_1.xml` - 10 komplexních cloze otázek v Moodle XML formátu

#### Pokryté oblasti (Dataset 1):

| # | Téma | Oblasti testování |
|---|------|------------------|
| 1 | Deskriptivní statistika platu | Průměr, medián, SD, kvartily, šikmost |
| 2 | T-test (práce na dálku) | Nezávislý t-test, Cohen's d, interpretace |
| 3 | ANOVA (výkon podle oddělení) | F-test, post-hoc Tukey, eta-squared |
| 4 | Korelace (plat a zkušenosti) | Pearson r, p-hodnota, CI, síla vztahu |
| 5 | Jednoduchá regrese | Slope, intercept, R², F-test |
| 6 | Mnohonásobná regrese | Více prediktorů, standardizované koeficienty |
| 7 | Chí-kvadrát test | Test nezávislosti, Cramerovo V |
| 8 | Spearmanova korelace | Ordinální data, monotónní vztah |
| 9 | Kontingenční tabulka | Četnosti, mediány podle skupin |
| 10 | Kauzální inference | Konfounder, DAG, parciální korelace |

#### Formát otázek:
- **Cloze formát** - více podotázek v jedné otázce
- Kombinace **multiple choice (MCS)** a **numerických odpovědí (NM)**
- Tolerance pro numerické odpovědi nastavena realisticky
- Feedback s návody k analýze v Jamovi

---

## 🔄 ZBÝVÁ DOKONČIT

### Datasets 2, 3, 4
Pro každý dataset je potřeba:

1. **R skript pro výpočty** (analogicky k `calculate_answers_dataset_1.R`)
   - Deskriptivní statistiky
   - T-testy / ANOVA podle typů proměnných
   - Korelace (Pearson / Spearman)
   - Regresní analýzy
   - Chí-kvadrát testy

2. **Moodle XML soubor** s 10-20 otázkami pokrývající:
   - Deskriptivní statistiku (2-3 otázky)
   - Vizualizaci dat (1-2 otázky)
   - Korelační analýzu (2-3 otázky)
   - Lineární regresi (2-3 otázky)
   - T-testy / ANOVA (2-3 otázky)
   - Chí-kvadrát testy (1-2 otázky)
   - DAG/kauzalitu (1-2 otázky)

---

## 📋 DOPORUČENÝ POSTUP PRO DATASETS 2-4

### Krok 1: Adaptujte R skript
Zkopírujte `calculate_answers_dataset_1.R` a upravte pro příslušný dataset:
- Změňte cestu k souboru
- Přizpůsobte jména proměnných
- Volte testy odpovídající typům proměnných

### Krok 2: Spusťte výpočty
```r
Rscript R/exams/calculate_answers_dataset_X.R
```

### Krok 3: Vytvořte XML otázky
- Zkopírujte strukturu z `moodle_questions_dataset_1.xml`
- Vyplňte správné hodnoty z output R skriptu
- Přizpůsobte kontext otázek danému datasetu

---

## 🎯 SPECIFIKA JEDNOTLIVÝCH DATASETS

### Dataset 2: Patient Recovery (Zdravotnictví)
**Vhodné analýzy:**
- T-test: recovery_time podle smoking_status
- ANOVA: recovery_time podle procedure_type
- Korelace: age × comorbidity_index
- Regrese: recovery_time ~ age + comorbidity_index + procedure_type
- Chí-kvadrát: insurance_type × procedure_type
- **Collider analýza**: BMI jako collider (podle DAG)

### Dataset 3: Student Performance (Vzdělávání)
**Vhodné analýzy:**
- T-test: gpa podle part_time_job
- ANOVA: exam_score podle study_program
- Korelace: study_hours_category × exam_score
- Regrese: exam_score ~ motivation_level + attendance_rate
- Chí-kvadrát: accommodation × part_time_job
- **Mediace analýza**: sleep_hours jako mediátor (brigada → spánek → GPA)

### Dataset 4: Consumer Behavior (Marketing)
**Vhodné analýzy:**
- T-test: purchase_amount podle marketing_channel
- ANOVA: brand_loyalty podle customer_segment
- Korelace: website_visits × purchase_amount
- Regrese: purchase_amount ~ website_visits + monthly_income
- Chí-kvadrát: customer_segment × payment_method
- **Mediace**: website_visits jako mediátor (marketing → návštěvy → nákup)

---

## 📊 TECHNICKÉ POZNÁMKY

### Formát Moodle Cloze Questions

**Numerická odpověď:**
```
{pořadí:NM:=správná_hodnota:tolerance}
```
Příklad: `{1:NM:=85.5:2}` - správná odpověď 85.5 ±2

**Multiple choice:**
```
{pořadí:MCS:=správná_odpověď~špatná1~špatná2}
```
Příklad: `{1:MCS:=významný~nevýznamný}`

### Tolerance hodnot
- **Průměry, mediány**: ±1000 pro peníze, ±2 pro skóre
- **SD**: ±500 pro peníze, ±0.1 pro skóre
- **Korelace**: ±0.03
- **P-hodnoty**: ±0.005 nebo <0.001
- **Testové statistiky**: ±0.2 pro t, ±0.5 pro F, ±2 pro χ²

---

## 🔧 TIPY PRO TVORBU OTÁZEK

1. **Kombinujte více konceptů** v jedné otázce (jak v příkladech)
2. **Požadujte interpretaci**, nejen výpočet (významný/nevýznamný)
3. **Zahřejte velikost efektu** (Cohen's d, η², Cramer's V)
4. **Inkludujte předpoklady** testů (normalita, homogenita rozptylů)
5. **Propojte s DAG** strukturou z codebooku
6. **Přidejte praktický kontext** - co výsledek znamená v praxi

---

## 📂 STRUKTURA SOUBORŮ

```
R/exams/
├── dataset_1_employee_satisfaction.csv
├── dataset_1_employee_satisfaction_EN.csv
├── dataset_2_patient_recovery.csv
├── dataset_2_patient_recovery_EN.csv
├── dataset_3_student_performance.csv
├── dataset_3_student_performance_EN.csv
├── dataset_4_consumer_behavior.csv
├── dataset_4_consumer_behavior_EN.csv
├── codebook_1_employee_satisfaction.md
├── codebook_2_patient_recovery.md
├── codebook_3_student_performance.md
├── codebook_4_consumer_behavior.md
├── calculate_answers_dataset_1.R ✅
├── moodle_questions_dataset_1.xml ✅
├── calculate_answers_dataset_2.R (TODO)
├── moodle_questions_dataset_2.xml (TODO)
├── calculate_answers_dataset_3.R (TODO)
├── moodle_questions_dataset_3.xml (TODO)
├── calculate_answers_dataset_4.R (TODO)
├── moodle_questions_dataset_4.xml (TODO)
└── README_project_status.md (tento soubor)
```

---

## ✨ PŘÍŠTÍ KROKY

1. Vytvořte `calculate_answers_dataset_2.R`
2. Spusťte a získejte výsledky
3. Vytvořte `moodle_questions_dataset_2.xml`
4. Opakujte pro Dataset 3 a 4
5. Testujte importem do Moodle
6. Případně přidejte screenshoty z Jamovi do feedback sekcí

---

Datum vytvoření: 2025-12-07
Status: Dataset 1 kompletní (10 otázek), Datasets 2-4 připravené pro dokončení
