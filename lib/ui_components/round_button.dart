import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:for_you/ui_components/my_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundButton extends StatelessWidget {

  final String title;
  final VoidCallback onPress;

  RoundButton({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Material(
       borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        onPressed: onPress,
        color: myColors.dark,
        height: 50,
        minWidth: double.infinity,
        child: Text(title,
        style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
