import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../screens/screens.dart';
import '../shared/preferences.dart';
import '../ui/input_decorations.dart';

class GeneralFunctions {
  static String formatTime(String value, {String? timeFormat, String? locale}) {
    // Asume que la entrada puede ser una cadena de fecha completa
    DateTime parsedValue;
    try {
      // Intenta analizar la cadena como una fecha completa primero
      parsedValue = DateTime.parse(value);
    } catch (e) {
      // Si falla, asume que la cadena solo contiene horas y minutos
      parsedValue = DateFormat('HH:mm').parse(value);
    }

    // Formatea la hora usando el formato deseado
    final DateFormat formattedTime =
        DateFormat(timeFormat ?? 'HH:mm a', locale);
    return formattedTime.format(parsedValue);
  }

  static String formatDate(dynamic value, {String? dateFormat}) {
    if (value == null) {
      return 'N/A';
    }

    DateTime parsedValue;

    if (value is String) {
      try {
        parsedValue = DateTime.parse(value);
      } catch (e) {
        parsedValue = DateFormat('yyyy-MM-dd').parse(value);
      }
    } else if (value is DateTime) {
      parsedValue = value;
    } else {
      throw ArgumentError(
          'El valor proporcionado no es ni una cadena ni un DateTime');
    }

    final DateFormat formattedDate = DateFormat(dateFormat ?? 'MM/dd/yyyy');
    return formattedDate.format(parsedValue);
  }

  //modal para cancelar una cita
  static Future<void> showConfirmModal(BuildContext context, String id,
      {String? title,
      String? question,
      bool? haveDescription,
      bool? isAppointment}) async {
    final cancelForm =
        Provider.of<CancelAppointmentFormProvider>(context, listen: false);
    final appointmentProv =
        Provider.of<AppointmentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Text(
          title ?? 'sin título',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question ?? 'no tiene pregunta',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            haveDescription ?? false
                ? Form(
                    key: cancelForm.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecorations.authInputDecoration(
                            color: Colors.grey[350]!,
                            hintText: 'Motivo de Cancelación',
                            labelText: 'Justificación',
                          ),
                          onChanged: (value) =>
                              cancelForm.justification = value,
                          validator: (value) {
                            return (value != null && value.length >= 3)
                                ? null
                                : 'Escriba una justificación';
                          },
                        ),
                      ],
                    ))
                : Container()
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              backgroundColor: ThemeProvider.lightRed,
            ),
            child: Text(
              'Cerrar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                backgroundColor: ThemeProvider.secondColor),
            onPressed: isAppointment ?? false
                ? () async {
                    if (!cancelForm.isValidForm()) return;
                    await appointmentProv.cancelAppointment(
                        id, cancelForm.justification);
                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  }
                : () async {
                    await Provider.of<ManageScheduleProvider>(context,
                            listen: false)
                        .deleteNonWorkingDay(id);
                    if (context.mounted) {
                      Navigator.pop(
                        context,
                      );
                    }
                  },
            child: Text(
              'Confirmar',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: ThemeProvider.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //obtener un archivo json
  static Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

//modal para el código del modo desarrollador
  static showModalCode(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: loginForm.devKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textCapitalization: TextCapitalization.none,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                    color: Colors.grey[350]!,
                    hintText: 'Código de verificación',
                    labelText: 'Código',
                    prefixIcon: Icons.verified_user_outlined,
                  ),
                  onChanged: (value) => loginForm.devCode = value,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Escriba el código de verificación';
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                MaterialButton(
                  onPressed: () {
                    // print('devCode: ${loginForm.devCode}');
                    if (!loginForm.isValidFormDev()) return;
                    if (loginForm.devCode != Preferences.devCode) {
                      Notifications.showSnackBar('Código inválido');
                      return;
                    }
                    loginForm.devCode = null;
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog.fullscreen(
                            insetAnimationCurve: Curves.slowMiddle,
                            child: DevMode(),
                          );
                        });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: ThemeProvider.secondColor,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Text(
                      'verificar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//Alerta de modo guest
  static showGuestAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GuestDialog(
            onPressedCloseButton: () => Navigator.of(context).pop(),
            onPressedConfirmButton: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              await authService.logout();
              Future.microtask(
                () {
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
              );
            },
          );
        });
  }

  //Obtener las citas en formato del calendario
  static AppointmentDataSource getCalendarDataSource(
      List<MyAppointment> sourceAppointments,
      {bool schedule = false,
      Color? appointmenColor}) {
    User apiUser = User.fromJson(Preferences.apiUser);

    List<Appointment> appointments = sourceAppointments.map((myAppointment) {
      // Convertir la cadena de hora de inicio programada a un objeto DateTime
      DateTime? startTime = myAppointment.scheduledTime != null
          ? DateTime.parse(
              '${myAppointment.scheduledDate!} ${myAppointment.scheduledTime!}')
          : null;

      DateTime? endTime = myAppointment.scheduledTime != null
          ? DateTime.parse(
              '${myAppointment.scheduledDate!} ${myAppointment.scheduledTimeEnd!}')
          : null;

      // Dar formato a las horas en el formato 'hh:mm a'
      String formattedStartTime =
          startTime != null ? DateFormat('hh:mm ').format(startTime) : 'N/A';
      String formattedEndTime =
          endTime != null ? DateFormat('hh:mm ').format(endTime) : 'N/A';

      return Appointment(
          id: myAppointment.id,
          startTime: startTime!,
          endTime: endTime!,
          notes: myAppointment.status!.name,
          color: appointmenColor ?? Colors.red,
          subject: apiUser.miPerfil.nombre != 'Doctor'
              ? '$formattedStartTime - $formattedEndTime\nOcupado '
              : schedule
                  ? 'Px: ${myAppointment.patient!.name} ${myAppointment.patient!.lastName}'
                  : '$formattedStartTime - $formattedEndTime\nPx: ${myAppointment.patient!.name} ${myAppointment.patient!.lastName}');
    }).toList();

    return AppointmentDataSource(appointments);
  }

