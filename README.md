# Progress — Language Learning App 🌍

An interactive mobile application for learning foreign languages. Built with Flutter, inspired by the Duolingo experience.

> 📺 **Demo:** [t.me/tolibtalmobile](https://t.me/tolibtalmobile)

---

## ✨ Features

- ❤️ **Lives system** — lose hearts on wrong answers, just like Duolingo
- 🔥 **Daily streak** — track your learning consistency every day
- 📊 **Level tests** — structured lessons from A1 to A2
- 📚 **Word cards** — searchable vocabulary with categories:
  - Grammar · Differences · Thesaurus · Collocations · Metaphors · Speaking
- 🔐 **Firebase Auth** — phone number + OTP authentication
- 🌙 **Dark / Light theme**
- 🌐 **Multilingual UI** — powered by easy_localization

---

## 🛠 Tech Stack

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=flat&logo=sqlite&logoColor=white)

| Layer | Technology |
|-------|-----------|
| UI Framework | Flutter + Dart |
| State Management | Provider |
| Navigation | GoRouter |
| Local Database | SQLite (sqflite) |
| Local Storage | Hive |
| Cloud & Auth | Firebase Auth + Cloud Firestore |
| Localization | easy_localization |

---

## 📸 Screenshots

| | | |
|:---:|:---:|:---:|
| <img src="assets/image/screen/1.jpg" width="200"/> | <img src="assets/image/screen/2.jpg" width="200"/> | <img src="assets/image/screen/3.jpg" width="200"/> |
| <img src="assets/image/screen/4.jpg" width="200"/> | <img src="assets/image/screen/5.jpg" width="200"/> | <img src="assets/image/screen/6.jpg" width="200"/> |
| <img src="assets/image/screen/7.jpg" width="200"/> | <img src="assets/image/screen/8.jpg" width="200"/> | <img src="assets/image/screen/9.jpg" width="200"/> |
| <img src="assets/image/screen/10.jpg" width="200"/> | <img src="assets/image/screen/11.jpg" width="200"/> | <img src="assets/image/screen/12.jpg" width="200"/> |
| <img src="assets/image/screen/13.jpg" width="200"/> | | |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.9.0`
- Dart SDK
- Android Studio or VS Code

### Run locally

```bash
git clone https://github.com/taltolib/progress_app.git
cd progress_app
flutter pub get
flutter run
```

### Test credentials

You can log in with the following test account:

| Field | Value |
|-------|-------|
| Phone | `+998 00 100 01 01` |
| OTP code | `010101` |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── providers/     # App state (auth, game, theme...)
│   ├── navigation/    # GoRouter setup
│   ├── database/      # SQLite service
│   └── firebase/      # Firebase config
├── domain/
│   ├── models/        # Data models
│   └── enums/         # App enums
├── features/          # Screens (home, login, game...)
└── shared/
    └── widget/        # Reusable UI components
```

---

## 👤 Author

**taltolib** — Junior Flutter Developer

[![GitHub](https://img.shields.io/badge/GitHub-taltolib-181717?style=flat&logo=github)](https://github.com/taltolib)
[![Telegram](https://img.shields.io/badge/Telegram-tolibtalmobile-2CA5E0?style=flat&logo=telegram)](https://t.me/tolibtalmobile)
