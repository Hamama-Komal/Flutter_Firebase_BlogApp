import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:for_you/screens/firebase_auth/forget_password_screen.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../ui_components/round_button.dart';
import '../firebase_db_storage/home_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = "", password = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Login", style: Theme.of(context).textTheme.displayLarge),
            backgroundColor: myColors.dark,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.displayLarge,
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
                            labelText: "Email Address",
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: "Password",
                              labelText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: myColors.medium,
                              ),
                            ),
                            onChanged: (String value) {
                              password = value;
                            },
                            validator: (value) {
                              return value!.isEmpty ? "Set Password" : null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Align(
                              alignment: FractionalOffset.centerRight,
                                child: Text("Forget password?")),
                          ),
                        ),
                        const SizedBox(height: 40,),
                        RoundButton(
                          title: 'Login',
                          onPress: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              try {
                                // Wait for createUserWithEmailAndPassword to complete
                                await auth.signInWithEmailAndPassword(
                                  email: email.toString().trim(),
                                  password: password.toString().trim(),
                                );

                                // User registration successful
                                toastMessages("User Login Successfully");


                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()), // Replace `NextScreen` with your target screen widget
                                      (Route<dynamic> route) => false, // This predicate removes all the previous routes
                                );



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
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.black,
        fontSize: 16.0);
  }

}
