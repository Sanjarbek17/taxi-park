import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/data/models/driver_model.dart';
import 'package:taxi_park/gen/assets.gen.dart';
import 'package:taxi_park/presentation/blocs/data_bloc/data_bloc.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  @override
  void initState() {
    super.initState();
    print('initState DriversPage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: nil,
        title: const Text('Drivers'),
      ),
      body: BlocListener<DataBloc, DataBlocState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == DataStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Failed to fetch orders'),
                ),
              );
          }
        },
        child: BlocBuilder<DataBloc, DataBlocState>(
          builder: (context, state) {
            print('DriversPage: ${state.drivers.length}');
            if (state.drivers.isEmpty) {
              if (state.driverStatus == DataStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.driverStatus == DataStatus.loaded) {
                return nil;
              } else {
                return const Center(
                  child: Text('Failed to fetch orders'),
                );
              }
            }
            return SafeArea(
              child: SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 10,
                    columns: const [
                      DataColumn(label: Text('Online')),
                      DataColumn(label: Text('Driver Name')),
                      DataColumn(label: Text('Car')),
                      DataColumn(label: Text('Balance')),
                    ],
                    dataRowMaxHeight: 100,
                    dataRowMinHeight: 50,
                    rows: state.drivers
                        .map((driver) => driverRow(
                              context,
                              driver,
                            ))
                        .toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DataRow driverRow(BuildContext context, DriverModel driver) {
    return DataRow(
      cells: [
        DataCell(Icon(Icons.circle, color: driver.online ?? false ? Colors.green : Colors.red)),
        customDataCell(
          context,
          title: driver.name,
          subtitle: driver.phoneNumber,
        ),
        DataCell(Image.asset(Assets.images.cobalt.path, width: 100)),
        DataCell(Text('₽${driver.balance}')),
      ],
    );
  }

  DataCell customDataCell(BuildContext context, {String? title, String? subtitle}) {
    return DataCell(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.width * 0.26,
            child: Text(
              title ?? '',
              maxLines: 2,
              style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: context.width * 0.26,
            child: Text(
              subtitle ?? '',
              maxLines: 2,
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
