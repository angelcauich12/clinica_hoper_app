import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class AppointmentProvider extends ChangeNotifier {
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
  final String _apiUrl = Preferences.apiServer;
  final String _proyectName = Preferences.projectName;
  String _endPoint = '/api/v1/get-appointments';
  String jwtToken = '';
  List<Appointment> appointments = [];
  List<Appointment> reservadasList = [];
  List<Appointment> confirmadasList = [];
  List<Appointment> atendidasYCanceladasList = [];
  late MyAppointments appointmentResponse;
  ServerResponse? serverResponse;
  bool result = false;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
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
    _endPoint = '/api/v1/get-appointments';

    String jwtToken = await storage.read(key: 'jwtToken') ?? '';
    print('Api Token: $jwtToken');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    final url = Uri.http(_apiUrl, '$_proyectName$_endPoint');

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

  logout() async {
    await storage.deleteAll();
    Preferences.apiUser = '';
    Notifications.showSnackBar('Su sesión ha vencido.');
    // _navigationService.navigateTo(LoginScreen.routeName);
  }
}
