import 'package:diabetic_app/pages/home_page.dart';
import 'package:diabetic_app/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diabetic_app/my_classes/auth.dart';

import '../my_classes/model/user_model.dart';
import '../my_widgets/menu_button_widget.dart';

class ConfigPage extends StatefulWidget{

  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final User? user = Auth().currentUser;
  final UserRepository userRepository = UserRepository();
  UserModel userModel = UserModel.empty();
  bool editable = false;
  String fecha = '';

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPController = TextEditingController();
  final TextEditingController _apellidoMController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void initState(){
    super.initState();
    obtenerUserModel();

  }

  void obtenerUserModel() async {
    Future<UserModel> futureModel = userRepository.getUser(user);
    UserModel model = await futureModel;
    setState(() {
      this.userModel = model;
      this.fecha = userModel.getBirthdayString();
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.push(context, 
        MaterialPageRoute(builder: (context) => HomePage())
    );
  }

  void editButtonPressed() {
    setState(() {
      editable = true;
    });
  }
  void saveButtonPressed() {
    setState(() {
      editable = false;
    });
    //Logica de guardado
    userModel.setNames(_nombreController.text);
    userModel.setLastNameF(_apellidoPController.text);
    userModel.setLastNameM(_apellidoMController.text);
    userModel.setPhoneNo(_telefonoController.text);
    //La fecha se guarda en el método _selectDate();
    userModel.setGender(_genderController.text);
    userModel.setPostalCode(_postalController.text);
    userRepository.updateUser(userModel);
    clearControllers();
  }

  void cancelButtonPressed() {
    setState(() {
      editable = false;
      fecha = userModel.getBirthdayString();
      clearControllers();
    });
  }

  void clearControllers() {
    _nombreController.clear();
    _apellidoPController.clear();
    _apellidoMController.clear();
    _telefonoController.clear();
    _emailController.clear();
    _genderController.clear();
    _dateController.clear();
    _postalController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1923),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        userModel.setBirthday(picked);
        fecha = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  Widget _title(String title) {
    return Text(title.isEmpty? 'Titulo': title ,
      style: TextStyle(
        fontSize: 26
      ),
    );
  }

  Widget _textFTitle(String title) {
    return Text(title.isEmpty? 'Titulo': title ,
      style: TextStyle(
          fontSize: 22
      ),
    );
  }

  Widget _editButton() {
    return ElevatedButton(
        onPressed: editButtonPressed,
        child: Text(
            'Editar',
            style: TextStyle(
                fontSize: 24
            )
        ),
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
        onPressed: saveButtonPressed,
        child: Text(
            'Guardar',
            style: TextStyle(
                fontSize: 24
            )
        )
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
        onPressed: cancelButtonPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.redAccent,
        ),
      child: Text(
          'Cancelar',
          style: TextStyle(
            fontSize: 24
          ),
      ),
    );
  }
  Widget _selectDateButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _selectDate(context),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey,
        ),
        child: Text(
          'Elegir Fecha',
          style: TextStyle(
            fontSize: 24
          ),
        )
    );
  }

  Widget _entryField(String title, String hint, TextEditingController controller, bool editable) {
    return TextField(
      style: TextStyle(fontSize: 20),
      controller: controller,
      decoration: InputDecoration(
          labelText: title,
          hintText: hint,
          alignLabelWithHint: false,
          enabled: editable,
          filled: true
      ),
    );
  }



  Widget _infoArea() {
   return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            _textFTitle("Nombre"),
            _entryField(userModel.getNames(), 'Nombre', _nombreController, editable),
            SizedBox(height: 5,),
            _textFTitle("Apellido Paterno"),
            _entryField(userModel.getLastNameF(), 'Apellido Paterno', _apellidoPController, editable),
            SizedBox(height: 5,),
            _textFTitle("Apellido Materno"),
            _entryField(userModel.getLasNameM(), 'Apellido Materno',_apellidoMController, editable),
            SizedBox(height: 5,),
            _textFTitle("Teléfono Celular"),
            _entryField(userModel.getPhoneNo(),'9990000000', _telefonoController, editable),
            SizedBox(height: 5,),
            _textFTitle("Correo Electrónico"),
            _entryField(userModel.getEmail(), 'ejemplo@correo.com',_emailController, false),
            SizedBox(height: 5,),
            _textFTitle("Género"),
            _entryField(userModel.getGender(), 'H/M/Otro',_genderController, editable),
            SizedBox(height: 5,),
            _textFTitle("Fecha de Nacimiento"),
            _entryField(fecha, 'dd/MM/YYYY',_dateController, editable),
            editable ? _selectDateButton(context) : SizedBox(),
            SizedBox(height: 5,),
            _textFTitle("Código Postal"),
            _entryField(userModel.getPostalCode(), '97000',_postalController, editable),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                editable? _cancelButton() : SizedBox(),
                SizedBox(width: 5,),
                editable? _saveButton() : _editButton()
              ],
            )
          ],
        ),
      );
  }

  void returnToMenu(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title("Configuración"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => returnToMenu(context),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: MenuButtonWidget(),
          )
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white60,
          child: Padding(
            padding: EdgeInsets.only(top: 15, left: 20, right: 15),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Tu perfil"),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  _infoArea(),
                  SizedBox(height: 20,),
                  _title("Inicio de Sesión"),
                  Container(
                    height: 1,
                    color: Colors.black,
                  ),
                  TextButton(onPressed: signOut,
                    child: Text("Cerrar sesión",
                      style:TextStyle(
                          fontSize: 24,
                          color: Colors.grey
                      ),),
                  ),
                ],
              ),
            ),
        )
      ),
    );
  }
}