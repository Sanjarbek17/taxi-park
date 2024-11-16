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
              DataColumn(label: Text('Order\nNumber')),
              DataColumn(label: Text('Driver')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Status')),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('1')),
                  DataCell(Text('John Doe')),
                  DataCell(Text('123 Main St')),
                  DataCell(Text('2021-09-01')),
                  DataCell(Text('Completed')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('2')),
                  DataCell(Text('Jane Doe')),
                  DataCell(Text('456 Elm St')),
                  DataCell(Text('2021-09-02')),
                  DataCell(Text('Completed')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('3')),
                  DataCell(Text('John Doe')),
                  DataCell(Text('789 Oak St')),
                  DataCell(Text('2021-09-03')),
                  DataCell(Text('Completed')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
