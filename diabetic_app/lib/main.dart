import 'package:diabetic_app/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'my_classes/notifications.dart';
import 'package:diabetic_app/ProyectColors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Notifications().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat-SemiBold.ttf',
        primarySwatch: ProyectColors()
            .primaryMaterialColor, //Se utiliza el color creado para la aplicación
        scaffoldBackgroundColor: ProyectColors().backgroundColor,
      ),
      home: const WidgetTree(),
    );
  }
}
