// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'providers/auth_provider.dart';
import 'providers/help_request_provider.dart';
import 'providers/theme_provider.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/custom_kit_create_screen.dart';

import 'themes/app_theme.dart';

void main() {
  // Flutter engine’i hazırla
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HelpRequestProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        FutureProvider<PackageInfo>(
          create: (_) => PackageInfo.fromPlatform(),
          initialData: PackageInfo(
            appName: '',
            packageName: '',
            version: '0.0.0',
            buildNumber: '',
          ),
        ),
      ],
      child: const AcilYardimApp(),
    ),
  );
}

class AcilYardimApp extends StatelessWidget {
  const AcilYardimApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acil Yardım',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      initialRoute: auth.isLoggedIn ? '/home' : '/login',
      routes: {
        '/login':      (_) => const LoginScreen(),
        '/home':       (_) => const HomeScreen(),
        '/profile':    (_) => const ProfileScreen(),
        '/settings':   (_) => const SettingsScreen(),
        '/custom-kit': (_) => const CustomKitCreateScreen(),
      },
    );
  }
}
