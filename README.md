# 📱 Task Management App (Flutter)

## 🚀 Overview

This is a Task Management App built using Flutter as part of the Flodo AI take-home assignment.
The app allows users to create, manage, and track tasks with dependencies in a clean and simple UI.

---

## ✨ Features

### ✅ Core Features

* Create, Read, Update, Delete (CRUD) tasks
* Each task includes:

  * Title
  * Description
  * Due Date
  * Status (To-Do, In Progress, Done)
  * Blocked By (optional dependency)
* Blocked tasks appear visually disabled until dependency is completed
* Search tasks by title
* Filter tasks by status
* 2-second delay on create & update with loading indicator

---

## 💾 Data Persistence

* Local storage using **Hive**
* Tasks persist even after app restart

---

## 🧠 Technical Decisions

* Used simple `setState` for state management to keep the app lightweight and easy to understand
* Used Hive for fast and efficient local data storage
* Focused on clean UI and smooth user experience instead of over-engineering

---

## 🛠 Tech Stack

* Flutter (Dart)
* Hive (Local Database)

---

## ▶️ How to Run

```bash
git clone https://github.com/kashishgoswami870/Task_Manager-app.git
cd Task_Manager-app
flutter pub get
flutter run -d chrome
```

---

## 🎯 Track Chosen

**Track B: Mobile Specialist**

---

## ⭐ Stretch Goal

None implemented (Focused on delivering a stable and complete core application)

---

## 🤖 AI Usage Report

### Helpful Usage

* Used AI tools to generate initial UI structure
* Used AI for debugging Hive integration and DateTime handling
* Used AI to fix runtime and syntax errors

### Issue Faced

* Initially stored DateTime directly, which caused issues with Hive
* Fixed by converting DateTime to string using:

```dart
toIso8601String()
```

---

## 🎥 Demo Video

(Add your Google Drive video link here)

---

## 📌 Notes

* Focused on delivering a stable and fully functional application
* Prioritized clean UI and smooth user interaction
* Avoided over-complicating architecture as a fresher

---

