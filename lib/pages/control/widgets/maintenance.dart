import 'package:flutter/cupertino.dart';
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

  void updateMaintenance(bool newValue) {
    maintenanceMode = newValue;
    fbStore.collection('App Settings').doc('maintenance').update({
      'maintenance': maintenanceMode,
    });
  }
}
