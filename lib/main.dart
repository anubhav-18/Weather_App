import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/src/UI/search_page.dart';
import 'package:weather_app/src/UI/setting_page.dart';
import 'package:weather_app/src/UI/homepage.dart';
import 'package:weather_app/src/provider/weather_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
        brightness: Brightness.light,
        useMaterial3: true,
        scaffoldBackgroundColor: primaryBckgnd,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            color: whiteColor,
          ),
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: whiteColor,
          ),
          headlineSmall: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: whiteColor,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
            color: whiteColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            color: whiteColor,
          ),
          bodySmall: TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w300,
            color: whiteColor,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBckgnd,
          iconTheme: IconThemeData(color: Colors.white, size: 30),
          titleTextStyle: TextStyle(
            fontSize: 30,
            color: whiteColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBckgnd),
      ),
      home: const WeatherHome(),
      initialRoute: '/',
      routes: {
        '/setting': (context) => const SettingPage(),
        '/search': (context) => const SearchView(),
      },
    );
  }
}


