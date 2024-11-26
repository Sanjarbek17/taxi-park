import 'dart:async';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:taxi_park/data/repository/data_repo.dart';
import 'package:taxi_park/depency_injection.dart';
import 'package:taxi_park/presentation/blocs/data_bloc/data_bloc.dart';
import 'package:taxi_park/presentation/pages/drivers_page.dart';
import 'package:taxi_park/presentation/pages/map_page.dart';
import 'package:taxi_park/presentation/pages/orders_page.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final int _currentIndex = 0;
  final PageController _pageController = PageController();

  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
      const Duration(seconds: 20),
      (timer) {
        setState(() {});
        locator<DataBloc>()
          ..add(const OrdersSubscriptionRequested())
          ..add(const DriversSubscriptionRequested())
          ..add(const AddressesSubscriptionRequested());
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          OrdersPage(),
          DriversPage(),
          MapPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (_currentIndex) {
            case 0:
              locator<DataRepo>().getOrders();
              setState(() {});
              break;
            case 1:
              locator<DataRepo>().getDrivers();
              setState(() {});
              break;
            case 2:
              locator<DataRepo>().getAddreses();
              setState(() {});
              break;
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: TweenAnimationBuilder(
          key: UniqueKey(),
          duration: const Duration(seconds: 20),
          tween: Tween<double>(begin: 1, end: 0),
          builder: (context, value, _) {
            return LiquidCircularProgressIndicator(
              value: value,
              valueColor: const AlwaysStoppedAnimation(Colors.yellow),
              backgroundColor: Colors.white,
              direction: Axis.vertical,
              center: const Icon(Icons.refresh),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(pageController: _pageController),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required PageController pageController,
  }) : _pageController = pageController;

  final PageController _pageController;

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget._pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Drivers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
      ],
    );
  }
}
