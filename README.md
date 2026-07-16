# Citron ID Card Generator

A Flutter application for creating and managing ID cards with a modern, gradient-based UI design. Built using GetX for state management and following a clean architecture pattern.

## 📱 Features

- **User Authentication**: Login with user type selection (Admin, Teacher, Student)
- **ID Card Management**: View and manage student ID cards
- **ID Card Creation**: Add new ID cards with photo capture/selection
- **Modern UI**: Beautiful gradient-based design with smooth animations
- **Image Handling**: Camera and gallery integration with image cropping
- **Native Splash Screen**: Custom splash screen matching app theme

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Application entry point
└── app/
    ├── core/                          # Core functionality and shared resources
    │   ├── api_config/                # API configuration
    │   │   ├── api_const.dart         # API constants
    │   │   ├── client_interceptor.dart # HTTP client interceptors
    │   │   └── rest_client.dart       # REST API client (Dio singleton)
    │   ├── components/                # Reusable UI components
    │   │   ├── app_buttons.dart       # Custom button component with gradient
    │   │   ├── app_dropdown.dart      # Custom dropdown component
    │   │   ├── app_textfield.dart     # Custom text field component
    │   │   ├── common_appbbar.dart    # Common app bar component
    │   │   └── two_line_element.dart  # Two-line form element wrapper
    │   ├── constant/                  # Application constants
    │   │   ├── app_constant.dart      # App-wide constants
    │   │   ├── asset_constant.dart    # Asset path constants
    │   │   └── global_const.dart      # Global constants
    │   ├── theme/                     # Theme configuration
    │   │   ├── app_colors.dart        # Color scheme and gradient generator
    │   │   ├── app_text_style.dart    # Text style definitions
    │   │   └── app_theme.dart         # App theme configuration
    │   └── utils/                     # Utility functions
    │       └── common_utils.dart      # Common utility functions (image picker, permissions)
    ├── modules/                       # Feature modules (GetX pattern)
    │   ├── login/                     # Login module
    │   │   ├── bindings/
    │   │   │   └── login_binding.dart # Dependency injection for login
    │   │   ├── controllers/
    │   │   │   └── login_controller.dart # Login business logic
    │   │   └── views/
    │   │       └── login_view.dart    # Login UI with gradient design
    │   ├── id_card/                   # ID Card listing module
    │   │   ├── bindings/
    │   │   │   └── id_card_binding.dart
    │   │   ├── controllers/
    │   │   │   └── id_card_controller.dart # ID card list management
    │   │   ├── model/
    │   │   │   └── student_id_model.dart   # Student ID card data model
    │   │   └── views/
    │   │       └── id_card_view.dart
    │   └── add_id_card/                # Add ID Card module
    │       ├── bindings/
    │       │   └── add_id_card_binding.dart
    │       ├── controllers/
    │       │   └── add_id_card_controller.dart # Form validation & image handling
    │       ├── model/
    │       │   └── id_card_field_model.dart
    │       └── views/
    │           └── add_id_card_view.dart
    └── routes/                        # Navigation configuration
        ├── app_pages.dart             # GetX route pages definition
        └── app_routes.dart            # Route name constants
```

## 🎨 Architecture

### Design Pattern
- **GetX Architecture**: Following GetX pattern with separation of concerns
    - **Views**: UI components (StatelessWidget)
    - **Controllers**: Business logic and state management (GetxController)
    - **Bindings**: Dependency injection for controllers
    - **Models**: Data models

### State Management
- **GetX**: Reactive state management using `Rx` variables and `Obx` widgets
- **GetX Navigation**: Route management using GetX routing system

### Theme System
- **Dynamic Color System**: Primary color-based gradient generation
- **HSL Color Manipulation**: Automatic generation of light/dark variants
- **Text Styles**: Hierarchical text style system with multiple weights and sizes

## 📦 Dependencies

### Main Dependencies
- `flutter`: SDK
- `get: ^4.7.3` - State management and navigation
- `dio: ^5.9.0` - HTTP client for API calls
- `dropdown_button2: ^2.3.9` - Enhanced dropdown component
- `image_picker` - Camera and gallery image selection
- `image_cropper` - Image cropping functionality
- `permission_handler` - Runtime permissions handling

### Dev Dependencies
- `flutter_lints: ^5.0.0` - Linting rules
- `flutter_native_splash: ^2.4.7` - Native splash screen generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd citron_id_card
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate native splash screen**
   ```bash
   dart run flutter_native_splash:create
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 🎯 Native Splash Screen Configuration

The app uses `flutter_native_splash` package to generate native splash screens for Android and iOS.

### Configuration (in `pubspec.yaml`)

```yaml
flutter_native_splash:
  # Background color matching login screen gradient
  color: "#DFF1E7"
  
  # Splash image (logo)
  image: asset/images/logo.png
  
  # Image alignment
  android_gravity: center
  ios_content_mode: center
  web_image_mode: center
  
  # Fullscreen mode (hides notification bar on Android)
  fullscreen: true
  
  # Android 12+ splash screen configuration
  android_12:
    color: "#DFF1E7"
    image: asset/images/logo.png
    icon_background_color: "#DFF1E7"
```

### Generating Splash Screen

After configuring the splash screen in `pubspec.yaml`, run:

```bash
dart run flutter_native_splash:create
```

This command will:
- Generate splash images for all Android densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi)
- Create Android 12+ splash screen configuration
- Generate iOS splash images (@2x and @3x)
- Update native configuration files automatically

### Updating Splash Screen

