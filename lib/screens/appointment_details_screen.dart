import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/appointment_cancelled_label.dart';
import 'package:hope_app/widgets/custom_appbar.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  static const String routeName = 'appointment-details';

  @override
  Widget build(BuildContext context) {
    final Appointment appointment =
        ModalRoute.of(context)!.settings.arguments as Appointment;
    final double fontSize;
    User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Detalles de la Cita',
            image: 'assets/images/modules/appointmentDetails.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //Widgets de la página
              const SizedBox(height: 30),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppointmentDetailRow(
                      title: 'Fecha: ',
                      value: appointment.scheduledDate,
                    ),
                    const SizedBox(height: 10),
                    AppointmentDetailRow(
                      title: 'Hora: ',
                      value: appointment.scheduledTime,
                    ),
                    const SizedBox(height: 10),
                    AppointmentDetailRow(
                      title: 'Motivo de la consulta: ',
                      value: appointment.description,
                    ),
                    const SizedBox(height: 10),
                    (apiUser.miPerfil.nombre != 'Doctor')
                        ? Column(
                            children: [
                              AppointmentDetailRow(
                                title: 'Doctor: ',
                                value:
                                    '${appointment.doctor.name} ${appointment.doctor.lastName}',
                              ),
                              AppointmentDetailRow(
                                title: 'Paciente: ',
                                value:
                                    '${appointment.patient.name} ${appointment.patient.lastName}',
                              )
                            ],
                          )
                        : AppointmentDetailRow(
                            title: 'Paciente: ',
                            value:
                                '${appointment.patient.name} ${appointment.patient.lastName}',
                          ),
                    const SizedBox(height: 10),
                    AppointmentDetailRow(
                      title: 'Tipo: ',
                      value: appointment.type,
                    ),
                    const SizedBox(height: 10),
                    AppointmentDetailRow(
                      title: 'Estatus: ',
                      value: appointment.status.name,
                    ),
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}

class AppointmentDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;

  AppointmentDetailRow({
    required this.title,
    required this.value,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
                fontSize: fontSize),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: (value == 'Cancelada')
                  ? ThemeProvider.lightRed
                  : (value == 'Atendida')
                      ? ThemeProvider.green
                      : (value == 'Reservada')
                          ? ThemeProvider.blue
                          : ThemeProvider.secondColor,
            ),
            child: Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: ThemeProvider.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto',
                  fontSize: fontSize),
            ),
          ),
        ),
      ],
    );
  }
}
