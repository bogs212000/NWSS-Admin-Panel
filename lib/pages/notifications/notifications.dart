import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';
import 'package:nwss_admin/pages/notifications/widgets/notifications_data.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionsController = TextEditingController();
  String selectedValue = 'Client';
  List<String> dropdownItems = ['Client', 'Reader', 'All'];

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: () {
                _showInput(context);
              },
              child: Row(
                children: const [
                  Text("Add"),
                  Icon(Icons.add),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: const NotificationsTable(),
        ),
      ],
    );
  }

  void _showInput(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Notification'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${formattedDate}, ${formattedTime}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(

                    width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                    child: TextField(
                      maxLines: 3, // Set the number of lines to 3
                      decoration: InputDecoration(
                        labelText:  "Descriptions",
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Filter:  '),
                      Container(
                        color: Colors.white,
                        child: DropdownButton<String>(
                          value: selectedValue,
                          items: dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showInput1(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {},
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
