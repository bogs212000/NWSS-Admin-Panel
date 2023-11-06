// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/helpers/reponsiveness.dart';

class UserGuide extends StatefulWidget {
  const UserGuide({super.key});

  @override
  State<UserGuide> createState() => _UserGuideState();
}

class _UserGuideState extends State<UserGuide> {
  final TextEditingController guideController = TextEditingController();
  bool isSaving = false;
  bool isTextFieldEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Row(
            children: [
              Text('Users Guide :  '),
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: ResponsiveWidget.isSmallScreen(context) ? 100 : 250,
                child: TextField(
                  controller: guideController,
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
                          await fbStore
                              .collection('App Settings')
                              .doc('Users Guide')
                              .update({
                            'Link': guideController.text.toString().trim(),
                          });
                          guideController.clear();
                          _showDialog();
                        } catch (e) {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'An error occurred. Please try again later.'),
                                    // You can add more error information here if needed.
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
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
                    ? Lottie.asset('assets/lottie/animation_loading.json',
                        width: 50, height: 50)
                    : Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saved'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saved Successfully!'),
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
