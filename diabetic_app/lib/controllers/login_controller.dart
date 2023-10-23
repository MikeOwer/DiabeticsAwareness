class LoginController {

   bool userNotFound(String? errorMessage) {
    String? error = 'There is no user record corresponding to this identifier.';
    if(errorMessage!.contains(error) ){
      return true;
    }else {
      return false;
    }
   }

   bool emptyFields(String? errorMessage) {
     String? error = 'Given String is empty or null';
     if(errorMessage!.contains(error)) {
       return true;
     } else {
       return false;
     }
   }

   bool emailBadlyFormatted(String? errorMessage) {
     String? error = 'The email address is badly formatted.';
     if(errorMessage!.contains(error)){
       return true;
     } else {
       return false;
     }
   }

   bool passwordBadlyFormatted(String? errorMessage) {
     String? error = 'Password should be at least 6 characters';
     if(errorMessage!.contains(error)){
       return true;
     } else {
       return false;
     }
   }

   bool invalidData(String? errorMessage) {
     String? error = 'The password is invalid ';
     if(errorMessage!.contains(error)) {
       return true;
     } else {
       return false;
     }
   }

}