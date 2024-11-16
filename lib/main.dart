import 'package:flutter/material.dart';
import 'package:taxi_park/core/custom_theme.dart';
import 'package:taxi_park/pages/app_view.dart';
import 'package:taxi_park/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Park',
      theme: customTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const AppView(),
        // '/users': (context) => const DriversPage(),
        // '/map': (context) => const MapPage(),
        // '/orders': (context) => const OrdersPage(),
      },
    );
  }
}
