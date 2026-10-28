import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:http/http.dart' as http;

class CreateUserFormProvider extends ChangeNotifier {
  GlobalKey<FormState> createUserFormKey = GlobalKey<FormState>();

  String name = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;
  bool _result = false;
  late User user;
  String _apiUrl = Preferences.apiServer;
  String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/appointments';
  String jwtToken = '';
  ServerResponse? serverResponse;
  CreateUserResponse? createUserResponse;

  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get result => _result;
  set result(bool value) {
    _result = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return createUserFormKey.currentState?.validate() ?? false;
  }

  Future<bool> registerUser() async {
    _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API Search');
    _endPoint = '/api/v1/users';
    isLoading = false;
    result = false;

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'name': name,
      'last_name': lastName,
      'phone': phone,
    };
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url API Search: $url');

    try {
      isLoading = true;

      final response = await http
          .post(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoading = false;
          result = true;
          print('200: ${response.body}');
          createUserResponse = CreateUserResponse.fromJson(response.body);
          user = createUserResponse!.user!;
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(serverResponse?.message ?? 'Error Desconocido.'));
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoading = false;
          result = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoading = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoading = false;
      result = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateNamedTo(LoginScreen.routeName, null);
  }
}