// Función para convertir cadena de tiempo a DateTimeº
  static DateTime parseTimeString(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);
    return DateTime(0, 1, 1, hours, minutes);
  }

// Función habilitar el horario del doctor
  static List<TimeRegion> getWorkScheduleRegions(
      List<WorkScheduleDoctor> workSchedule) {
    User apiUser = User.fromJson(Preferences.apiUser);
    final List<TimeRegion> regions = [];
    if (workSchedule.isNotEmpty) {
      for (var schedule in workSchedule) {
        final DateTime now = DateTime.now();
        final DateTime today = DateTime(now.year, now.month, now.day);

        final daysOfWeek = schedule.daysOfWeek.map((day) {
          switch (day) {
            case 1:
              return 'MO';
            case 2:
              return 'TU';
            case 3:
              return 'WE';
            case 4:
              return 'TH';
            case 5:
              return 'FR';
            case 6:
              return 'SA';
            case 0:
              return 'SU';
            default:
              return '';
          }
        }).join(',');

        final DateTime startTime = parseTimeString(schedule.startTime);
        final DateTime endTime = parseTimeString(schedule.endTime);

        for (String day in daysOfWeek.split(',')) {
          final TimeRegion region = TimeRegion(
            startTime: DateTime(today.year, today.month, today.day,
                startTime.hour, startTime.minute),
            endTime: DateTime(today.year, today.month, today.day, endTime.hour,
                endTime.minute),
            color: Colors.green.shade100,
            enablePointerInteraction:
                apiUser.miPerfil.nombre != 'Doctor' ? false : true,
            recurrenceRule: 'FREQ=WEEKLY;BYDAY=$day;INTERVAL=1;',
          );

          regions.add(region);
        }
      }
    }
    return regions;
  }

