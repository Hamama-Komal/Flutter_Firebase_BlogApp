import 'package:flutter/material.dart';
import 'package:for_you/screens/firebase_auth/login_screen.dart';
import 'package:for_you/screens/firebase_auth/register_screen.dart';

import '../ui_components/round_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("assets/images/blog.png"),
                height: 200,
              ),
              const SizedBox(
                height: 70,
              ),
              RoundButton(title: "Login", onPress: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignIn()));
              }),
              const SizedBox(
                height: 50,
              ),
              RoundButton(
                  title: "Register",
                  onPress: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
