import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> devKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;
  String? devCode;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

  bool isValidFormDev(){
    return devKey.currentState?.validate() ?? false;
  }
}
