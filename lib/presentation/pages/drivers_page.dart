import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/gen/assets.gen.dart';
import 'package:taxi_park/presentation/blocs/data_bloc/data_bloc.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

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
            if (state.orders.isEmpty) {
              if (state.status == DataStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == DataStatus.loaded) {
                return nil;
              } else {
                return const Center(
                  child: Text('Failed to fetch orders'),
                );
              }
            }
            return SafeArea(
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
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Icon(Icons.circle, color: Colors.red)),
                        customDataCell(
                          context,
                          title: 'John Doe',
                          subtitle: '123-456-7890',
                        ),
                        DataCell(Image.asset(Assets.images.cobalt.path, width: 100)),
                        const DataCell(Text('\$10 000.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Icon(Icons.circle, color: Colors.green)),
                        customDataCell(
                          context,
                          title: 'John Doe',
                          subtitle: '998 99 453 23 12',
                        ),
                        DataCell(Image.asset(Assets.images.nexia2.path, width: 100)),
                        const DataCell(Text('\$200.00')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(Icon(Icons.circle, color: Colors.green)),
                        customDataCell(
                          context,
                          title: 'John Doe',
                          subtitle: '123-456-7890',
                        ),
                        DataCell(Image.asset(Assets.images.nexia3.path, width: 100)),
                        const DataCell(Text('\$300.00')),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
              style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: context.width * 0.26,
            child: Text(
              subtitle ?? '',
              style: context.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
