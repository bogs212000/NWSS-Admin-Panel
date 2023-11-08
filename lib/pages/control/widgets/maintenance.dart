// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:nwss_admin/constants/controllers.dart'; // Make sure you import your controllers correctly

class Maintenance extends StatefulWidget {
  Maintenance({Key? key}) : super(key: key);

  @override
  State<Maintenance> createState() => _MaintenanceState();
}

class _MaintenanceState extends State<Maintenance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Text('Maintenance '),
          Checkbox(
            value: maintenanceMode, // Make sure 'value' is a boolean variable
            onChanged: (newValue) {
              setState(() {
                updateMaintenance(newValue!);
              });
            }, // Make sure 'onChanged' is a function to handle checkbox changes
          ),
        ],
      ),
    );
  }

  Future<void> updateMaintenance(bool newValue) async {
    maintenanceMode = newValue;
    try {
      await fbStore.collection('App Settings').doc('maintenance').update({
        'maintenance': maintenanceMode,
      });
      _showDialogSuccess();
    } catch (e) {
      _showDialogError();
    }
  }

  void _showDialogSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saved'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Successfully Update'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('An error occurred. Please try again later.'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
