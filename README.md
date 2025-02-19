# Weather Wise

This document provides an overview of the codebase for a Flutter weather application. It explains the purpose and functionality of each section and file, detailing how the various components interact to form the complete application.

## Versions and Tools Used
- **Flutter**: 3.19.6
- **Dart**: 2.19.6
- **Provider**: 6.0.5

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

## Screenshots

### Mobile View
![Mobile View](assets/mobile_preview1.png)

![Mobile View](assets/mobile_preview2.png)
