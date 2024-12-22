import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle appStyle(double size, Color color, FontWeight fontWeight) {
  return GoogleFonts.poppins(
      fontSize: size, color: color, fontWeight: fontWeight);
}

TextStyle appstyleWithHt(double size, Color color , FontWeight fw, double ht) {
  return GoogleFonts.poppins(fontSize: size, color: color, fontWeight: fw, height: ht);
}
