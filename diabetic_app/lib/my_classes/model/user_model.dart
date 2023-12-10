class UserModel {
  String id = '';
  String names = '';
  String lastNameF = '';
  String lastNameM = '';
  String? email;
  String phoneNo = '';
  DateTime birthday = DateTime.now();
  String gender = '';
  String postalCode = '';

  UserModel({required this.email});

  UserModel.empty();

  toJson() {
    return {
      "names": names,
      "lastNameF": lastNameF,
      "lastNameM": lastNameM,
      "email": email,
      "phoneNo": phoneNo,
      "birthday": birthday,
      "gender": gender,
      "postalCode": postalCode
    };
  }

  String getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }

  String getNames() {
    return names;
  }

  void setNames(String names) {
    this.names = names;
  }

  String getLastNameF() {
    return lastNameF;
  }

  void setLastNameF(String lastName) {
    lastNameF = lastName;
  }

  String getLasNameM() {
    return lastNameM;
  }

  void setLastNameM(String lastName) {
    lastNameM = lastName;
  }

  String getEmail() {
    return email ?? '';
  }

  void setEmail(String? email) {
    this.email = email;
  }

  String getPhoneNo() {
    return phoneNo;
  }

  void setPhoneNo(String phoneNo) {
    this.phoneNo = phoneNo;
  }

  DateTime getBirthday() {
    return birthday;
  }

  void setBirthday(DateTime birthday) {
    this.birthday = birthday;
  }

  String getBirthdayString() {
    String dateString = '${birthday.day}/${birthday.month}/${birthday.year}';
    return dateString;
  }

  String getGender() {
    return gender;
  }

  void setGender(String gender) {
    if(gender == 'H' || gender == 'M'|| gender == 'Otro') {
      this.gender = gender;
    }
  }

  String getPostalCode() {
    return postalCode;
  }

  void setPostalCode(String postalCode) {
    if(postalCode.length != 10) {
      this.postalCode = '97000';
    } else {
      this.postalCode = postalCode;
    }
  }

}