To update the splash screen after making changes:

1. Modify the configuration in `pubspec.yaml`
2. Run the generation command again:
   ```bash
   dart run flutter_native_splash:create
   ```

### Removing Splash Screen

To restore the default white splash screen:

```bash
dart run flutter_native_splash:remove
```

## 📱 Modules Overview

### 1. Login Module (`lib/app/modules/login/`)

**Purpose**: User authentication with role-based access

**Features**:
- User type selection (Admin, Teacher, Student)
- Username and password input
- Password visibility toggle
- Form validation
- Beautiful gradient UI with hill background image

**Files**:
- `login_view.dart`: Login screen UI with gradient design
- `login_controller.dart`: Authentication logic and form handling

### 2. ID Card Module (`lib/app/modules/id_card/`)

**Purpose**: Display and manage student ID cards

**Features**:
- List of student ID cards
- Expandable card details
- Student information display (admission number, parent details, address, etc.)

**Files**:
- `id_card_view.dart`: ID card list UI
- `id_card_controller.dart`: ID card data management
- `student_id_model.dart`: Student ID card data model

### 3. Add ID Card Module (`lib/app/modules/add_id_card/`)

**Purpose**: Create new student ID cards

**Features**:
- Photo capture/selection from camera or gallery
- Image cropping functionality
- Form validation (email, mobile, Aadhaar, PAN)
- Permission handling for camera and storage

**Files**:
- `add_id_card_view.dart`: Form UI for creating ID cards
- `add_id_card_controller.dart`: Form validation and image handling logic
- `id_card_field_model.dart`: Form field data model

## 🎨 UI Components

### AppButton
Custom button component with gradient background and shadow effects.

**Usage**:
```dart
AppButton(
  text: "Login",
  onPressed: () {},
  icon: Icon(Icons.arrow_forward),
)
```

### AppTextField
Custom text field with consistent styling and validation support.

**Usage**:
```dart
AppTextField(
  controller: controller,
  hintText: "Enter username",
  validator: (val) => val!.isEmpty ? "Required" : null,
)
```

### AppDropdown
Custom dropdown component with GetX integration.

**Usage**:
```dart
AppDropdown<String>(
  hintText: "Select user type",
  value: selectedValue,
  items: ['Admin', 'Teacher', 'Student'],
  onChanged: (val) => selectedValue = val,
)
```

### TwoLineElement
Wrapper component for form fields with title and required indicator.

**Usage**:
```dart
TwoLineElement(
  title: "Username",
  isRequired: true,
  child: AppTextField(...),
)
```

## 🔧 Core Utilities

### CommonUtils (`lib/app/core/utils/common_utils.dart`)

Provides utility functions for:
- **Image Picker**: Bottom sheet for camera/gallery selection
- **Permission Handling**: Camera and storage permissions
- **Image Cropping**: Integrated image cropping with customizable settings

**Usage**:
```dart
await CommonUtils.showImagePickerBottomSheet(
  context: context,
  onImageSelected: (file) {
    // Handle selected image
  },
);
```

## 🌈 Theme System

### Color System (`lib/app/core/theme/app_colors.dart`)

- **Primary Color**: Base color for the entire app
- **Gradient Generation**: Automatic gradient color generation from primary color
- **Text Colors**: Auto-contrast text colors for gradient backgrounds
- **Border Colors**: Consistent border color system

### Text Styles (`lib/app/core/theme/app_text_style.dart`)

Hierarchical text style system with:
- Display styles (large, medium, small)
- Body styles (large, medium, small)
- Title styles (large, medium, small)
- Multiple weights (regular, medium, semiBold, bold)
- Color variants (black, white, textColor, etc.)

## 🛣️ Navigation

### Routes (`lib/app/routes/`)

- **AppRoutes**: Route name constants
    - `/Login` - Login screen
    - `/IdCard` - ID card list screen
    - `/AddIdCard` - Add ID card screen

- **AppPages**: GetX route definitions with transitions

**Usage**:
```dart
Get.toNamed(AppRoutes.idCard);
```

## 📝 API Configuration

### REST Client (`lib/app/core/api_config/rest_client.dart`)

Singleton REST client using Dio with:
- Base URL configuration
- Interceptor support
- Form URL encoded content type

### Client Interceptor (`lib/app/core/api_config/client_interceptor.dart`)

HTTP request/response interceptors for:
- Logging
- Error handling
- Authentication tokens (if needed)

## 🔐 Permissions

The app requires the following permissions:

### Android
- `CAMERA` - For taking photos
- `READ_MEDIA_IMAGES` (Android 13+) - For accessing gallery
- `READ_EXTERNAL_STORAGE` (Android 12 and below) - For accessing gallery

### iOS
- Camera permission
- Photo library permission

Permissions are handled automatically by the `permission_handler` package.

## 📂 Assets

All assets are located in `asset/images/`:
- `id.png` - ID card icon
- `logo.png` - App logo (used in splash screen)
- `hill.jpeg` - Background image for login screen
- `upload.png` - Upload icon

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 🏗️ Building

### Android
```bash
flutter build apk
# or
flutter build appbundle
```

### iOS
```bash
flutter build ios
```

## 📄 License

This project is private and not published to pub.dev.

## 👥 Contributing

This is a private project. For internal development guidelines, please refer to the team documentation.

## 📞 Support

For issues or questions, please contact the development team.

---

**Built with ❤️ using Flutter and GetX**



Credential
7860925188
abc

------------------ Test School --------------
1234567899  |
abc@123     |
--------------------------------