#!/bin/bash

# --- Configuration ---
# Base path for new feature modules
BASE_MODULES_DIR="lib/app/modules"
# Path to the shared route file
BASE_ROUTES_DIR="lib/app/routes"
# ---------------------

# Function to convert a string to snake_case (e.g., 'SplashPage' -> 'splash_page')
to_snake_case() {
    echo "$1" | sed 's/\(.\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

# Function to convert a string to UpperCamelCase (e.g., 'splash_page' -> 'SplashPage')
to_upper_camel_case() {
    echo "$1" | awk -F'_' '{
        for (i=1; i<=NF; i++) {
            printf "%s", toupper(substr($i,1,1)) substr($i,2)
        }
        print ""
    }'
}

# --- Script Start ---
if [ -z "$1" ]; then
    echo "❌ Error: Please provide the name of the new module (e.g., Splash, Login, ProductDetails)."
    echo "Usage: ./getx_cli.sh <ModuleName>"
    exit 1
fi

MODULE_NAME="$1"
SNAKE_CASE_NAME=$(to_snake_case "$MODULE_NAME")
UPPER_CAMEL_NAME=$(to_upper_camel_case "$MODULE_NAME")
MODULE_DIR="$BASE_MODULES_DIR/$SNAKE_CASE_NAME"

echo "========================================"
echo "🚀 Creating New GetX Module: $UPPER_CAMEL_NAME"
echo "========================================"

# --- 1. Create Folder Structure ---
echo "📂 Creating folder structure at: $MODULE_DIR"
mkdir -p "$MODULE_DIR/bindings"
mkdir -p "$MODULE_DIR/controllers"
mkdir -p "$MODULE_DIR/views"

if [ $? -ne 0 ]; then
    echo "❌ Failed to create directories. Check permissions."
    exit 1
fi
echo "✅ Directories created."

# --- 2. Create Controller File ---
CONTROLLER_FILE="$MODULE_DIR/controllers/${SNAKE_CASE_NAME}_controller.dart"
echo "📄 Creating Controller: $CONTROLLER_FILE"

cat << EOF > "$CONTROLLER_FILE"
import 'package:get/get.dart';

class ${UPPER_CAMEL_NAME}Controller extends GetxController {

  @override
  void onInit() {
     super.onInit();
   }
}
EOF

# --- 3. Create Binding File ---
BINDING_FILE="$MODULE_DIR/bindings/${SNAKE_CASE_NAME}_binding.dart"
CONTROLLER_RELATIVE_PATH="../controllers/${SNAKE_CASE_NAME}_controller.dart"
echo "📄 Creating Binding: $BINDING_FILE"

cat << EOF > "$BINDING_FILE"
import 'package:get/get.dart';
import '$CONTROLLER_RELATIVE_PATH';

class ${UPPER_CAMEL_NAME}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${UPPER_CAMEL_NAME}Controller>(
      () => ${UPPER_CAMEL_NAME}Controller(),
    );
  }
}
EOF

# --- 4. Create View File ---
VIEW_FILE="$MODULE_DIR/views/${SNAKE_CASE_NAME}_view.dart"
BINDING_RELATIVE_PATH="../controllers/${SNAKE_CASE_NAME}_controller.dart" # View imports controller logic

echo "📄 Creating View: $VIEW_FILE"
cat << EOF > "$VIEW_FILE"
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '$BINDING_RELATIVE_PATH';

class ${UPPER_CAMEL_NAME}View extends GetView<${UPPER_CAMEL_NAME}Controller> {
  const ${UPPER_CAMEL_NAME}View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(),
    );
  }
}
EOF

echo -e "\n🎉 Module files for '$UPPER_CAMEL_NAME' created successfully!"

# --- 5. Routing Instructions ---
echo -e "\n--- ⚠️ IMPORTANT: ROUTING STEP ---"
echo "The module files are created. Now, run the Dart script to inject the route:"
echo -e "\n➡️  **Run the following command** (from your project root):"
echo "dart route_injector.dart $UPPER_CAMEL_NAME $SNAKE_CASE_NAME"
echo -e "---------------------------------\n"