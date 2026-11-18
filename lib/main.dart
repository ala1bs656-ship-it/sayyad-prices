import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SayyadPricesApp());
}

class SayyadPricesApp extends StatelessWidget {
  const SayyadPricesApp({super.key});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF16865B);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صيّاد الأسعار',
      locale: const Locale('ar'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: green),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F7),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
