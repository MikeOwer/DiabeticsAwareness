import 'dart:ui';
import 'package:flutter/material.dart';

class ProyectColors {
  late MaterialColor primaryMaterialColor;
  Color primaryColor = Color(0xFF002556);
  Color backgroundColor = Color(0xFFFFFFFF);

  ProyectColors() {
    this.primaryMaterialColor = getMaterialColor(Color(0xFF002556));
  }

  //Método para crear MAterialColor con base en el color que quieras, te general el map para las tonalidades.
  MaterialColor getMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
