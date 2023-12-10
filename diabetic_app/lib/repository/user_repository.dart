import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../my_classes/model/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection("users").add(user.toJson())
    .then((value) => print("Usuario agregado"))
    .catchError((error) => print("Error al agregar al usuario: $error"));
  }

  Future<UserModel> getUser(User? user) async {
    if(user != null){
      QuerySnapshot querySnapshot = await _firestore.collection("users")
          .where('email', isEqualTo: '${user.email}')
          .get();
      UserModel userModel = UserModel.empty();
      for (var doc in querySnapshot.docs) {
        userModel.setId(doc.id);
        userModel.setNames(doc.get('names'));
        userModel.setLastNameF(doc.get('lastNameF'));
        userModel.setLastNameM(doc.get('lastNameM'));
        userModel.setEmail(doc.get('email'));
        userModel.setPhoneNo(doc.get('phoneNo'));
        userModel.setGender(doc.get('gender'));
        userModel.setPostalCode(doc.get('postalCode'));
        userModel.setBirthday(doc.get('birthday').toDate());

      }
      return userModel;
    } else {
      throw Exception('Usuario null');
    }
  }

  void updateUser(UserModel userModel) {
    _firestore.collection('users').doc(userModel.getId()).update(userModel.toJson());
  }

}