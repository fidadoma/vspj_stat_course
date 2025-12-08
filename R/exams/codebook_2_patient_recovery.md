# Kódová kniha - Dataset 2: Zotavení pacientů po chirurgickém zákroku

## Kontext
Datová sada obsahuje údaje o pacientech, kteří podstoupili ortopedické chirurgické zákroky v jedné velké nemocnici. Data zahrnují předoperační charakteristiky, typ zákroku a pooperační výsledky. Data byla sbírána v letech 2023-2024.

## Velikost datové sady
N = 300 pacientů

## Struktura kauzálních vztahů
- `vek` + `kouření` → `index_komorbidity`
- `index_komorbidity` → `cas_zotaveni`
- `bmi` je collider
- `typ_zakroku` je konfounder

---

## Proměnné

### Ordinální proměnné

**uroven_bolesti**
- **Typ**: Ordinální (1-10)
- **Popis**: Subjektivní hodnocení úrovně bolesti pacienta po operaci
- **Hodnoty**: 1 = Žádná bolest, 10 = Nesnesitelná bolest
- **Měření**: 7 dní po operaci

**skore_mobility**
- **Typ**: Ordinální (1-5)
- **Popis**: Hodnocení mobility a schopnosti pohybu pacienta
- **Hodnoty**:
  - 1 = Upoutaný na lůžko
  - 2 = Pohyb s pomocí
  - 3 = Omezený pohyb
  - 4 = Téměř normální pohyb
  - 5 = Plná mobilita

**spokojenost_lecba**
- **Typ**: Ordinální (1-5)
- **Popis**: Celková spokojenost pacienta s léčbou a péčí
- **Hodnoty**:
  - 1 = Velmi nespokojený
  - 2 = Nespokojený
  - 3 = Neutrální
  - 4 = Spokojený
  - 5 = Velmi spokojený

**index_komorbidity**
- **Typ**: Ordinální (0-3)
- **Popis**: Počet významných přidružených onemocnění
- **Hodnoty**:
  - 0 = Žádné komorbidity
  - 1 = Jedna komorbidita
  - 2 = Dvě komorbidity
  - 3 = Tři a více komorbid

---

### Nominální proměnné

**typ_zakroku**
- **Typ**: Nominální (kategoriální)
- **Popis**: Typ ortopedického chirurgického zákroku
- **Hodnoty**: Koleno, Kyčel, Páteř, Rameno

**nemocnicni_oddeleni**
- **Typ**: Nominální (kategoriální)
- **Popis**: Oddělení, kde byl pacient hospitalizován
- **Hodnoty**: A, B, C, D

**typ_pojisteni**
- **Typ**: Nominální (kategoriální)
- **Popis**: Typ zdravotního pojištění pacienta
- **Hodnoty**: Veřejné, Soukromé, Smíšené

**kouření**
- **Typ**: Nominální (kategoriální)
- **Popis**: Status kouření pacienta
- **Hodnoty**: Nikdy, Bývalý kuřák, Současný kuřák

---

### Numerické proměnné

**vek**
- **Typ**: Numerická (diskrétní)
- **Popis**: Věk pacienta v době operace
- **Jednotka**: roky
- **Rozsah**: 35-85 let

**bmi**
- **Typ**: Numerická (spojitá)
- **Popis**: Body Mass Index pacienta
- **Jednotka**: kg/m²
- **Rozsah**: 18-42

**dny_hospitalizace**
- **Typ**: Numerická (diskrétní)
- **Popis**: Počet dní strávených v nemocnici
- **Jednotka**: dny
- **Rozsah**: 2-21 dní

**cas_zotaveni**
- **Typ**: Numerická (spojitá)
- **Popis**: Celkový čas do plného zotavení
- **Jednotka**: týdny
- **Rozsah**: 4-26 týdnů

**cena_medikace**
- **Typ**: Numerická (spojitá)
- **Popis**: Náklady na pooperační medikaci
- **Jednotka**: CZK
- **Rozsah**: 2 000 - 35 000 CZK

**skore_pred_operaci**
- **Typ**: Numerická (spojitá)
- **Popis**: Funkční skóre před operací
- **Jednotka**: body (0-100)
- **Rozsah**: 20-60

**skore_po_operaci**
- **Typ**: Numerická (spojitá)
- **Popis**: Funkční skóre 6 měsíců po operaci
- **Jednotka**: body (0-100)
- **Rozsah**: 50-98
