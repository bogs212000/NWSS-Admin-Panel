import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:package_info_plus/package_info_plus.dart';

double totalAmountBalance = 0.0;

Future<void> calculateTotalAmount(Function setState) async {
  double totalAmount = 0;

  // Query the collection to get all documents
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
      .instance
      .collection("biils")
      .where('paid?', isEqualTo: false)
      .where('clientId', isEqualTo: accountID)
      .get();

  // Iterate through the documents and sum up the amounts
  for (QueryDocumentSnapshot<Map<String, dynamic>> document
  in querySnapshot.docs) {
    // Check if the document data contains the 'amount' key
    if (document.data().containsKey('billAmount')) {
      // Get the 'amount' field from the document data and add it to the total
      totalAmount += (document.data()['billAmount'] as num).toDouble();
    }
  }

  // Print the total amount
  print('Total amount: $totalAmount');

  setState(() {
    totalAmountBalance = totalAmount;
  });
}

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

Future<void> fetchOnlinePay(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Online Payment')
        .get();
    onlinePayment = snapshot.data()?['online_payment'];
  } catch (e) {
    // Handle errors
  }
}

Future<void> fetchCurrentWaterPrice(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('price')
        .doc('price')
        .get();
    currentWaterPrice = snapshot.data()?['current'];
  } catch (e) {
    // Handle errors
  }
}

Future<void> fetchGcashNumber(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Gcash')
        .get();
    gcashNum = snapshot.data()?['Number'];
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
Future<void> fetchFbPage(Function setState) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('App Settings')
        .doc('Users Guide')
        .get();
    fbLink = snapshot.data()?['Link'];
  } catch (e) {
    // Handle errors
  }
}

Future<void> fetchPackageInfo(Function setState) async {
  final info = await PackageInfo.fromPlatform();
  setState(() {
    packageInfo = info.version.toString();
  });
}

