import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:nwss_admin/controllers/menu_controller.dart';
import 'package:nwss_admin/controllers/navigation_controller.dart';

final fbStore = FirebaseFirestore.instance;
final fbAuth = FirebaseAuth.instance;
String? email = FirebaseAuth.instance.currentUser?.email.toString();
MenuController menuController = MenuController.instance;
NavigationController navigationController = NavigationController.instance;
bool? releaseMode;
bool? onlinePayment;
bool? maintenanceMode;
double? currentWaterPrice;
String? controlNote;
bool? forceUpdate;
String? guideLink;
String? fbLink;
String? termsConditionsLink;
String searchClients = "";
DateTime now = DateTime.now();
String formattedDate = DateFormat('EEEE, yyyy-MM-dd').format(now);
String formattedTime = DateFormat('h:mm a').format(now);
String? packageInfo;
String? dayNight = DateFormat('h').format(now);
String? userChatEmail;
String? userFullname;
String? gcashNum;
String? accountID;
String? account_ID;
