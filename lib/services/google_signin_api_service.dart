import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:hope_app/ui/notifications.dart';

class GoogleSignInAPiService extends ChangeNotifier {
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/google-sign-in';
  ServerResponse? serverResponse;
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

  final storage = const FlutterSecureStorage();

  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> loginGoogle() => _googleSignIn.signIn();
  static Future<GoogleSignInAccount?> logoutGoogle() =>
      _googleSignIn.disconnect();

  Future<bool?> loginOrRegisterUser(
      String displayName, String email, String photoUrl, String? phone) async {
    _endPoint = '/api/google-sign-in';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final AuthDataRequest authData = AuthDataRequest(
      name: displayName,
      email: email,
      image: photoUrl,
      phone: phone,
      isMerge: isMerge,
    );

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      print('Url: $url');
      final response = await http
          .post(url, headers: headers, body: authData.toJson())
          .timeout(const Duration(seconds: 30));

      print('Response*************: ${response.body}');
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
          Preferences.expirationDate =
              Preferences.timestampToDate(decodedResp['exp']);
          notifyListeners();
          break;
        case 400:
          isLoading = false;
          result = false;
          print('400: ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBarWithButton(
            serverResponse?.message ?? 'Error 400!',
            () {
              btnLabel = 'Reemplazar y Registrar';
              isMerge = true;
              notifyListeners();
            },
            'Reemplazar',
          );

          break;
        case 401:
          print('401: ${response.body}');
          if (!response.body.contains('code')) {
            print('logout');
            break;
          }
          serverResponse = ServerResponse.fromJson(response.body);
          isLoading = false;
          result = false;
          logout();
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          notifyListeners();
          break;
        case 404:
          isLoading = false;
          result = false;
          // serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error Desconocido.');
          // print(serverResponse);
          print('404: ${response.body}');
          notifyListeners();
          break;
        case 406:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          // Notifications.showSnackBar(
          //     serverResponse?.message ?? 'Error Desconocido.');
          print('406: ${response.body}');
          logoutGoogle();
          btnLabel = 'Registrarme';
          _navigationService.navigateNamedTo(
              PhoneRequiredScreen.routeName, authData);
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
