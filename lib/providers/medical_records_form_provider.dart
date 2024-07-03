import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/utilities/general_functions.dart';

import '../locator.dart';
import '../models/models.dart';
import '../shared/preferences.dart';

import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

class MedicalRecordsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool result = false;
  String _apiUrl = Preferences.apiServer;
  String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/medical-records';
  String jwtToken = '';

  ServerResponse? serverResponse;
  MedicalRecordsResponse? medicalRecordsResponse;

  final NavigationService _navigationService = locator<NavigationService>();
  final storage = const FlutterSecureStorage();

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> saveMedicalRecords(MedicalRecordsRequest medicalRecords) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API medical records');
    _endPoint = '/api/v1/medical-records';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url medical records: $url');
    try {
      isLoading = true;
      result = false;

      final response = await http
          .post(url, headers: headers, body: medicalRecords.toJson())
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Medical Records: ${response.body}');
          medicalRecordsResponse =
              MedicalRecordsResponse.fromJson(response.body);

          User apiUser = User.fromJson(Preferences.apiUser);
          apiUser.medicalHistory = medicalRecordsResponse?.medicalHistory;

          final Map<String, dynamic> decodedResp = json.decode(response.body);
          Preferences.apiUser = apiUser.toJson();

          Notifications.showSnackBar(
              medicalRecordsResponse?.message ?? 'Todo bien!!');
          notifyListeners();
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
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoading = false;
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

class MedRecordsForm1Provider extends ChangeNotifier {
  GlobalKey<FormState> form1Key = GlobalKey<FormState>();

  String? gender;
  String birthday = '';
  String ocupation = '';
  String maritalStatus = '';
  String address = '';
  String phone = '';

  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return form1Key.currentState?.validate() ?? false;
  }
}

class MedRecordsForm2Provider extends ChangeNotifier {
  GlobalKey<FormState> form2Key = GlobalKey<FormState>();

  String? state;
  String? city;
  String postalCode = '';
  String contactSchedule = '';

  String? contactName;
  String? contactPhone;
  String? relationship;

  bool _isLoading = false;

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return form2Key.currentState?.validate() ?? false;
  }
}

class MedRecordsForm3Provider extends ChangeNotifier {
  GlobalKey<FormState> form3Key = GlobalKey<FormState>();

  bool _isLoading = false;

  String? medicamentosTextarea;
  String? alergiasTextarea;
  bool _tomaMedicamentos = false;
  bool _alergias = false;
  bool _cardiopatias = false;
  bool _coagulopatias = false;
  bool _alteracionPresionArterial = false;
  bool _embarazo = false;
  bool _diabetes = false;
  bool _hepatitis = false;
  bool _fiebreReumatica = false;
  bool _enfermedadesRenales = false;
  bool _inmunosupresion = false;
  bool _trastornosRespiratorios = false;
  bool _trastornosGastricos = false;
  bool _epilepsia = false;
  bool _bebeAlcohol = false;
  bool _fuma = false;

  bool get alergias => _alergias;

  set alergias(bool value) {
    _alergias = value;
    notifyListeners();
  }

  bool get cardiopatias => _cardiopatias;

  set cardiopatias(bool value) {
    _cardiopatias = value;
    notifyListeners();
  }

  bool get coagulopatias => _coagulopatias;

  set coagulopatias(bool value) {
    _coagulopatias = value;
    notifyListeners();
  }

  bool get alteracionPresionArterial => _alteracionPresionArterial;

  set alteracionPresionArterial(bool value) {
    _alteracionPresionArterial = value;
    notifyListeners();
  }

  bool get embarazo => _embarazo;

  set embarazo(bool value) {
    _embarazo = value;
    notifyListeners();
  }

  bool get diabetes => _diabetes;

  set diabetes(bool value) {
    _diabetes = value;
    notifyListeners();
  }

  bool get hepatitis => _hepatitis;

  set hepatitis(bool value) {
    _hepatitis = value;
    notifyListeners();
  }

  bool get fiebreReumatica => _fiebreReumatica;

  set fiebreReumatica(bool value) {
    _fiebreReumatica = value;
    notifyListeners();
  }

  bool get enfermedadesRenales => _enfermedadesRenales;

  set enfermedadesRenales(bool value) {
    _enfermedadesRenales = value;
    notifyListeners();
  }

  bool get inmunosupresion => _inmunosupresion;

  set inmunosupresion(bool value) {
    _inmunosupresion = value;
    notifyListeners();
  }

  bool get trastornosRespiratorios => _trastornosRespiratorios;

  set trastornosRespiratorios(bool value) {
    _trastornosRespiratorios = value;
    notifyListeners();
  }

  bool get trastornosGastricos => _trastornosGastricos;

  set trastornosGastricos(bool value) {
    _trastornosGastricos = value;
    notifyListeners();
  }

  bool get epilepsia => _epilepsia;

  set epilepsia(bool value) {
    _epilepsia = value;
    notifyListeners();
  }

  bool get bebeAlcohol => _bebeAlcohol;

  set bebeAlcohol(bool value) {
    _bebeAlcohol = value;
    notifyListeners();
  }

  bool get fuma => _fuma;

  set fuma(bool value) {
    _fuma = value;
    notifyListeners();
  }

  bool get tomaMedicamentos => _tomaMedicamentos;

  set tomaMedicamentos(bool value) {
    _tomaMedicamentos = value;
    notifyListeners();
  }

  get isLoading => _isLoading;
  set isLoading(value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    //print('$email - $password');
    return form3Key.currentState?.validate() ?? false;
  }
}
