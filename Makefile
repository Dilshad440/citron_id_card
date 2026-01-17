APP_NAME := $(shell grep '^name:' pubspec.yaml | awk '{print $$2}')
DATE_TIME := $(shell date +"%d-%m-%Y_%I-%M_%p")
APK_DIR := build/app/outputs/flutter-apk
APK_NAME := $(APP_NAME)-$(DATE_TIME).apk

apk:
	flutter clean
	flutter pub get
	flutter build apk --release
	mv $(APK_DIR)/app-release.apk $(APK_DIR)/$(APK_NAME)
	@echo "APK generated: $(APK_DIR)/$(APK_NAME)"