//Función para pintar el horario inhábil
  static List<TimeRegion> getNonWorkingDays(
      List<NonWorkingDay> sourceNonWorkingDays) {
    return sourceNonWorkingDays.map((nonWorkingDay) {
      DateTime startTime = DateTime.parse(nonWorkingDay.start.trim());
      DateTime endTime = DateTime.parse(nonWorkingDay.end.trim());

      return TimeRegion(
          startTime: startTime,
          endTime: endTime,
          color: Colors.yellow.shade400,
          enablePointerInteraction: false,
          iconData: Icons.not_interested_outlined,
          textStyle: const TextStyle(fontSize: 20));
    }).toList();
  }

  static String dayToWeekDay(int day) {
    switch (day) {
      case 0:
        return 'SU';
      case 1:
        return 'MO';
      case 2:
        return 'TU';
      case 3:
        return 'WE';
      case 4:
        return 'TH';
      case 5:
        return 'FR';
      case 6:
        return 'SA';
      default:
        return '';
    }
  }

//Modal para ver los detalles de una cita
  static Future<void> showDetails(
    String date,
    String startTime,
    String endTime,
    String id,
    BuildContext context, {
    bool? isAppointment,
    String? head,
    String? patientName,
    String? endDate,
    String? status,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10.0, vertical: 3.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        isAppointment ?? false
                            ? showConfirmModal(context, id,
                                title: 'Cancelar cita',
                                question: '¿Realmente desea cancelar la cita?',
                                haveDescription: true,
                                isAppointment: isAppointment)
                            : showConfirmModal(
                                context,
                                id,
                                title: 'Eliminar exclusión de horario',
                                question:
                                    '¿Realmente desea eliminar este horario?',
                              );
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade800,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Preferences.isDarkMode
                            ? ThemeProvider.white
                            : ThemeProvider.secondColor,
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    head ?? 'sin cabecera',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Preferences.isDarkMode
                            ? ThemeProvider.white
                            : ThemeProvider.secondColor),
                  ),
                  if (status != null)
                    StatusLabel(
                      status: status,
                    )
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              isAppointment ?? false
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Preferences.isDarkMode
                            ? Colors.grey.withOpacity(0.15)
                            : ThemeProvider.secondColor.withAlpha(70),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person_pin_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                'Paciente:',
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  patientName ?? 'sin contenido',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                date,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.timer_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('$startTime - $endTime')
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Preferences.isDarkMode
                            ? Colors.grey.withOpacity(0.15)
                            : ThemeProvider.secondColor.withAlpha(70),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha de inicio',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(date),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(Icons.timer_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(startTime)
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Fecha final',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.calendar_month_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(endDate ?? 'sin fecha final'),
                              const SizedBox(
                                width: 5,
                              ),
                              const Icon(Icons.timer_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(endTime)
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

//Crea la uri de acuerdo al Https del Preferences
  static Uri createUri(String apiServer, String projectName,
      [Map<String, dynamic>? queryParameters]) {
    final bool isHttps = Preferences.isHttps;

    if (isHttps) {
      return Uri.https(apiServer, projectName, queryParameters);
    } else {
      return Uri.http(apiServer, projectName, queryParameters);
    }
  }

  static AppointmentDataSource getBlackoutDates(
      List<NonWorkingDay> sourceNonWorkingDays) {
    List<Appointment> nonWorkingDays =
        sourceNonWorkingDays.map((myAppointment) {
      DateTime startTime = DateTime.parse(myAppointment.start.trim());
      DateTime endTime = DateTime.parse(myAppointment.end.trim());

      String formattedStartTime = DateFormat('hh:mm').format(startTime);
      String formattedEndTime = DateFormat('hh:mm').format(endTime);

      return Appointment(
          subject: "$formattedStartTime - $formattedEndTime",
          color: Colors.red,
          id: myAppointment.id,
          startTime: startTime,
          endTime: endTime,
          isAllDay: false);
    }).toList();

    return AppointmentDataSource(nonWorkingDays);
  }
}
