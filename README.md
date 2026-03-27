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
* Draft-like behavior (data remains during navigation)
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

1. Clone the repository:

```bash
git clone <your-repo-link>
cd task_manager_app
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run -d chrome
```

---

## 🎯 Track Chosen

**Track B: Mobile Specialist**

---

## ⭐ Stretch Goal

None implemented (Focused on delivering a polished and stable core application)

---

## 🤖 AI Usage Report

### Helpful Prompts

* Used AI to generate initial UI structure
* Used AI to debug Hive integration and DateTime handling
* Used AI to improve code structure and fix runtime errors

### Issues Faced with AI

* AI initially suggested incorrect DateTime storage format for Hive
* Fixed by converting DateTime to ISO string format using:

```dart
toIso8601String()
```

---

## 🎥 Demo Video

(Attach your Google Drive link here)

---

## 📌 Notes

* Focused on stability, clean UX, and fulfilling all core requirements
* Kept architecture simple and beginner-friendly

---

