
# Attendance Tracker

This is a flutter project aimed for tracking the attendance records of users in a particular workspace. 

## ✨ Features
- **User Authentication:** Sign up and log in with name/ phone number.
- **Data Persistence:** Stores user data locally using Shared Preferences.
- **Attendance Tracking:**
  
  - Records check-in and check-out times.
  
  - Initiates and ends breaks with precise timestamps.

  - Calculates and displays total work hours.


 - **Profile Management:**

    - You can view personal details like name, mobile number, and email.

    - *Editable Profile:* Update user details, including the mobile number, which updates the login credentials and all historical attendance data.

 - **Attendance History:**

   - You can view a complete history of all check-in, break, and check-out timestamps.
   
   - The table is responsive and expands to fit the screen.

 - **Persistent Data:** All user and attendance data is stored locally using an sqflite database.
 -  **Intuitive UI:** A clean, modern user interface with clear navigation.

## 🛠️ Technologies Used
- **Flutter:** The primary framework for building the cross-platform mobile application.
- **Dart:** The programming language used by Flutter.
- **sqflite:** A popular Flutter plugin for managing SQLite databases on Android and iOS.
-  **path:** Used for finding the correct path for the database file.
-  **intl:** A Flutter package for date and time formatting.

## 🚀 Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

 **Prerequisites**
  - Flutter SDK: Install [Flutter](https://docs.flutter.dev/get-started/install)
  - Android Studio or VS Code with Flutter and Dart plugins.

 **Installation**
 1.  Clone the repository:

  ```bash
    git clone [https://github.com/AnanyaBinjola/Attendance_tracker]
    cd [Flutter]
  ```
 2. Install dependencies:

  ```bash
    flutter pub get
  ```
3. Run the application:
  ```bash
    flutter run
  ```

## 📂 Project Structure
A brief overview of the key files and directories:

- **(lib/main.dart):** The entry point of the application.
- **lib/login.dart:** The user login screen.
- **lib/breakstart.dart:** Screen to start a break.
- **lib/breakend.dart:** Screen to end a break.
- **lib/checkout.dart:** The check-out success screen.
- **lib/profile.dart:** Screen to view and edit user profiles.
- **lib/attendance.dart:** Displays the user's attendance history in a table.
- **lib/appState.dart:** Manages the application's global state and business logic, including database interactions.
- **lib/database_helper.dart:** Handles all database operations using sqflite.

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to submit a pull request.
  
## 📜 License
Distributed under the MIT License. See [LICENSE](LICENSE) for more information.






  
