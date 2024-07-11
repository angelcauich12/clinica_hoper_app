
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/services/services.dart';

import '../models/models.dart';
import '../screens/screens.dart';
import '../shared/preferences.dart';
import '../ui/notifications.dart';
import '../utilities/general_functions.dart';
import 'package:http/http.dart' as http;


class ManageScheduleProvider  extends ChangeNotifier{

  final storage = const FlutterSecureStorage();
  final NavigationService _navigationService = locator<NavigationService>();
  String _apiUrl = Preferences.apiServer;
  String _proyectName = Preferences.projectName;
  String _endPoint = '';
  String jwtToken = '';
  ServerResponse? serverResponse;
  bool result = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _doctorSelected;
  NonWorkingDaysResponse? nonWorkingDaysResponse;
  String? get doctorSelected => _doctorSelected;
  List<NonWorkingDay> nonWorkingDays = [];
  String? initialDate;
  String? endDate;
  String? initialTime;
  String? endTime;

  set doctorSelected(String? value) {
    _doctorSelected = value;
    print('set Doctor selected: $doctorSelected');
    notifyListeners();
  }
   set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


  ManageScheduleProvider () {
    print('Manage Schedule provider inicializado!!');
  }


  Future<bool> getNonWorkingDays() async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('petición Get non-working days');
    _endPoint = '/api/v1/schedule/non-working-days';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

   final Map<String, dynamic> queryParameters = {
      'id_doctor': doctorSelected,
    };
    
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url non working days: $url');

    try {
      isLoading = true;
      result = false;

      final response = await http.post(url, headers: headers,body: json.encode(queryParameters)).timeout(const Duration(seconds: 30));
      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Get non working days ${response.body}');
          nonWorkingDaysResponse = NonWorkingDaysResponse.fromJson(response.body);
          nonWorkingDays = nonWorkingDaysResponse!.nonWorkingDays;
          notifyListeners();
          break;
        case 401:
          isLoading = false;
          result = false;
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          notifyListeners();
          print('404 ${serverResponse?.message}');
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
      Notifications.showSnackBar('$e');
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }


  Future<bool> createNonWorkingDay() async{
    _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('petición Get non-working days');
    _endPoint = '/api/v1/schedule/store-horario-exclusion';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept':       'application/json',
      'Authorization':'Bearer $jwtToken'
    };

   final Map<String, dynamic> queryParameters = {
    'hora_inicial_exclusion': initialTime,
    'hora_final_exclusion':   endTime,
    'fecha_inicio_exclusion': initialDate,
    'fecha_fin_exclusion':    endDate 
    };

    print('queryParameters: $queryParameters');
    
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url create working days: $url');

    try {
      isLoading = true;
      result = false;

      final response = await http.post(url, headers: headers,body: json.encode(queryParameters)).timeout(const Duration(seconds: 30));
      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Get non working days ${response.body}');
          final nonWorkingResponse = CreateNonWorkingResponse.fromJson(response.body);
          nonWorkingDays.add(nonWorkingResponse.nonWorkingDay);
          Notifications.showSnackBar(nonWorkingResponse.message);
          notifyListeners();
          break;
        case 401:
          isLoading = false;
          result = false;
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoading = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          notifyListeners();
          print('404 ${serverResponse?.message}');
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
          print('response: ${response.body}');
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
      Notifications.showSnackBar('$e');
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