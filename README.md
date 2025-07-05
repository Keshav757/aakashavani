# 📱 Aakashavani - Flutter Chat App

Aakashavani is a real-time messaging app built with Flutter and Firebase. It supports phone number authentication, profile setup, and chat functionality between users. Designed with simplicity, speed, and modern UI in mind.

---

## 🚀 Features

- 🔐 Phone number login with OTP using Firebase Auth
- 👤 Profile setup with name and image upload
- 💬 Real-time 1-to-1 chat using Firestore
- 📡 Firebase Firestore for scalable backend
- 📸 Image picking from gallery (profile photo)
- 📱 Responsive and modern UI

---

## 🛠️ Tech Stack

- **Flutter**: UI toolkit for natively compiled mobile apps
- **Firebase Authentication**: Phone number login & OTP
- **Firebase Firestore**: Real-time chat data storage
- **Firebase Storage**: For storing profile images
- **Cloud Functions (optional)**: For extending server-side logic

---

## 📂 Project Structure

```plaintext
lib/
├── screens/
│   ├── phone_login_screen.dart
│   ├── profile_setup_screen.dart
│   └── chats_screen.dart
│   └── chat_detail_screen.dart
├── widgets/
│   └── chat_tile.dart
├── main.dart
