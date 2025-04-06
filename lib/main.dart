import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart'; // Initial splash screen

import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Global theme management
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        
        // Authentication state management (e.g., login/logout/token)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        
        // User data management (CRUD, search, etc.)
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to theme changes (light/dark mode)
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReqRes Flutter App',
      themeMode: themeProvider.themeMode, // Use selected theme mode
      theme: ThemeData.light(),           // Light theme config
      darkTheme: ThemeData.dark(),        // Dark theme config
      home: const SplashScreen(),         // Launch SplashScreen first
    );
  }
}
