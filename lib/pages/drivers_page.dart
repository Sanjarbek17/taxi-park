import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:taxi_park/gen/assets.gen.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: nil,
        title: const Text('Drivers'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Driver Name')),
              DataColumn(label: Text('Car')),
              DataColumn(label: Text('Balance')),
            ],
            dataRowMaxHeight: 100,
            dataRowMinHeight: 50,
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: context.textTheme.bodyLarge),
                        Text('123-456-7890', style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  DataCell(Image.asset(Assets.images.cobalt.path, width: 100)),
                  const DataCell(Text('\$100.00')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: context.textTheme.bodyLarge),
                        Text('123-456-7890', style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  DataCell(Image.asset(Assets.images.nexia2.path, width: 100)),
                  const DataCell(Text('\$200.00')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: context.textTheme.bodyLarge),
                        Text('123-456-7890', style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  DataCell(Image.asset(Assets.images.nexia3.path, width: 100)),
                  const DataCell(Text('\$300.00')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
