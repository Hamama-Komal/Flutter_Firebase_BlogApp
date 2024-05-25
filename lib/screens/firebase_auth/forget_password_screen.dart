import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../ui_components/round_button.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Forget Password", style: Theme.of(context).textTheme.displayLarge),
            backgroundColor: myColors.dark,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Enter your registered email address",
                  style: Theme.of(context).textTheme.displaySmall,
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 25.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email Address",
                            labelText: "Email",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0))),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: myColors.medium,
                            ),
                          ),
                          onChanged: (String value) {
                            email = value;
                          },
                          validator: (value) {
                            return value!.isEmpty
                                ? "Enter Email Address"
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        RoundButton(
                          title: 'Recover Password',
                          onPress: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              try {
                                auth
                                    .sendPasswordResetEmail(
                                        email: emailController.text.toString())
                                    .then((value) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessages(
                                      "Please check your email, a reset link has been sent to you via email");
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMessages(error.toString());
                                });
                              } catch (e) {
                                // Registration failed, handle the error
                                toastMessages(e.toString());
                              }

                              // After handling registration, set showSpinner to false
                              setState(() {
                                showSpinner = false;
                              });
                            } else {
                              // Form validation failed, set showSpinner to false
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void toastMessages(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
