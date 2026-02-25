# 🏫 System Onboarding & Usage Guide (Hage Af-Soomaali)

## **1. Hordhac**
Ku soo dhawoow **SOMEDU School Management System**. Dukumentigan wuxuu bixinayaa hage xirfadeed oo ku saabsan sida loo diyaariyo xogta dugsigaaga ee nidaamka, sida loo soo geliyo si sax ah, iyo sida habka gelitaanka (login) u shaqeeyo.

---

## **2. ⚠️ MUHIIM: Kala Horeynta Soo Gelinta Xogta**
Nidaamku wuxuu abuuraa xiriir ka dhexeeya xogtaada (tusaale, ku xirida **Macalin** fasalkiisa). Si looga fogaado khaladaad ("Not Found"), waa inaad **QASAB** ku soo gelisaa faylasha Excel-ka sidaan u kala horeeyaan:

1.  🟢 **Tallaabada 1aad: Ardayda (`students.csv`)**
    *   **Sababta?** Tani waxay abuurtaa dhammaan **Fasallada** (tusaale, 10A, 11B) nidaamka dhexdiisa.
    *   *Natiijada:* Fasalladu waxay diyaar u yihiin in macalimiinta loo asteeyo.

2.  🟡 **Tallaabada 2aad: Macalimiinta (`teachers.csv`)**
    *   **Sababta?** Tani waxay abuurtaa dhammaan **Maadooyinka** (tusaale, Xisaab, Fiisikis) waxayna macalimiinta ku xirtaa Fasallada la sameeyay Tallaabada 1aad.
    *   *Natiijada:* Maadooyinka iyo xiriirka Macalin-Fasal waa la sameeyay.

3.  🔵 **Tallaabada 3aad: Jadwalka (`timetable.csv`)**
    *   **Sababta?** Tani waxay jadwal u sameysaa Macalimiinta iyo Maadooyinka jirta.
    *   *Natiijada:* Ardayda iyo Macalimiintu waxay arki karaan jadwalkooda 12-ka xiisadood.

4.  🔴 **Tallaabada 4aad: Imtixaanaadka (`exams.csv`)**
    *   **Sababta?** Tani waxay jadwal u sameysaa imtixaanada Maadooyinka iyo Fasallada markaas jira.
    *   *Natiijada:* Imtixaanadu waxay ka soo muuqanayaan dashboard-ka ardayga iyo macalinka.

---

## **3. Diyaarinta Xogta (Excel Formats)**
Si loo xaqiijiyo in nidaamku si habsami leh u shaqeeyo, waa in xogtaada si sax ah loo habeeyo. Nidaamku aad buu ugu adag yahay tayada xogta si looga hortago khaladaad.

### **A. Ardayda (`students.csv`)**
Faylkan wuxuu diiwaangeliyaa dhammaan ardayda wuxuuna u asteeyaa fasalladooda.

| Magaca Tiirka | Sharaxaad | Tusaale |
| :--- | :--- | :--- |
| **first_name** | Magaca hore ee ardayga. | `Mohamed` |
| **last_name** | Magaca dambe ee ardayga. | `Abshir` |
| **level** | Heerka Waxbarasho (Waa inuu ahaadaa: `Primary`, `Secondary`, ama `HighSchool`). | `Secondary` |
| **class** | Fasalka loo qoondeeyay. Qaabka: **Tiro + Xaraf** (Banaanna ma leh). | `10A` |

> **⚠️ Muhiim:** Qaabka fasalku waa inuu ahaadaa mid sax ah (tusaale, `10A` waa sax, `10 A` ama `Grade 10` waa qalad).

### **B. Macalimiinta (`teachers.csv`)**
Faylkan wuxuu diiwaangeliyaa macalimiinta iyo maadooyinkooda. Waxaad hal macalin u qori kartaa maadooyin badan hal saf gudihiis.

| Magaca Tiirka | Sharaxaad | Tusaale |
| :--- | :--- | :--- |
| **first_name** | Magaca hore ee macalinka. | `Ahmed` |
| **last_name** | Magaca dambe ee macalinka. | `Macalin` |
| **subject** | Liiska maadooyinka oo hakad u dhexeeyo. | `Math, Physics, Biology` |
| **classes** | (Ikhtiyaari) Liiska fasallada ay wax u dhigaan. | `10A, 11B` |

### **C. Jadwalka (`timetable.csv`)**
Faylkan wuxuu qeexayaa jadwalka usbuuca. Nidaamku hadda wuxuu taageeraa ilaa **12 Xiisadood** maalintii.

