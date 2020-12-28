class ValidateForm {
  //Validating Transaction Form
  //Validating amount text form field
  static String validateAmount(String value) {
    if (value.isEmpty) {
      return 'Amount Required';
    }
    if (value.toString() == '0') {
      return 'Valid Amount is required';
    }
    if (value.contains(RegExp(r'^[0-9]+$'))) {
      return null;
    }
    return 'Only numeric value is allowed';
  }

  //Validating description text form field
  static String validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description Required';
    }
    if (value.length > 50) {
      return 'Description not exceed then 50 characters';
    }
    return null;
  }

  //Validating Registration Form
//Validating email field
  static String validateRegEmail(String value) {
    if (value.isEmpty) {
      return 'Email Address Required';
    }
    if (value.contains(RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
      return null;
    }
    return 'Please Enter Valid Email Address';
  }

  //Validating password field
  static String validateRegPassword(String value) {
    if (value.isEmpty) {
      return 'Password Required';
    }
    if (value.contains(
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'
            // should contain at least one upper case
            // should contain at least one lower case
            // should contain at least one digit
            // should contain at least one Special character
            ))) {
      return null;
    }
    return 'Please Enter a Strong Password';
  }
}
