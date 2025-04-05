# 🚀 Flutter User Management App

A Flutter-based user management app built using the [ReqRes API](https://reqres.in/) as part of a **Flutter Developer Intern Assignment** at **TechoLab**.

This app demonstrates secure **authentication**, **state persistence**, and full **CRUD operations** on user data with a clean, modern, and responsive UI.

---

## ✅ Features

### 🔐 Authentication
- User Login via ReqRes API (`/api/login`)
- Registration screen (mocked using ReqRes structure)
- Secure token storage using `flutter_secure_storage`
- Auto-login on app restart using stored credentials
- Logout to clear stored state

### 👥 User Management (CRUD)
- **Create**: Add new users via a form dialog
- **Read**: Paginated list of users from the API
- **Update**: Edit user details
- **Delete**: Remove users with confirmation

### 💡 Interactivity Enhancements
- 🔍 **Search & Filter** users by name or email
- ✅ **Form Validation** with error messaging
- 🗑️ **Confirmation Dialogs** before delete/update
- 🍞 **Snackbars** for success/error notifications

### ♾️ Infinite Scroll
- Automatically fetches more users on scroll
- Uses `page` parameter with ReqRes API

### 🌙 Theme Support
- Toggle between Light & Dark Mode
- Theme preference securely stored
- Responsive layout via `LayoutBuilder`

### 📱 Responsive Design
- Optimized for mobile, tablet, and web
- Grid view for wide screens
- List view for compact devices

---

## 📂 Folder Structure

```
lib/
├── models/              # User model class
├── providers/           # Auth, theme, and user providers
├── screens/             # Login, Register, UserList, Profile
├── services/            # API and Auth services
├── widgets/             # Reusable components (dialogs, list tiles)
└── main.dart            # Entry point
```

---

## 🛠️ Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/flutter-user-management.git
cd flutter-user-management
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
flutter run
```

---

## 🔐 Demo Credentials

Use the credentials below to test the login functionality:

```
Email: eve.holt@reqres.in
Password: pistol
```

> Password is arbitrary but `pistol` is used for demo consistency.

---

## 📸 Screenshots

| Login Screen             | User List (Light Theme)      | User List (Dark Theme)      |
|--------------------------|------------------------------|-----------------------------|
| ![login](screenshots/login.png) | ![light](screenshots/user_light.png) | ![dark](screenshots/user_dark.png) |

| User Form Dialog         | User Profile View            |
|--------------------------|------------------------------|
| ![form](screenshots/form.png) | ![profile](screenshots/profile.png) |

---

## 📦 Dependencies

| Package                   | Description                            |
|---------------------------|----------------------------------------|
| `http`                    | REST API requests                      |
| `provider`                | State management                       |
| `flutter_secure_storage` | Secure storage for token/theme         |
| `flutter/material.dart`  | Core Flutter UI and theming tools      |

---

## 📄 Submission Checklist

- ✅ APK File: `build/app/outputs/flutter-apk/app-release.apk`
- ✅ GitHub Repository: [GitHub Repo Link Here](https://github.com/your-username/flutter-user-management)
- ✅ Well-structured README with features, setup, and screenshots
- ✅ Clean, maintainable code with best practices

---

## 🔮 Future Enhancements

- Add local DB (e.g., Hive or Drift) for offline caching
- Integrate unit and widget testing
- Role-based user access (e.g., Admin vs Member)
- Enhanced UI animations and transitions

---

## ✉️ Contact

**TechoLab - Flutter Developer Internship Submission**  
📨 your-email@example.com  
🌐 [your-portfolio.com](https://your-portfolio.com)

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---