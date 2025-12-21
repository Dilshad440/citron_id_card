// route_injector.dart - Updated for separate AppRoutes/AppPages files
import 'dart:io';

// Function to convert UpperCamelCase to lowerCamelCase (e.g., 'SplashPage' -> 'splashPage')
String toLowerCamelCase(String input) {
  if (input.isEmpty) return '';
  final firstChar = input[0].toLowerCase();
  return firstChar + input.substring(1);
}

// Function to convert UpperCamelCase to lower_snake_case (e.g., 'SplashPage' -> 'splash_page')
String toSnakeCase(String input) {
  return input.replaceAllMapped(RegExp(r'([A-Z])'), (match) => '_${match.group(1)!.toLowerCase()}').replaceFirst('_', '');
}


void main(List<String> arguments) {
  if (arguments.length != 2) {
    print('Usage: dart route_injector.dart <UpperCamelCaseName> <snake_case_name>');
    exit(1);
  }

  final upperCamelName = arguments[0]; // e.g., 'SplashPage'
  final snakeCaseName = arguments[1];   // e.g., 'splash_page' (used for module folder)

  // Route properties
  final routePath = '/$upperCamelName'; // The actual path string: /SplashPage
  final routeConstantName = toLowerCamelCase(upperCamelName); // e.g., 'splashPage'
  final bindingName = '${upperCamelName}Binding';
  final viewName = '${upperCamelName}View';

  // File paths
  const routesFilePath = 'lib/app/routes/app_routes.dart';
  const pagesFilePath = 'lib/app/routes/app_pages.dart';

  print('Injecting route for $upperCamelName...');

  // --- 1. Update app_routes.dart ---
  try {
    final routesFile = File(routesFilePath);
    if (!routesFile.existsSync()) {
      print('❌ Error: $routesFilePath not found. Create it first.');
      return;
    }

    var content = routesFile.readAsStringSync();

    // New route string: static const String splashPage = '/SplashPage';
    final newRouteString = '  static const String $routeConstantName = \'$routePath\';';

    if (!content.contains(newRouteString)) {
      // Find the closing brace of the class (}) and insert the new route string before it.
      // Use regex to target the AppRoutes class specifically.
      content = content.replaceAllMapped(
        RegExp(r'(class\s+AppRoutes\s*\{[^}]*)(\s*\})', dotAll: true),
            (match) {
          // Check again within the match group just to be safe
          if (!match.group(1)!.contains(newRouteString)) {
            return '${match.group(1)!}\n$newRouteString${match.group(2)!}';
          }
          return match.group(0)!;
        },
      );
      routesFile.writeAsStringSync(content);
      print('✅ Added route to $routesFilePath: $routeConstantName');
    } else {
      print('ℹ️ Route $routeConstantName already exists in $routesFilePath. Skipping.');
    }
  } catch (e) {
    print('❌ Failed to update $routesFilePath: $e');
  }


  // --- 2. Update app_pages.dart ---
  try {
    final pagesFile = File(pagesFilePath);
    if (!pagesFile.existsSync()) {
      print('❌ Error: $pagesFilePath not found. Please ensure the file exists.');
      return;
    }

    var content = pagesFile.readAsStringSync();

    // 2. Prepare new imports
    // Imports assume the path convention: 'lib/app/modules/<snake_case_name>/bindings/<snake_case_name>_binding.dart'
    final importBinding = 'import \'../modules/$snakeCaseName/bindings/${snakeCaseName}_binding.dart\';';
    final importView = 'import \'../modules/$snakeCaseName/views/${snakeCaseName}_view.dart\';';

    // 3. Prepare new GetPage block
    final newPageBlock = '''
    GetPage(
      name: AppRoutes.$routeConstantName,
      page: () => const $viewName(),
      binding: $bindingName(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),''';

    // Check if the route is already present before modification
    if (content.contains('name: AppRoutes.$routeConstantName,')) {
      print('ℹ️ GetPage for $upperCamelName already exists in $pagesFilePath. Skipping injection.');
      return;
    }

    // 4. Inject Imports (insert at the top of the file)
    if (!content.contains(importBinding)) {
      content = '$importBinding\n$importView\n$content';
    }

    // 5. Inject GetPage block (assuming AppPages.pages is a list ending with `];`)
    // This regex looks for the closing bracket of the list (];) optionally followed by whitespace/newlines
    content = content.replaceAll(
        RegExp(r'\s*];\s*$', multiLine: true),
        '\n$newPageBlock\n];'
    );

    pagesFile.writeAsStringSync(content);
    print('✅ GetPage successfully injected into $pagesFilePath!');

  } catch (e) {
    print('❌ Failed to update $pagesFilePath: $e');
  }
}