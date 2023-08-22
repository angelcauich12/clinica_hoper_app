import 'package:flutter/material.dart';

class MedicalRecordsFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String gender = 'F';
  String email = '';
  String password = '';
  String birthday = '';
  String ocupation = '';
  String maritalStatus = '';
  String contactName = '';
  String contactPhone = '';
  String phone = '';
  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
}
