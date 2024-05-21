import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/pages/loading.dart';

import '../../constants/style.dart';
import '../../widgets/custom_text.dart';
import 'authentication.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cpasswordController = TextEditingController();
  bool isLoading = false;
  String role = 'admin';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Loading()
        : Scaffold(
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 12),
                        //   child: Image.asset("assets/icons/logo.png"),
                        // ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "Request Credentials",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "abc@gmail.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "123456",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: cpasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: "123456",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Row(
                        //   children: [
                        //     Checkbox(value: true, onChanged: (value){}),
                        //     const CustomText(text: "Remeber Me",),
                        //   ],
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty ||
                              cpasswordController.text.isEmpty) {
                            // Handle the case where any of the fields are empty
                            // You might show an error message or perform other actions
                            print("Please fill in all fields.");
                          } else if (passwordController.text !=
                              cpasswordController.text) {
                            // Handle the case where the passwords do not match
                            print("Passwords do not match.");
                          } else {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .createUserWithEmailAndPassword(
                              email: emailController.text.trim(),
                              password: passwordController.text,
                            );
                            await fbStore.collection('admin').doc(emailController.text.toString()).set({
                              'role': role,
                              'email': emailController.text.trim().toString(),
                            });

                            // The user has been successfully created
                            print("User created: ${userCredential.user?.uid}");
                          }
                          setState(() {
                            isLoading = false;
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          print(e);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: active,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child:  CustomText(
                          text: "Request",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Have an account?  ",
                            style: TextStyle(color: Colors.black)),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(color: active),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Route _toLogIn() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, anotherAnimation) =>
          AuthenticationPage(),
      transitionDuration: Duration(milliseconds: 1000),
      reverseTransitionDuration: Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn,
            curve: Curves.fastLinearToSlowEaseIn);

        return SlideTransition(
            position: Tween(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                .animate(animation),
            textDirection: TextDirection.rtl,
            child: AuthenticationPage());
      },
    );
  }
}
