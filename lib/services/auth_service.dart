import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class AuthService extends ChangeNotifier {
   String _apiUrl = Preferences.apiServer;
   String _proyectName = Preferences.projectName;
  ServerResponse? serverResponse;
  final storage = const FlutterSecureStorage();
  bool result = false;
  bool _isLoading = false;
  bool _isMerge = false;

  bool get isMerge => _isMerge;

  set isMerge(bool value) {
    _isMerge = value;
    notifyListeners();
  }

  String _btnLabel = 'Registrarme';

  String get btnLabel => _btnLabel;

  set btnLabel(String value) {
    _btnLabel = value;
  }

  final NavigationService _navigationService = locator<NavigationService>();

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> loginUser(String email, String password) async {
    //se lee de nuevo los valores de las preferencias por si hubo algún cambio
    _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;
    
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName/api/login', authData);

    try {
      print('Url login: $url');
      final response = await http
          .post(url, body: json.encode(authData))
          .timeout(const Duration(seconds: 10));
      final Map<String, dynamic> decodedResp = json.decode(response.body);

      if (decodedResp['code'] == 200) {
        //guardar el token y la info del usuario
        print("token ${decodedResp['jwt']}");
        await storage.write(key: 'jwtToken', value: decodedResp['jwt']);
        Preferences.apiUser = jsonEncode(decodedResp['user']);
        Preferences.expirationDate = Preferences.timestampToDate(decodedResp['exp']);
        return true.toString();
      } else {
        return decodedResp['message'] ?? "Servidor no disponible.";
      }
    } catch (e) {
      print(e.toString());
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar('Tiempo de espera agotado');
      }
    }
    return null;

    //print(decodedResp);
  }

  Future<bool?> registerUser(String name,String lastName,String email,String phone,String password,) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    final Map<String, dynamic> registerData = {
      'name': name,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'password': password
    };

    final url = Uri.http(_apiUrl, '$_proyectName/api/register', registerData);

    try {
      final response = await http
          .post(url, body: json.encode(registerData))
          .timeout(const Duration(seconds: 30));
      final Map<String, dynamic> decodedResp = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: ${response.body}');
          //guardar el token y la info del usuario
          print("token ${decodedResp['jwt']}");
          await storage.write(key: 'jwtToken', value: decodedResp['jwt']);
          Preferences.apiUser = jsonEncode(decodedResp['user']);
          Preferences.expirationDate = Preferences.timestampToDate(decodedResp['exp']);
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          result = false;
          print('400: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBarWithButton(
          //   serverResponse?.message ?? 'Error 400!',
          //   () {
          //     btnLabel = 'Reemplazar y Registrar';
          //     isMerge = true;
          //     notifyListeners();
          //   },
          //   'Reemplazar',
          // );

          break;
        case 401:
          print('401: ${response.body}');
          if (!response.body.contains('code')) {
            print('logout');
            break;
          }
          isLoading = false;
          result = false;
          logout();
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          notifyListeners();
          break;
        case 404:
          isLoading = false;
          result = false;
          print('404: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ?? 'Error 404.');
          notifyListeners();
          break;
        case 422:
          isLoading = false;
          result = false;
          ValidatorResponse validatorResponse =
              ValidatorResponse.fromJson(response.body);
          final Map<String, dynamic> errors = validatorResponse.errors.toMap();
          String messages = '${validatorResponse.message}\n';

          Iterable<dynamic> values = errors.values;
          for (final error in values) {
            Iterable<dynamic> errorStrings = error;
            for (final errorString in errorStrings) {
              print('error: $errorString');
              messages = '${messages + errorString}\n';
            }
          }

          Notifications.showSnackBar(messages);
          notifyListeners();
          // print(serverResponse);
          print('422: ${response.body}');
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
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      // Notifications.showSnackBar(e.toString() ?? 'Error 500.');
      notifyListeners();
    }
    return result;
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    return;
  }

  Future<String> getToken() async {
    final DateTime expirationDate = DateTime.parse(Preferences.expirationDate);
    final DateTime now = DateTime.now();
    if (now.compareTo(expirationDate) > 0) {
      Preferences.apiUser = '';
      return '';
    }
    return await storage.read(key: 'jwtToken') ?? '';
  }
}
