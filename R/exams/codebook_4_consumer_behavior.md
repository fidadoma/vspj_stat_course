# Kódová kniha - Dataset 4: Spotřebitelské chování a prodej produktů

## Kontext
Datová sada obsahuje informace o zákaznících maloobchodního řetězce. Data zahrnují nákupní vzorce, demografické charakteristiky a hodnocení produktů a služeb. Data byla sbírána během roku 2024 prostřednictvím věrnostního programu.

## Velikost datové sady
N = 320 zákazníků

## Struktura kauzálních vztahů
- `marketingovy_kanal` → `navstevy_webu` → `castka_nakupu`
- `mesicni_prijem` → `segment_zakaznika` → `vernost_znacce`
- `hodnoceni_produktu` ← `kvalita_sluzeb` + `kategorie_produktu` (konfounder)

---

## Proměnné

### Ordinální proměnné

**hodnoceni_produktu**
- **Typ**: Ordinální (1-5)
- **Popis**: Průměrné hodnocení nakoupených produktů zákazníkem
- **Hodnoty**:
  - 1 = Velmi špatné
  - 2 = Špatné
  - 3 = Průměrné
  - 4 = Dobré
  - 5 = Velmi dobré

**kvalita_sluzeb**
- **Typ**: Ordinální (1-5)
- **Popis**: Hodnocení kvality zákaznického servisu
- **Hodnoty**:
  - 1 = Velmi špatná
  - 2 = Špatná
  - 3 = Průměrná
  - 4 = Dobrá
  - 5 = Velmi dobrá

**vernost_znacce**
- **Typ**: Ordinální (1-5)
- **Popis**: Míra loajality zákazníka ke značce
- **Hodnoty**:
  - 1 = Žádná loajalita
  - 2 = Nízká loajalita
  - 3 = Střední loajalita
  - 4 = Vysoká loajalita
  - 5 = Velmi vysoká loajalita

**frekvence_nakupu**
- **Typ**: Ordinální (1-4)
- **Popis**: Jak často zákazník nakupuje
- **Hodnoty**:
  - 1 = Zřídka (méně než 1x za 3 měsíce)
  - 2 = Příležitostně (1x za měsíc)
  - 3 = Pravidelně (2-3x měsíčně)
  - 4 = Často (týdně)

---

### Nominální proměnné

**segment_zakaznika**
- **Typ**: Nominální (kategoriální)
- **Popis**: Kategorizace zákazníka podle kupní síly
- **Hodnoty**: Rozpočtový, Standardní, Prémiový

**kategorie_produktu**
- **Typ**: Nominální (kategoriální)
- **Popis**: Primární kategorie produktů, které zákazník nakupuje
- **Hodnoty**: Elektronika, Oblečení, Potraviny, Domácnost

**zpusob_platby**
- **Typ**: Nominální (kategoriální)
- **Popis**: Preferovaný způsob platby
- **Hodnoty**: Hotovost, Karta, Online platba

**marketingovy_kanal**
- **Typ**: Nominální (kategoriální)
- **Popis**: Primární marketingový kanál, který zákazníka oslovil
- **Hodnoty**: Sociální sítě, Email, TV reklama, Žádný

---

### Numerické proměnné

**vek**
- **Typ**: Numerická (diskrétní)
- **Popis**: Věk zákazníka
- **Jednotka**: roky
- **Rozsah**: 18-75 let

**mesicni_prijem**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrný měsíční příjem zákazníka
- **Jednotka**: CZK
- **Rozsah**: 15 000 - 150 000 CZK

**castka_nakupu**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrná částka za jeden nákup
- **Jednotka**: CZK
- **Rozsah**: 200 - 15 000 CZK

**sleva_procenta**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrné procento slevy, které zákazník obdrží
- **Jednotka**: %
- **Rozsah**: 0-40%

**navstevy_webu**
- **Typ**: Numerická (diskrétní)
- **Popis**: Počet návštěv e-shopu za měsíc
- **Jednotka**: návštěvy/měsíc
- **Rozsah**: 0-50

**hodnota_zakaznika**
- **Typ**: Numerická (spojitá)
- **Popis**: Odhadovaná celoživotní hodnota zákazníka (CLV)
- **Jednotka**: CZK
- **Rozsah**: 5 000 - 500 000 CZK

**cas_na_webu**
- **Typ**: Numerická (spojitá)
- **Popis**: Průměrný čas strávený na webu při jedné návštěvě
- **Jednotka**: minuty
- **Rozsah**: 2-45 minut
