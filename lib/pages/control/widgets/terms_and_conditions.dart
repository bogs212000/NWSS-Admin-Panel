// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final TextEditingController termsAndConditionsController =
      TextEditingController();
  bool isSaving = false;
  bool isTextFieldEmpty = true;
  @override
  void initState() {
    super.initState();

    termsAndConditionsController.addListener(() {
      setState(() {
        isTextFieldEmpty = termsAndConditionsController.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Row(
            children: [
              Text('Terms and Conditions :  '),
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                child: TextField(
                  controller: termsAndConditionsController,
                  decoration: InputDecoration(
                    labelText: "Link",
                    hintText: "https://.....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      isTextFieldEmpty = text.isEmpty;
                    });
                  },
                ),
              ),
              SizedBox(width: 20),
              ElevatedButton(

                onPressed: isTextFieldEmpty || isSaving
                    ? null
                    : () async {
                  setState(() {
                    isSaving = true;
                  });

                  try {
                    await fbStore.collection('App Settings').doc('Terms and conditions').update({
                      'Link': termsAndConditionsController.text.toString().trim(),
                    });
                    termsAndConditionsController.clear();
                  } catch (e) {

                    await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('An error occurred. Please try again later.'),
                              // You can add more error information here if needed.
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
                  } finally {
                    setState(() {
                      isSaving = false;
                    });
                  }
                },
                child: isSaving
                    ? Lottie.asset('assets/lottie/animation_loading.json', width: 50, height: 50)
                    : Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
