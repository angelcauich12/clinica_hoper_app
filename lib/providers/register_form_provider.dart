import 'package:flutter/material.dart';

class RegisterFormProvider extends ChangeNotifier {
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  String name = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String password = '';
  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return registerFormKey.currentState?.validate() ?? false;
  }
}
