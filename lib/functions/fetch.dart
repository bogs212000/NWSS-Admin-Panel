import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nwss_admin/constants/controllers.dart';

Future<void> fetchRelease(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('release')
        .get();
    releaseMode = snapshot.data()?['releaseMode'];
  } catch (e) {
    // Handle errors
  }
}

Future<void> fetchMaintenance(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('maintenance')
        .get();
    maintenanceMode = snapshot.data()?['maintenance'];
  } catch (e) {
    // Handle errors
  }
}

Future<void> fetchControl(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Control')
        .get();
    forceUpdate = snapshot.data()?['force update'];
    controlNote = snapshot.data()?['note'];
  } catch (e) {
    // Handle errors
  }
}
Future<void> fetchTermsConditions(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Terms and conditions')
        .get();
    termsConditionsLink = snapshot.data()?['Link'];
  } catch (e) {
    // Handle errors
  }
}
Future<void> fetchGuide(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Users Guide')
        .get();
    guideLink = snapshot.data()?['Link'];
  } catch (e) {
    // Handle errors
  }
}

