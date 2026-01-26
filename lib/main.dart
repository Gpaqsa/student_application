import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_data.dart';
import 'screens/main_screen.dart';
import 'utils/colors.dart';
import 'database/database_helper.dart';
import 'services/translation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database; // Initialize database
  
  // Initialize translations service
  await TranslationService().init();
  
  runApp(const ScholarSyncApp());
}

class ScholarSyncApp extends StatelessWidget {
  const ScholarSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: Consumer<AppData>(
        builder: (context, appData, _) {
          return MaterialApp(
            title: 'ScholarSync',
            debugShowCheckedModeBanner: false,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: appData.themeBrightness == Brightness.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: MainScreen(key: mainScreenKey),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white70),
        titleLarge: TextStyle(color: Colors.white),
      ),
    );
  }
}