| Magaca Tiirka | Sharaxaad | Tusaale |
| :--- | :--- | :--- |
| **teacher** | Magaca buuxa ee macalinka (Waa inuu la mid noqdaa kii la diiwaangeliyay). | `Ahmed Macalin` |
| **subject** | Magaca maadada. | `Math` |
| **class** | Fasalka xiisaddan. | `10A` |
| **day_of_week** | Maalinta (Monday, Tuesday, iwm.). | `Saturday` |
| **period** | Lambarka xiisadda (1-12). | `1` |

> **💡 Talo:** Hubi in magaca macalinka loo qoray si la mid ah sida uu ugu jiro Faylka Macalimiinta.

### **D. Imtixaanaadka (`exams.csv`)**
Faylkan wuxuu jadwal u sameeyaa imtixaanada sannad dugsiyeedka.

| Magaca Tiirka | Sharaxaad | Tusaale |
| :--- | :--- | :--- |
| **subject** | Magaca maadada. | `Math` |
| **classes** | Fasallada gelaya imtixaanka. | `10A, 10B` |
| **date** | Taariikhda Imtixaanka (YYYY-MM-DD). | `2025-05-15` |
| **exam_type** | Nooca imtixaanka (`midterm` ama `final`). | `midterm` |
| **start_time** | Waqtiga uu bilaabanayo (HH:MM:SS). | `08:00:00` |
| **end_time** | Waqtiga uu dhamaanayo (HH:MM:SS). | `10:00:00` |

---

## **4. Habka Gelitaanka & Amniga (Login Process)**
Nidaamku wuxuu fududeeyaa gelitaanka. Isticmaalayaashu waxay u baahan yihiin oo kaliya magacooda.

### **👮 Habka Gelitaanka Macalinka**
1.  **Aqoonsiga Gelitaanka (Login ID):** `magacahore + magacodambe` (xarfo yaryar, banaanna ma leh).
    *   *Tusaale:* `ahmedmacalin`
    *   **Fiiro Gaar ah:** Nidaamku si toos ah ayuu u raacsiinayaa `ahmedmacalin@som.edu`. Uma baahnid inaad qorto emailka oo dhan.
2.  **Lambarka Sirta ah ee Ku Meel Gaarka ah (Temporary Password):** Lambarka sirta ah ee ugu horreeya dhammaan macalimiinta waa:
    *   `Password123`
3.  **Waxa Lagaa Rabo:**
    *   Marka ugu horeysa ee aad gasho: Geli `ahmedmacalin` iyo `Password123`.
    *   Nidaamku wuxuu **ISLA MARKIBA** ku weydiin doonaa inaad beddesho lambarkaaga sirta ah.
    *   Sameyso lambar sir ah oo cusub oo adiga kuu gaar ah. `Password123` mar dambe ma shaqeyn doono.

### **🎓 Habka Gelitaanka Ardayga**
1.  **Aqoonsiga Gelitaanka (Login ID):** `magacahore + magacodambe` (xarfo yaryar, banaanna ma leh).
    *   *Tusaale:* `mohamedabshir`
    *   **Fiiro Gaar ah:** Nidaamku si toos ah ayuu u raacsiinayaa `mohamedabshir@som.edu`. Uma baahnid inaad qorto emailka oo dhan.
2.  **Lambarka Sirta ah ee Ku Meel Gaarka ah:** Waa **Login ID + Fasalka** (xarfo yaryar).
    *   *Tusaale:* Haddii Login ID-gu yahay `mohamedabshir` fasalkuna yahay `10A`, lambarka sirta ah waa: `mohamedabshir10a`
3.  **Waxa Lagaa Rabo:**
    *   Ardaydu waa inay sidoo kale beddelaan lambarkooda sirta ah marka ugu horeysa ee ay soo galaan si loo sugo amniga akoonkooda.

---

## **5. Soo Koobida Nidaamka**
*   **Email-ada Tooska ah:** Markaad soo geliso faylasha Excel, nidaamku si toos ah ayuu u sameeyaa emailo ku dhammaada `@som.edu`. Isticmaalayaashu waxay kaliya isticmaalaan magacooda si ay u soo galaan.
*   **Hal Mar oo Kaliya:** Marka xogta la soo geliyo, uma baahnid inaad dib u soo geliso ilaa ay jiraan isbeddelo (tusaale, arday cusub).
*   **Lambarka Sirta ah ee Joogtada ah:** Lambarada sirta ah ee ku meel gaarka ah waa hal mar-isticmaal. Lambarka cusub ee uu qofku sameysto ayaa ah furihiisa rasmiga ah.

*Waxaa loo diyaariyay Maamulka SOMEDU System*
