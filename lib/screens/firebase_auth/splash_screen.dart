import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:for_you/screens/firebase_db_storage/home_screen.dart';
import 'package:for_you/screens/start_screen.dart';
import 'package:for_you/ui_components/my_colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = auth.currentUser;
    if(user!=null){
      Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home())));
    }
    else{
      Timer(Duration(seconds: 3), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: myColors.light2,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/images/blog.png"),
             height: 200,
             // height: MediaQuery.of(context).size.height * .3,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: SpinKitChasingDots(
                size: 30,
                color: myColors.dark2,
              )
              /* Text("Blog App",
                style: Theme.of(context).textTheme.displayMedium,
                //style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold, fontSize: 25)
                ),*/
            )
          ],

        ),
      ),
    );
  }
}
