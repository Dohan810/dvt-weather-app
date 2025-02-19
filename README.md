# Welcome to "Weather Wise" 
<img src="assets/app_on_phone_preview.png" width="100" alt="Mobile View"/>

This document provides an overview of the codebase for a Flutter weather application. It explains the purpose and functionality of each section and file, detailing how the various components interact to form the complete application.

## Screenshots

### Mobile View
![Mobile View](assets/mobile_preview1.png)

![Mobile View](assets/mobile_preview2.png)

## Versions and Tools Used
- **Flutter**: 3.27.2
- **Dart**: 3.6.1

To set up the project, ensure that the versions of Flutter and Dart are as mentioned above. You can manage Flutter versions using FVM (Flutter Version Management).

## Project Structure

```Project Structure
lib
└── src
    ├── api
    │   ├── api.dart
    │   ├── api_keys.dart
    ├── constants
    │   └── app_colors.dart
    ├── features
    │   ├── models
    │   │   ├── forecast_data.dart
    │   │   └── weather_data.dart
    │   └── weather
    │       ├── application
    │       │   ├── layout_provider.dart
    │       │   └── providers.dart
    │       ├── data
    │       │   ├── api_exception.dart
    │       │   └── weather_repository.dart
    │       ├── enums
    │       │   ├── forecast_enum.dart
    │       │   └── unit_enums.dart
    │       ├── presentation
    │       │   └── views
    │       │       ├── weather_desktop.dart
    │       │       ├── weather_mobile.dart
    │       │       ├── weather_tablet.dart
    │       │       └── weather_page.dart
    │       └── widgets
    ├── utils
    │   ├── date_utils.dart
    │   └── formatting_utils.dart
    └── main.dart
   ```

## How to Start the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/weather-wise.git
   ```
2. Navigate to the project directory:
   ```bash
   cd weather-wise
   ```
3. Get the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the project:
   ```bash
   flutter run
   ```

## Generated APK

The generated APK can be found in the `build/app/outputs/flutter-apk` directory after running the build command:
```bash
flutter build apk
```

## Key Dependencies

### State Management and Architecture
- **flutter_bloc: ^9.0.0** - Implements the BLoC (Business Logic Component) pattern for state management, making it easier to separate business logic from UI.
- **get_it: ^8.0.3** - A simple service locator for dependency injection, helping to manage singleton instances across the app.
- **equatable: ^2.0.7** - Simplifies equality comparisons for objects, particularly useful with BLoC pattern for state comparison.

### Media and UI
- **video_player: ^2.9.2** - Enables video playback functionality, used for weather animations and background effects. Used for videos playing on the splash screen
- **share_plus: ^10.1.4** - Provides sharing capabilities to allow users to share weather information with others. Used for "Share Weather" button

### Data Formatting and Localization
- **intl: ^0.20.2** - Handles internationalization and date/time formatting for weather data display. Used for Date handling

### Location Services
- **geolocator: ^13.0.2** - Provides geolocation functionality to get user's current location for weather data. Used for the "Current Location" on weather report

### Local Storage
- **sqflite: ^2.4.1** - SQLite plugin for Flutter, used for local storage of weather data and user preferences. Used to save "saved locations" on the drawer
- **path_provider: ^2.1.5** - Helps locate appropriate storage locations on the device for saving app data. Used for "Share Weather" button to save the file locally to send it via whatsapp

