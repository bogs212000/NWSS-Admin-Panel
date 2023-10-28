import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwss_admin/constants/controllers.dart';
import 'package:nwss_admin/constants/style.dart';
import 'package:nwss_admin/routing/routes.dart';
import 'package:nwss_admin/widgets/custom_text.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text("Login",
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  CustomText(
                    text: "Welcome back to NWSS admin panel.",
                    color: lightGrey,
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "abc@domain.com",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "123",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
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

                  CustomText(text: "Forgot password?", color: active)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () async {
                  try {
                    await fbAuth.signInWithEmailAndPassword(
                      email: emailController.text.trim().toString(),
                      password: passwordController.text.trim().toString(),
                    );

                  } catch (e) {print("haha");}

                },
                child: Container(
                  decoration: BoxDecoration(
                      color: active, borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const CustomText(
                    text: "Login",
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: const TextSpan(children: [
                TextSpan(text: "Do not have admin credentials? "),
                TextSpan(
                    text: "Request Credentials! ",
                    style: TextStyle(color: active))
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
