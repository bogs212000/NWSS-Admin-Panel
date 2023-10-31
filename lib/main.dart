import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nwss_admin/auth/auth_wrapper.dart';
import 'package:nwss_admin/controllers/menu_controller.dart' as menu_controller;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants/style.dart';
import 'controllers/navigation_controller.dart';




Future<void> main() async {
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBKfKUF6Z_S3K7FfuN0pTRvPEEBqZEXfBg',
      appId: '1:141739949557:android:6e2e149a24741aee0df4bc',
      messagingSenderId: 'your_messaging_sender_id',
      projectId: 'nwss-database',
      databaseURL: 'nwss-database.appspot.com',
      measurementId: 'your_measurement_id',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),


    );
  }
}