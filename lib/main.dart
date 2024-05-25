import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:for_you/screens/firebase_auth/splash_screen.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBMSIrUVQ7scGBbZC3wrDHxPX34KVzGN1w',
      authDomain: 'YOUR_AUTH_DOMAIN',
      projectId: 'fir-task2-bd6d1',
      storageBucket: 'fir-task2-bd6d1.appspot.com',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      appId: '1:759093365905:android:cd860abbf004abe1afc330',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  // #0AB27F
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: myColors.medium),
        useMaterial3: true,
        textTheme: TextTheme(
          // Create your own customize theme
          displayMedium: GoogleFonts.lato(color: Colors.grey.shade700, fontSize: 18, fontWeight: FontWeight.bold ),
          displayLarge: GoogleFonts.lato(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          displaySmall: GoogleFonts.lato(color:Colors.grey.shade800, fontSize: 16),
        ),
        // Color
      ),
      home: const Splash());
  }
}


