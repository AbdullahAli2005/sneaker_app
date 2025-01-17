# Sneakers App

A Flutter-based mobile application to browse and manage sneaker collections. The project is currently under development, utilizing Firebase for backend integration and modern Material Design principles.

---

## Features

- **Firebase Authentication:** Secure login and registration.
- **Material Design UI:** Leveraging Material Components for an engaging user experience.
- **Responsive Layout:** Optimized for various device sizes.
- **Dynamic Content:** Real-time updates through Firebase integration.

---

## Requirements

To run this project, ensure you have the following installed:

- **Flutter SDK:** Version 3.10.0 or higher
- **Android Studio / Visual Studio Code:** Preferred IDEs for Flutter development
- **Android SDK:** Minimum API level 23
- **Firebase CLI:** For backend configuration

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/yourusername/sneakers_app.git
cd sneakers_app
```

### Install Dependencies

```bash
flutter pub get
```

### Configure Firebase

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Add Android app credentials to the project:
   - **Package Name:** `com.example.sneakers_app`
   - Download the `google-services.json` file and place it in the `android/app/` directory.
4. Run the following command to initialize Firebase:

   ```bash
   flutterfire configure
   ```

### Run the Application

#### For Android:
```bash
flutter run
```

#### For iOS:
```bash
flutter run --no-sound-null-safety
```

---

## Troubleshooting

### Common Issues

#### Black Icon on App Launcher
If your app shows a black icon on the launcher, ensure the following:
1. Verify your app icon in the `assets/images` directory.
2. Run the following command to regenerate launcher icons:

   ```bash
   flutter pub run flutter_launcher_icons:main
   ```
3. Check the `android:icon` field in the `AndroidManifest.xml` file for correctness:

   ```xml
   android:icon="@mipmap/ic_launcher"
   ```

#### Manifest Resource Linking Failed
1. Ensure your `build.gradle` file includes:
   ```gradle
   implementation 'com.google.android.material:material:1.9.0'
   ```
2. Set `compileSdk` and `targetSdk` versions to 33 in `android/app/build.gradle`.

---

## Project Structure

```plaintext
sneakers_app/
|
|-- android/       # Native Android project files
|-- assets/        # App assets (e.g., images, icons)
|-- lib/           # Main Flutter application files
|   |-- main.dart  # Entry point for the app
|-- pubspec.yaml   # Project dependencies and assets
```

---

## Contributions

Contributions are welcome! Feel free to submit a pull request or open an issue.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---

## Contact

For inquiries or support, please reach out to:

- **Email:** smabd7409@gmail.com
