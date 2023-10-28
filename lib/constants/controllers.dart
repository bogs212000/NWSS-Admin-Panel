import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nwss_admin/controllers/menu_controller.dart';
import 'package:nwss_admin/controllers/navigation_controller.dart';

final fbStore = FirebaseFirestore.instance;
final fbAuth = FirebaseAuth.instance;
String? email = FirebaseAuth.instance.currentUser?.email.toString();
MenuController menuController = MenuController.instance;
NavigationController navigationController = NavigationController.instance;