import 'package:flutter/material.dart';

class SocialMediaFormProvider extends ChangeNotifier {
  GlobalKey<FormState> socialMediaFormKey = GlobalKey<FormState>();

  String name = '';
  String image = '';
  String email = '';
  String phone = '';
  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return socialMediaFormKey.currentState?.validate() ?? false;
  }
}
