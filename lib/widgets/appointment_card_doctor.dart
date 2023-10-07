import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class AppointmentCardDoctor extends StatelessWidget {
  final Appointment appointment;
  final bool withMargin;

  const AppointmentCardDoctor(
      {super.key, required this.appointment, this.withMargin = true});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final scheduleDate = DateFormat.yMMMEd('es-MX').format(
      DateTime.parse(appointment.scheduledDate),
    );
    final scheduledTime =
        Preferences.formatScheduledTime(appointment.scheduledTime);
    final scheduledTimeEnd =
        Preferences.formatScheduledTime(appointment.scheduledTimeEnd);

    return Container(
      margin: (withMargin)
          ? const EdgeInsets.symmetric(vertical: 10, horizontal: 15)
          : const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Preferences.isDarkMode
              ? ThemeProvider.secondColor
              : ThemeProvider.fourColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 2,
              offset: const Offset(-2, 2),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppointmentCardDoctorHeader(appointment: appointment),
          const SizedBox(height: 5),
          AppointmentCardDoctorBody(
            scheduleDate: scheduleDate,
            scheduledTime: scheduledTime,
            scheduledTimeEnd: scheduledTimeEnd,
            appointment: appointment,
          ),
        ],
      ),
    );
  }
}

class AppointmentCardDoctorHeader extends StatelessWidget {
  const AppointmentCardDoctorHeader({
    super.key,
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    User apiUser = User.fromJson(Preferences.apiUser);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final String initials = Preferences.getInitials(
        string: '${appointment.patient.name} ${appointment.patient.lastName}',
        limitTo: 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {},
              child: (apiUser.miPerfil.nombre == 'Doctor')
                  ? CircleAvatar(
                      backgroundColor: ThemeProvider.secondColor,
                      child: Text(initials),
                    )
                  : const CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/medical-team.png'),
                    ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.6,
                  child: Text(
                    (apiUser.miPerfil.nombre == 'Doctor')
                        ? '${appointment.patient.name} ${appointment.patient.lastName}'
                        : '${appointment.doctor.name} ${appointment.doctor.lastName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Preferences.isDarkMode
                          ? ThemeProvider.white
                          : ThemeProvider.lightColor,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${appointment.type} - ${appointment.specialty.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        color: Preferences.isDarkMode
                            ? Colors.grey
                            : Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    (appointment.status.name == 'Cancelada')
                        ? const CanceledLabel()
                        : Container(),
                  ],
                ),
              ],
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (appointment.status.name != 'Confirmada' &&
                              appointment.status.name != 'Atendida' &&
                              appointment.status.name != 'Cancelada')
                          ? ButtonSheetOpt(
                              title: 'Confirmar Cita',
                              icon: Icons.thumb_up_outlined,
                              onTap: () async {
                                print('Cita Confirmada');
                                Navigator.pop(context);

                                final response = await appointmentProvider
                                    .confirmAppointment(
                                        appointment.id.toString());

                                if (response) {
                                  Notifications.showSnackBar(
                                      'Gracias! Su cita con doctor(a) ${appointment.doctor.name} ${appointment.doctor.lastName} ha sido confirmada.');
                                }
                              },
                              iconColor: ThemeProvider.green,
                            )
                          : Container(),
                      (appointment.status.name != 'Atendida' &&
                              appointment.status.name != 'Cancelada')
                          ? ButtonSheetOpt(
                              title: 'Cancelar Cita',
                              icon: Icons.thumb_down_outlined,
                              onTap: () {
                                Navigator.pop(context);
                                showCancelAppointment(context);
                              },
                              iconColor: ThemeProvider.lightRed,
                            )
                          : Container(),
                      (appointment.status.name != 'Atendida' ||
                              appointment.status.name != 'Cancelada')
                          ? ButtonSheetOpt(
                              title: 'Detalles de la Cita',
                              icon: Icons.list_alt_rounded,
                              onTap: () {
                                print('Cita ${appointment.id}');
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, AppointmentDetailsScreen.routeName,
                                    arguments: appointment);
                              },
                              iconColor: ThemeProvider.secondColor,
                            )
                          : Container(),
                    ],
                  ),
                );
              },
            );
          },
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Icon(Icons.more_vert, color: ThemeProvider.thirdColor),
        ),
      ],
    );
  }

  Future<String?> showCancelAppointment(BuildContext context) {
    final cancelForm =
        Provider.of<CancelAppointmentFormProvider>(context, listen: false);

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Cancelar Cita',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Realmente desea cancelar esta cita?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Form(
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
                        onChanged: (value) => cancelForm.justification = value,
                        validator: (value) {
                          return (value != null && value.length >= 3)
                              ? null
                              : 'Escriba una justificación para cancelar';
                        },
                      ),
                    ],
                  ))
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cerrar'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ThemeProvider.lightRed,
              ),
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                ThemeProvider.secondColor,
              ),
            ),
            onPressed: () => cancelAppointment(context, cancelForm),
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

  cancelAppointment(context, cancelProvider) {
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    appointmentProvider.cancelAppointment(
      '${appointment.id}',
      cancelProvider.justification,
    );
    Navigator.pop(context, 'Confirmar');
  }
}

class AppointmentCardDoctorBody extends StatelessWidget {
  const AppointmentCardDoctorBody({
    super.key,
    required this.scheduleDate,
    required this.scheduledTime,
    required this.scheduledTimeEnd,
    required this.appointment,
  });

  final String scheduleDate;
  final String scheduledTime;
  final String scheduledTimeEnd;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    User apiUser = User.fromJson(Preferences.apiUser);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppointmentDescription(
                description: scheduleDate,
                icon: Icons.calendar_month_outlined,
                color: ThemeProvider.lightColor,
              ),
              const SizedBox(height: 2),
              AppointmentDescription(
                description: '$scheduledTime - $scheduledTimeEnd',
                icon: Icons.timer_outlined,
                color: ThemeProvider.lightColor,
              ),
            ],
          ),
          ((apiUser.miPerfil.nombre != 'Doctor') &&
                  apiUser.id != appointment.patient.id)
              ? Column(
                  children: [
                    const SizedBox(height: 2),
                    AppointmentDescription(
                      description:
                          'Paciente: ${appointment.patient.name} ${appointment.patient.lastName}',
                      icon: Icons.person_pin_outlined,
                      color: ThemeProvider.lightColor,
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
