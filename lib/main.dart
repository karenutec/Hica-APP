import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Auth App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => auth.isAuthenticated
            ? HomeScreen()
            : LoginScreen(),
      ),
      localizationsDelegates: [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: [
    const Locale('es', 'ES'), // Español
  ],
  locale: const Locale('es'), // Forzar la app a usar español
    );
  }
}