import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/constants/style.dart';

import '../../../widgets/custom_text.dart';
/// Example without datasource
class AvailableDriversTable extends StatelessWidget {
  const AvailableDriversTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: active.withOpacity(.4), width: .5),
        boxShadow: [BoxShadow(offset: const Offset(0, 6), color: lightGrey.withOpacity(.1), blurRadius: 12)],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           const Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Last Transactions",
                color: lightGrey,
                weight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: (56 * 7) + 40,
            child: DataTable2(
              columnSpacing: 12,
              dataRowHeight: 56,
              headingRowHeight: 40,
              horizontalMargin: 12,
              minWidth: 600,
              columns: const [
                DataColumn2(
                  label: Text("Name"),
                  size: ColumnSize.L,
                ),
                DataColumn(
                  label: Text('Location'),
                ),
                DataColumn(
                  label: Text('Payments'),
                ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              rows: List<DataRow>.generate(
                7,
                (index) => DataRow(
                  cells: [
                    const DataCell(CustomText(text: "Garry Earl Lontes")),
                    const DataCell(CustomText(text: "Sandoval Narra, Palawan")),
                    const DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.money, color: Colors.blue, size: 18),
                          SizedBox(width: 5),
                          CustomText(text: "230"),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        decoration: BoxDecoration(
                          color: light,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.green.shade500, width: .5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: CustomText(
                          text: "Paying",
                          color: Colors.green.withOpacity(.7),
                          weight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
