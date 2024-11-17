import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_park/data/repository/data_repo.dart';
import 'package:taxi_park/data/services/remote_service.dart';
import 'package:taxi_park/presentation/blocs/orders/orders_bloc.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final pref = await SharedPreferences.getInstance();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://brigadier-api.platform.taximaster.ru/api/v1/',
    ),
  );

  // Registering the Instances
  locator.registerLazySingleton(() => pref);
  locator.registerLazySingleton(() => dio);

  // Registering the Services
  locator.registerLazySingleton(
    () => RemoteService(
      dio: locator(),
      sharedPreferences: locator(),
    ),
  );

  // Registering the Repository
  locator.registerLazySingleton(
    () => DataRepo(remoteService: locator()),
  );

  // Registering the Bloc
  locator.registerLazySingleton(
    () => OrdersBloc(ordersRepository: locator<DataRepo>()),
  );
}
