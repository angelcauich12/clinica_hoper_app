import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class AppointmentProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> specialtyDropdownKey = GlobalKey<FormState>();
  GlobalKey<FormState> intervalsDropdownKey = GlobalKey<FormState>();
  GlobalKey<FormState> doctorDropdownKey = GlobalKey<FormState>();

  String gender = 'F';
  String? startDate;
  // TimeOfDay startTime = const TimeOfDay(hour: 00, minute: 00);
  String? startTime;
  TimeOfDay endTime = const TimeOfDay(hour: 00, minute: 00);
  String description = '';
  String email = '';
  String password = '';
  String ocupation = '';
  String maritalStatus = '';
  String contactName = '';
  String contactPhone = '';
  String phone = '';
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/appointments';
  String jwtToken = '';
  Appointment? appointment;
  List<Appointment> appointments = [];
  List<Appointment> reservadasList = [];
  List<Appointment> confirmadasList = [];
  List<Appointment> atendidasYCanceladasList = [];
  List<Specialty>? specialties = [];
  String? specialtySelected;
  List<Doctor>? doctors = [];
  String? _doctorSelected;
  List<String>? morningIntervals = [];
  List<String>? afternoonIntervals;
  ScheduleIntervalsResponse? scheduleIntervalsResponse;

  late MyAppointments appointmentResponse;
  ServerResponse? serverResponse;
  bool result = false;
  bool _isLoading = false;

  final NavigationService _navigationService = locator<NavigationService>();

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? get doctorSelected => _doctorSelected;

  set doctorSelected(String? value) {
    _doctorSelected = value;
    notifyListeners();
  }

  final storage = const FlutterSecureStorage();

  AppointmentProvider() {
    print('Appointment Provider inicializado!!');
  }

  bool isValidForm() {
    //print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

  Future<bool> getAppointments() async {
    print('Peticion API');
    _endPoint = '/api/v1/appointments';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Api Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');
    print('Url: $url');
    try {
      isLoading = true;
      result = false;
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 30),
          );

      switch (response.statusCode) {
        case 200:
          appointmentResponse = MyAppointments.fromJson(response.body);
          appointments = appointmentResponse.appointments;
          reservadasList = appointments
              .where((appointment) => appointment.status.name == 'Reservada')
              .toList();
          confirmadasList = appointments
              .where((appointment) => appointment.status.name == 'Confirmada')
              .toList();
          atendidasYCanceladasList = appointments
              .where((appointment) =>
                  appointment.status.name == 'Atendida' ||
                  appointment.status.name == 'Cancelada')
              .toList();
          print(appointments);
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
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
          print(serverResponse);
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

  Future<bool> confirmAppointment(String id) async {
    print('Peticion API');
    _endPoint = '/api/v1/confirm-appointment';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': id,
    };
    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .post(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          getAppointments();
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          print(serverResponse?.message ?? 'Todo bien!!');
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
              serverResponse?.message?.substring(0, 60) ??
                  'Error Desconocido.');
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

  Future<bool> cancelAppointment(String id, String justification) async {
    print('Peticion API Cancel Appointment $id');
    _endPoint = '/api/v1/cancel-appointment';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': id,
      'justification': justification,
    };
    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .post(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Cita $id cancelada correctamente.');
          getAppointments();
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
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message?.substring(0, 60) ??
                  'Error Desconocido.');
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

  Future<bool> getData() async {
    print('Peticion API');
    _endPoint = '/api/v1/appointments/catalogs';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Data ${response.body}');
          final dataResponse = DataResponse.fromJson(response.body);
          specialties = dataResponse.specialties;
          print('specialties $specialties');
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
              serverResponse?.message?.substring(0, 60) ??
                  'Error Desconocido.');
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

  Future<bool> scheduleIntervals() async {
    print('Peticion API get Hours');
    _endPoint = '/api/v1/appointments/get-hours';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': doctorSelected,
      'scheduled_date': startDate,
    };
    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .post(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
          scheduleIntervalsResponse =
              ScheduleIntervalsResponse.fromJson(response.body);
          morningIntervals =
              scheduleIntervalsResponse?.doctorSchedule?.morningIntervals;
          Notifications.showSnackBar(
              'Horario del medico $doctorSelected obtenido correctamente.');
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

  Future<bool> createAppointment() async {
    print('Peticion API get Hours');
    _endPoint = '/api/v1/appointments';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': doctorSelected,
      'scheduled_date': startDate,
      'scheduled_time': startTime,
      'specialty_id': specialtySelected,
      'doctor_id': doctorSelected,
      'description': description,
    };
    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .post(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Pedido ${response.body}');
          final appointmentCreatedResponse =
              AppointmentCreatedResponse.fromJson(response.body);
          reservadasList.add(appointmentCreatedResponse.appointment!);

          Notifications.showSnackBar(appointmentCreatedResponse.message ??
              'Su Cita ha sido creada correctamente.');
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
          Notifications.showSnackBar(serverResponse?.message ?? 'Error 404.');
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

  Future getSpecialtyDoctors() async {
    print(doctors);
    final specialty = specialties!.firstWhere(
        (specialty) => specialty.id.toString() == specialtySelected);
    doctors = [];
    doctorSelected = null;
    if (doctors!.isEmpty) {
      doctors = specialty.doctors!.toList();
    }
    notifyListeners();
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateNamedTo(LoginScreen.routeName, null);
  }
}
