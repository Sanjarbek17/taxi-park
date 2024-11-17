import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_park/data/models/order_model.dart';
import 'package:taxi_park/presentation/blocs/orders/data_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: nil,
        title: const Text('Orders'),
      ),
      body: BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == OrdersStatus.error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Failed to fetch orders'),
                ),
              );
          }
        },
        child: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state.orders.isEmpty) {
              if (state.status == OrdersStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.status == OrdersStatus.loaded) {
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
                    columns: const [
                      DataColumn(label: Text('Driver')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Cost')),
                    ],
                    columnSpacing: 5,
                    dataRowMinHeight: 10,
                    dataRowMaxHeight: 100,
                    rows: state.orders
                        .map(
                          (order) => orderRow(context, order),
                        )
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

  DataRow orderRow(BuildContext context, OrderModel order) {
    return DataRow(
      cells: [
        customDataCell(
          context,
          title: order.driverId.name,
          subtitle: order.status,
        ),
        addressDataCell(
          context,
          title: order.addresses.first,
          subtitle: order.addresses.last,
        ),
        DataCell(Text('RUB ${order.cash}')),
      ],
    );
  }

  DataCell addressDataCell(BuildContext context, {String? title, String? subtitle}) {
    return DataCell(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.width * 0.46,
            child: Text(
              title ?? '',
              style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: context.width * 0.46,
            child: Text(
              subtitle ?? '',
              style: context.textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
              maxLines: 2,
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: context.width * 0.26,
            child: Text(
              subtitle ?? '',
              style: context.textTheme.bodySmall?.copyWith(
                color: subtitle == 'finished' ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
