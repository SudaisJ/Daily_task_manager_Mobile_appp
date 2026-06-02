# 🎯 Task Manager App

A modern, highly-responsive Flutter application designed for managing daily tasks and routines. Built using a robust 3-layer architecture, utilizing **SQLite** for offline-first persistent task storage and **SharedPreferences** for session authentication persistence.

---

## 🚀 Key Features

*   **🔒 Persistent Authentication**: Seamless login and signup session persistence. Users stay logged in even after closing/killing the app until they explicitly press "Logout".
*   **📂 Offline-First Database**: Full CRUD operations powered by SQLite database.
*   **🏷️ Smart Task Management**: Organize tasks by priority (High, Medium, Low) and track due dates.
*   **🎨 Premium Modern UI**: Sleek Material 3 layout, clean animations, and responsive interactions.
*   **⚡ State Management**: Utilizes the `Provider` pattern for responsive state handling and reactive UI updates.

---

## 🛠️ Architecture & Tech Stack

This project follows a clean **Controller-Repository-Model** pattern:

*   **Frontend**: Flutter (Material 3)
*   **State Management**: `Provider`
*   **Local Storage**: `sqflite` (SQLite database helper)
*   **Session Management**: `shared_preferences`

### Folder Directory Map
```
lib/
├── controllers/      # Business logic & state management (AuthController, TaskController)
├── models/           # Data structure schemas (User, Task)
├── repositories/     # Data source queries (TaskRepository)
├── screens/          # Presentation Layer UI files
└── main.dart         # App entrypoint and MaterialApp configuration
```

---

## ⚙️ Getting Started & Installation

### Prerequisites

*   **Flutter SDK**: `>=3.0.0 <4.0.0`
*   **Dart SDK**: `>=3.10.8`

### Setup Instructions

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/SudaisJ/Daily_task_manager_Mobile_appp.git
    cd Daily_task_manager_Mobile_appp
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run Tests**:
    ```bash
    flutter test
    ```

4.  **Run the Application**:
    ```bash
    flutter run
    ```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to open a Pull Request or report bugs via Github Issues.
