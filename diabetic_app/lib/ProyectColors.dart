import 'package:flutter/material.dart';

class ProyectColors {
  //Clase para crear los colores que se utilizarán en la aplicación.
  late MaterialColor primaryMaterialColor;
  Color primaryColor = const Color(0xFF002556); //Color principal
  Color backgroundColor = const Color(0xFFC8E1F9); //Color del fondo
  Color secundaryBackColor = const Color(0xFFFFFFFF);

  ProyectColors() {
    primaryMaterialColor = getMaterialColor(const Color(0xFF002556));
  }

  //Método para crear MaterialColor con base en el color que quieras, te general el map para las tonalidades.
  MaterialColor getMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}
