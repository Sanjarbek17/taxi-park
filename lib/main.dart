import 'package:flutter/material.dart';
import 'package:taxi_park/pages/login_page.dart';
import 'package:taxi_park/pages/map_page.dart';
import 'package:taxi_park/pages/users_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Park',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/users': (context) => const UsersPage(),
        '/map': (context) => const MapPage(),
      },
    );
  }
}
