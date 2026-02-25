# 🏫 System Onboarding & Usage Guide

## **1. Introduction**
Welcome to the **SOMEDU School Management System**. This document provides a professional guide on how to prepare your school's data for the system, the strictly required upload order, and how the secure login process works.

---

## **2. ⚠️ MANDATORY: Correct Order of Uploads**
The system creates connections between your data (e.g., assigning a **Teacher** to a **Class**). To avoid "Not Found" errors, you **MUST** upload your Excel files in this specific order:

1.  🟢 **Step 1: Students (`students.csv`)**
    *   **Why?** This step creates all the **Classes** (e.g., 10A, 11B) in the system.
    *   *Result:* Classes are ready for teachers to be assigned to them.

2.  🟡 **Step 2: Teachers (`teachers.csv`)**
    *   **Why?** This step creates all the **Subjects** (e.g., Math, Physics) and assigns teachers to the relevant Classes created in Step 1.
    *   *Result:* Subjects and Teacher-Class links are established.

3.  🔵 **Step 3: Timetable (`timetable.csv`)**
    *   **Why?** This schedules the existing Teachers and Subjects into the weekly slots.
    *   *Result:* Students and Teachers can see their innovative 12-period schedule.

4.  🔴 **Step 4: Exams (`exams.csv`)**
    *   **Why?** This schedules exams for the specific Subjects and Classes that now exist.
    *   *Result:* Exams appear on student and teacher dashboards.

---

## **3. Data Preparation (Excel Formats)**
To ensure a smooth setup, your data must be formatted correctly. The system is strict about data quality to prevent errors.

### **A. Students (`students.csv`)**
This file registers all students and assigns them to their respective classes.

| Column Name | Description | Example |
| :--- | :--- | :--- |
| **first_name** | The student's first name. | `Mohamed` |
| **last_name** | The student's last name. | `Abshir` |
| **level** | Education level (Must be: `Primary`, `Secondary`, or `HighSchool`). | `Secondary` |
| **class** | The class assigned. Format: **Number + Letter** (No spaces). | `10A` |

> **⚠️ Important:** The class format must be strict (e.g., `10A` is correct, `10 A` or `Grade 10` is wrong).

### **B. Teachers (`teachers.csv`)**
This file registers teachers and assigns their subjects. You can assign multiple subjects to a single teacher in one row.

| Column Name | Description | Example |
| :--- | :--- | :--- |
| **first_name** | The teacher's first name. | `Ahmed` |
| **last_name** | The teacher's last name. | `Macalin` |
| **subject** | Comma-separated list of subjects they teach. | `Math, Physics, Biology` |
| **classes** | (Optional) Comma-separated list of classes they teach. | `10A, 11B` |

### **C. Timetable (`timetable.csv`)**
This defines the weekly schedule. The system now supports up to **12 Periods** per day.

| Column Name | Description | Example |
| :--- | :--- | :--- |
| **teacher** | Full name of the teacher (Must match registered teacher). | `Ahmed Macalin` |
| **subject** | Subject name (Must match registered subject). | `Math` |
| **class** | The class for this session. | `10A` |
| **day_of_week** | The day (Monday, Tuesday, etc.). | `Saturday` |
| **period** | The period number (1-12). | `1` |

> **💡 Tip:** Ensure the teacher's name is spelled exactly as it was in the Teachers file.

### **D. Exams (`exams.csv`)**
This schedules exams for the academic year.

| Column Name | Description | Example |
| :--- | :--- | :--- |
| **subject** | Subject name. | `Math` |
| **classes** | Comma-separated list of classes taking this exam. | `10A, 10B` |
| **date** | Exam date (YYYY-MM-DD). | `2025-05-15` |
| **exam_type** | Type of exam (`midterm` or `final`). | `midterm` |
| **start_time** | Start time (HH:MM:SS). | `08:00:00` |
| **end_time** | End time (HH:MM:SS). | `10:00:00` |

---

## **4. Login Process & Security**
The system makes it easy to login. Users just need their name.

### **👮 Teacher Login Flow**
1.  **Login ID:** `firstname + lastname` (lowercase, no spaces).
    *   *Example:* `ahmedmacalin`
    *   **Note:** The system automatically treats this as `ahmedmacalin@som.edu`. You do not need to type the full email.
2.  **Temporary Password:** The default temporary password for ALL teachers is:
    *   `Password123`
3.  **Action Required:**
    *   First login: Enter `ahmedmacalin` and `Password123`.
    *   The system will **IMMEDIATELY** ask you to change your password.
    *   Create a new private password. `Password123` will never work again.

### **🎓 Student Login Flow**
1.  **Login ID:** `firstname + lastname` (lowercase, no spaces).
    *   *Example:* `mohamedabshir`
    *   **Note:** The system automatically treats this as `mohamedabshir@som.edu`. You do not need to type the full email.
2.  **Temporary Password:** The default password is their **Login ID + Class** (lowercase).
    *   *Example:* If Login ID is `mohamedabshir` and class is `10A`, password is: `mohamedabshir10a`
3.  **Action Required:**
    *   Students must also change their password on the first login to secure their account.

---

## **5. Summary of System Logic**
*   **Automatic Emails:** When you upload Excel files, the system automatically creates emails ending in `@som.edu`. Users just use their names to login.
*   **One-Time Setup:** Once data is uploaded, you don't need to re-upload unless there are changes.
*   **Forever Passwords:** The temporary passwords are single-use. The new password set by the user is their permanent key.

*Generated for SOMEDU System Administrators*
