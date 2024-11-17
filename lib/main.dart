import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/core/auth_status.dart';
import 'package:taxi_park/core/custom_theme.dart';
import 'package:taxi_park/depency_injection.dart';
import 'package:taxi_park/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:taxi_park/presentation/blocs/data_bloc/data_bloc.dart';
import 'package:taxi_park/presentation/pages/app_view.dart';
import 'package:taxi_park/presentation/pages/login_page.dart';
import 'package:taxi_park/presentation/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => locator<DataBloc>()
            ..add(const OrdersSubscriptionRequested())
            ..add(const DriversSubscriptionRequested())
            ..add(const AddressesSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => locator<AuthenticationBloc>()
            ..add(
              AuthenticationSubscriptionRequested(),
            ),
        ),
      ],
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
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Taxi Park',
      theme: customTheme,
      builder: (context, child) {
        // delay for splash screen
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            switch (state.status) {
              case AuthStatus.unauthenticated:
                await Future.delayed(const Duration(seconds: 1));
                _navigator.pushNamedAndRemoveUntil('/login', (route) => false);
                break;
              case AuthStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil('/home', (route) => false);
                break;
              case AuthStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const AppView(),
      },
    );
  }
}
