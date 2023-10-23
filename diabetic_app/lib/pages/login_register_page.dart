
import 'package:diabetic_app/controllers/login_controller.dart';
import 'package:diabetic_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../my_classes/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool passwordVisible = true;
  
  LoginController loginController = LoginController();
  Map _userObj = {};

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
      );
    } on FirebaseAuthException catch (e) {
      if(loginController.userNotFound(e.message)){
        setState(() {
          errorMessage = "La cuenta de usuario no está registrada.";
        });
      } else if(loginController.invalidData(e.message)) {
        setState(() {
          errorMessage = "El usuario o contraseña son incorrectos. Intente de nuevo.";
        });
      } else if(loginController.emptyFields(e.message)) {
        setState(() {
          errorMessage = "Hay uno o más campos vacíos.";
        });
      } else {
        setState(() {
          errorMessage = e.message;
        });
      }

    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      setState(() {
        isLogin = !isLogin;
      });
    } on FirebaseAuthException catch (e) {
      if(loginController.emptyFields(e.message)){
        setState(() {
          errorMessage = "Hay uno o más campos vacíos.";
        });
      } else if(loginController.emailBadlyFormatted(e.message)){
        setState(() {
          errorMessage = "El formato del correo no es correcto. Escriba un correo válido";
        });
      } else if(loginController.passwordBadlyFormatted(e.message)){
        setState(() {
          errorMessage = "La contraseña debe contener al menos 6 caracteres.";
        });
      } else {
        setState(() {
          errorMessage = e.message;
        });
      }
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      await Auth().signInWithFacebook();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage())
      );
    } on FirebaseAuthException catch (e,s) {
      print('Error $e, Stacktrace:$s');
    }
  }
  Future<void> signInWithGoogle() async {
    try{
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch (e,s) {
      print('Error $e, Stacktrace: $s');
    }
  }

  Widget _title() {
    return const Text('Diabetic App',
      style: TextStyle(
        fontSize: 26
      )
      ,);
  }

  Widget _entryField(String title, TextEditingController controller) {
    Widget object;
    if(title == 'Correo') {
      object = TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          hintText: 'CorreoEjemplo@correo.com',
          alignLabelWithHint: false,
          filled: true
        ),
      );
    } else {
      object = TextField(
        controller: controller,
        obscureText: passwordVisible,
        decoration: InputDecoration(
          labelText: title,
          hintText: 'Contraseña',
          helperText: isLogin? '':'Mínimo 6 caracteres',
          helperStyle: TextStyle(color: Colors.blueGrey),
          suffixIcon: IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          ),
          alignLabelWithHint: false,
          filled: true,
        ),
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
      );
    }
    return object;
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage', textAlign: TextAlign.center,);
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed:
        isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
        child: Text(isLogin ? 'Iniciar Sesión' : 'Registrarse'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Regístrese' : 'Inicie Sesión'),
    );
  }

  Widget _loginWithFacebookButton(){
    return ElevatedButton(
        onPressed: signInWithFacebook,
        child: Text('Inicia Sesión con Facebook'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
    );
  }

  Widget _loginWithGoogleButton(){
    return ElevatedButton(
        onPressed: signInWithGoogle,
        child: Text('Inicia Sesión con Google'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _entryField('Correo', _controllerEmail),
              _entryField('Contraseña', _controllerPassword),
              _errorMessage(),
              _submitButton(),
              _loginOrRegisterButton(),
              const SizedBox(height: 80,),
              _loginWithFacebookButton(),
              //_loginWithGoogleButton(),
            ],
          ),
        ),
      )
    );
  }
}