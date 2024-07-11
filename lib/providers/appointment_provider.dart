import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/helpers/debouncer.dart';
import 'package:hope_app/locator.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class AppointmentProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> specialtyDropdownKey = GlobalKey<FormState>();
  GlobalKey<FormState> intervalsDropdownKey = GlobalKey<FormState>();
  GlobalKey<FormState> doctorDropdownKey = GlobalKey<FormState>();

  String? startDate;
  String? startTime;
  String? endTime;
  String description = 'Consulta';
  String _apiUrl = Preferences.apiServer;
  String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/';
  String jwtToken = '';
  MyAppointment? appointment;
  List<MyAppointment> appointments = [];
  List<MyAppointment> calendarAppointments = [];
  List<MyAppointment> reservadasList = [];
  List<MyAppointment> confirmadasList = [];
  List<MyAppointment> atendidasYCanceladasList = [];
  List<MyAppointment> doctorAppointments = [];
  List<Specialty>? specialties = [];
  String? _specialtySelected;
  List<Doctor>? doctors = [];
  List<User> users = [];
  String? _doctorSelected;
  String? _patientSelected;
  String _patientFullName = '';
  List<String>? morningIntervals = [];
  List<String>? afternoonIntervals = [];
  List<String>? allIntervals = [];
  List<WorkScheduleDoctor> workSchedule = [];
  ScheduleIntervalsResponse? scheduleIntervalsResponse;
  DoctorScheduleResponse? doctorScheduleResponse;
  late MyAppointments appointmentResponse;
  late MyAppointments appointmentResponse2;
  ServerResponse? serverResponse;
  SearchUserResponse? searchResponse;
  AppointmentResponse? singleAppointmentResponse;
  bool result = false;
  bool _isLoading = false;

  String gender = 'F';
  String email = '';
  String password = '';
  String ocupation = '';
  String maritalStatus = '';
  String contactName = '';
  String contactPhone = '';
  String phone = '';

  final NavigationService _navigationService = locator<NavigationService>();

  bool get isLoading => _isLoading;

  get schedules => null;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _isLoadingCatalogs = false;
  get isLoadingCatalogs => _isLoadingCatalogs;
  set isLoadingCatalogs(value) {
    _isLoadingCatalogs = value;
  }

  String? get doctorSelected => _doctorSelected;

  set doctorSelected(String? value) {
    _doctorSelected = value;
    print('set Doctor selected: $doctorSelected');
    notifyListeners();
  }

  String? get patientSelected => _patientSelected;

  set patientSelected(String? value) {
    _patientSelected = value;
    print('Patient Selected: $value');
    notifyListeners();
  }

  String get patientFullName => _patientFullName;

  set patientFullName(String value) {
    _patientFullName = value;
    print('Patient FullName: $value');
    notifyListeners();
  }

  String? get specialtySelected => _specialtySelected;
  set specialtySelected(String? value) {
    _specialtySelected = value;
    print('Specialty Selected: $value');
  }

  final storage = const FlutterSecureStorage();

  AppointmentProvider() {
    print('Appointment Provider inicializado!!');
  }

  bool isValidForm() {
    //print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<User>> _userStreamController = StreamController.broadcast();

  Stream<List<User>> get userStream => this._userStreamController.stream;

  Future<bool> getAppointments() async {
    _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    isLoadingCatalogs = true;
    result = false;
    print('Peticion API getAppointments');
    String endPoint = '/api/v1/appointments';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Api Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$endPoint');
    print('Url getAppointments: $url');
    try {
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 30),
          );

      switch (response.statusCode) {
        case 200:
          print('200: Appointments ${response.body}');
          appointmentResponse = MyAppointments.fromJson(response.body);
          appointments = appointmentResponse.appointments;
          reservadasList = appointments.where((appointment) => appointment.status!.name == 'Reservada').toList();
          confirmadasList = appointments
              .where((appointment) => appointment.status!.name == 'Confirmada')
              .toList();
          result = true;
          isLoadingCatalogs = false;
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }

          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 422:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoadingCatalogs = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> confirmAppointment(String id) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

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
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');

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
          print('200: Confirm ${response.body}');
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
          Notifications.showSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print('422: Confirm ${response.body}');
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
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

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
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');

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
          print('200: Cancel ${response.body}');
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(serverResponse?.message ?? 'Cita $id cancelada correctamente.');
          getAppointments();
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
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
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
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    isLoadingCatalogs = true;
    result = false;
    print('Peticion API getCatalogs Specialties');
    String endPoint = '/api/v1/appointments/catalogs';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$endPoint');
    print('Url getCatalogs: $url');

    try {
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoadingCatalogs = false;
          print('200: Especialidades encontradas ${response.body}');
          final dataResponse = DataResponse.fromJson(response.body);
          specialties = dataResponse.specialties?.where((specialty) => specialty.doctors!.isNotEmpty).toList();
          notifyListeners();
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('401 logout');
            break;
          }
          isLoadingCatalogs = false;
          result = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(
              '404 no se encontraron especialidades ${serverResponse?.message}');
          break;
        case 422:
          isLoadingCatalogs = false;
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
          isLoadingCatalogs = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          result = false;
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return result;
  }

  Future<bool> scheduleIntervals() async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

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
    print(queryParameters);
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');

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
          print('200: Get Intervals ${response.body}');
          scheduleIntervalsResponse =
              ScheduleIntervalsResponse.fromJson(response.body);
          morningIntervals =
              scheduleIntervalsResponse?.doctorSchedule?.morningIntervals ?? [];
          afternoonIntervals =
              scheduleIntervalsResponse?.doctorSchedule?.afternoonIntervals ??
                  [];
          allIntervals?.addAll(morningIntervals!);
          allIntervals?.addAll(afternoonIntervals!);

          Notifications.showSnackBar(
              'Horario del médico obtenido correctamente.');
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

  Future<bool> workScheduleDoctor() async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API work schedule');
    _endPoint = '/api/v1/appointments/work-schedule';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id_doctor': doctorSelected,
    };
    
    print('horario de trabajo del id_doctor $queryParameters');
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
     print('url: $url');

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
          print('200: Get work schedule ${response.body}');
          doctorScheduleResponse = DoctorScheduleResponse.fromJson(response.body);
          workSchedule = doctorScheduleResponse!.doctorSchedule;
          Notifications.showSnackBar(
              'Horario del médico obtenido correctamente.');
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
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('API Create Appointment');
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
      'scheduled_time_end': endTime,
      'specialty_id': specialtySelected,
      'doctor_id': doctorSelected,
      'patient_id': patientSelected,
      'description': description,
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url Create Appointment: $url');

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
          print('200: Create ${response.body}');
          final appointmentCreatedResponse = AppointmentCreatedResponse.fromJson(response.body);
          reservadasList.add(appointmentCreatedResponse.appointment!);
          appointments.add(appointmentCreatedResponse.appointment!);
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

  Future<MyAppointment> getAppointment(String id) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API getAppointment');
    _endPoint = '/api/v1/appointments';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName/api/v1/appointments/$id');
     print('url API getAppointment: $url');

    try {
      isLoading = true;
      result = false;
      final response = await http.get(url, headers: headers).timeout(
            const Duration(seconds: 30),
          );

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Get Appointment ${response.body}');
          singleAppointmentResponse =
              AppointmentResponse.fromJson(response.body);
          appointment = singleAppointmentResponse!.appointment;
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
          print('url api $_apiUrl');
          print('path $_proyectName$_endPoint/$id');
          print('404: Get Appointment ${response.body}');
          isLoading = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              '404: $id ${serverResponse?.message}' ?? 'Error Desconocido.');
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
    return appointment!;
  }

  Future getSpecialtyDoctors() async {

    print(doctors);
    final specialty = specialties!.firstWhere((specialty) => specialty.id.toString() == specialtySelected);
    doctors = [];
    doctorSelected = null;
    if (doctors!.isEmpty) {
      doctors = specialty.doctors!.toList();
    }
    notifyListeners();
  }

  Future<List<User>> searchUsers(String query) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API Search');
    _endPoint = '/api/v1/search/users';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'query': query,
      'type': 'patient',
    };
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint', queryParameters);
     print('url API Search: $url');

    try {
      isLoadingCatalogs = true;
      users = [];

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          isLoadingCatalogs = false;
          print('200: ${response.body}');
          searchResponse = SearchUserResponse.fromJson(response.body);
          users = searchResponse!.results;
          // Notifications.showSnackBar(
          //   'Se obtuvieron ${users.length} resultados.',
          // );
          break;
        case 401:
          if (!response.body.contains('code')) {
            logout();
            print('logout');
            break;
          }
          isLoadingCatalogs = false;
          users = [];
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error de Autenticación.');
          break;
        case 404:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(Preferences.truncateMessage(
              serverResponse?.message ?? 'Error Desconocido.'));
          notifyListeners();
          print('404 ${serverResponse?.message}');
          break;
        case 422:
          isLoadingCatalogs = false;
          serverResponse = ServerResponse.fromJson(response.body);
          Notifications.showSnackBar(
              serverResponse?.message ?? 'Error Desconocido.');
          notifyListeners();
          print(serverResponse);
          break;
        case 500:
          isLoadingCatalogs = false;
          Notifications.showSnackBar('500 Server Error.');
          break;
        default:
          print('Default: ${response.body}');
          isLoadingCatalogs = false;
          users = [];
      }
      notifyListeners();
    } catch (e) {
      print('Error $e');
      isLoadingCatalogs = false;
      if (e.toString().contains('TimeoutException')) {
        Notifications.showSnackBar(
            'Tiempo de espera agotado. Favor de reintentar');
      }
      notifyListeners();
    }
    return users;
  }

  Future<bool> updateAppointment(String id, String scheduledDate,String scheduledTime, String scheduledTimeEnd) async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API update appoinment ');
    _endPoint = '/api/v1/appointments/update-appointment';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': id,
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'scheduled_time_end': scheduledTimeEnd,
    };

    print(queryParameters);

    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');
    print('url update appoint: $url ');

    try {
      isLoading = true;
      result = false;

      final response = await http
          .put(url, headers: headers, body: json.encode(queryParameters))
          .timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          print('200: Update appointment ${response.body}');
          result = true;
          isLoading = false;
          singleAppointmentResponse =
              AppointmentResponse.fromJson(response.body);
          appointment = singleAppointmentResponse!.appointment;
          appointments.removeWhere((appt) => appt.id == appointment?.id);
          appointments.add(appointment!);
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


  Future<bool> getDoctorAppointments() async {
     _apiUrl = Preferences.apiServer;
    _proyectName = Preferences.projectName;

    print('Peticion API get appointments Doctor');
    _endPoint = '/api/v1/appointments/doctor';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final Map<String, dynamic> queryParameters = {
      'id': doctorSelected,
    };
    print('id del doctor seleccionado $queryParameters');
    final url = GeneralFunctions.createUri(_apiUrl, '$_proyectName$_endPoint');

    try {
       print('url Doctor Appointment: $url');
      isLoading = true;
      result = false;

      final response = await http.post(url, headers: headers, body: json.encode(queryParameters)).timeout(const Duration(seconds: 30));

      switch (response.statusCode) {
        case 200:
          result = true;
          isLoading = false;
          print('200: Get appointments Doctor ${response.body}');
          appointmentResponse2 = MyAppointments.fromJson(response.body);
          doctorAppointments = appointmentResponse2.appointments;
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


  void getUsersByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('hay valor a buscar $value');
      final results = await searchUsers(value);
      _userStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301)).then(
      (value) => timer.cancel(),
    );
  }

  Future logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    _navigationService.navigateNamedTo(LoginScreen.routeName, null);
  }
}
