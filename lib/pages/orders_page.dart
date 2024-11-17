import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: nil,
        title: const Text('Orders'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Driver & Phone')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Cost')),
            ],
            columnSpacing: 0,
            dataRowMinHeight: 10,
            dataRowMaxHeight: 100,
            rows: [
              DataRow(
                cells: [
                  customDataCell(
                    context,
                    title: 'Jabborov Jasur',
                    subtitle: '99 999 99 99',
                  ),
                  addressDataCell(
                    context,
                    title: '30ПедКолледж /Булунгур/',
                    subtitle: '30-8Богча /Булунгур/ * (определен автоматически)',
                  ),
                  const DataCell(Text('RUB 50 000')),
                ],
              ),
              DataRow(
                cells: [
                  customDataCell(
                    context,
                    title: 'Jabborov Jasur',
                    subtitle: '99 999 99 99',
                  ),
                  addressDataCell(
                    context,
                    title: '30ПедКолледж /Булунгур/',
                    subtitle: '30-8Богча /Булунгур/ * (определен автоматически)',
                  ),
                  const DataCell(Text('RUB 5 000')),
                ],
              ),
              DataRow(
                cells: [
                  customDataCell(
                    context,
                    title: 'Jabborov Jasur',
                    subtitle: '99 999 99 99',
                  ),
                  addressDataCell(
                    context,
                    title: '30ПедКолледж /Булунгур/',
                    subtitle: '30-8Богча /Булунгур/ * (определен автоматически)',
                  ),
                  const DataCell(Text('RUB 50 000')),
                ],
              ),
            ],
          ),
        ),
      ),
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
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
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
