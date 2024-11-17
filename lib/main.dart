import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/core/custom_theme.dart';
import 'package:taxi_park/depency_injection.dart';
import 'package:taxi_park/presentation/blocs/orders/orders_bloc.dart';
import 'package:taxi_park/presentation/pages/app_view.dart';
import 'package:taxi_park/presentation/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<OrdersBloc>()
        ..add(
          const OrdersSubscriptionRequested(),
        ),
      child: const MyApp(),
    );
  }
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
      },
    );
  }
}
