import 'package:flutter/material.dart';

class AppointmentFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int specialty = 1;
  String gender = 'F';
  String startDate = '';
  TimeOfDay startTime = const TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = const TimeOfDay(hour: 00, minute: 00);
  String email = '';
  String password = '';
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
