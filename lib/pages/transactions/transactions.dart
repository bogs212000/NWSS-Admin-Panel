// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/transactions/widgets/transaction_table.dart';
import 'package:nwss_admin/widgets/custom_text.dart';


class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Column(
      children: [
        Obx(() {
          return Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6,
                ),
                child: CustomText(
                  text: menuController.activeItem.value,
                  size: 24,
                  weight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 40,
              width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    searchClients = text;
                  });
                },
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: const TransactionTable(),
        ),
      ],
    );
  }
}
