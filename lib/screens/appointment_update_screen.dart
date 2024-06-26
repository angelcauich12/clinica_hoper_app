import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/home.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:hope_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class AppointmentUpdateScreen extends StatefulWidget {
  static const String routeName = 'appointment-update';

  const AppointmentUpdateScreen({super.key});

  @override
  State<AppointmentUpdateScreen> createState() =>
      _AppointmentUpdateScreenState();
}

class _AppointmentUpdateScreenState extends State<AppointmentUpdateScreen> {
  bool isLoading = false;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: '',
            image: 'assets/images/modules/appointmentReminder.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //Widgets de la página
              const SizedBox(height: 30),
              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: FutureBuilder(
                  future: appointmentProvider.getAppointment(id),
                  builder: (context, AsyncSnapshot<MyAppointment> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitCubeGrid(
                          color: ThemeProvider.secondColor,
                        ),
                      );
                    }

                    final appointment = snapshot.data;
                    String formattedTime = GeneralFunctions.formatTime(
                        appointment!.scheduledTime!);
                    String formattedDate =
                        GeneralFunctions.formatDate(appointment.scheduledDate!);

                    return (isLoading)
                        ? SizedBox(
                            width: size.width,
                            height: size.height * 0.6,
                            child: Center(
                              child: SpinKitCubeGrid(
                                color: ThemeProvider.secondColor,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Su cita con el doctor ${appointment!.doctor?.name} ${appointment.doctor?.lastName} es el $formattedDate a las $formattedTime. Favor de confirmar su asistencia y llegar con anticipación. Gracias!',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: Size((size.width / 3), 50),
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.teal,
                                      disabledForegroundColor:
                                          Colors.transparent,
                                      disabledBackgroundColor:
                                          Colors.transparent,
                                    ),
                                    onPressed: () async {
                                      print('Cita envidada para Confirmar!!');
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final result = await appointmentProvider
                                          .confirmAppointment(
                                              appointment.id.toString());
                                      setState(() {
                                        isLoading = false;
                                      });
                                      if (result) {
                                        Notifications.showSnackBar(
                                            'Gracias! Su cita con doctor(a) ${appointment.doctor!.name} ${appointment.doctor!.lastName} ha sido confirmada.');
                                        Future.microtask(
                                          () {
                                            Navigator.pushNamed(
                                              context,
                                              Home.routeName,
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: const Text('Confirmar Cita'),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      fixedSize: Size((size.width / 3), 50),
                                      foregroundColor: Colors.white,
                                      backgroundColor: ThemeProvider.lightRed,
                                      disabledForegroundColor:
                                          Colors.transparent,
                                      disabledBackgroundColor:
                                          Colors.transparent,
                                    ),
                                    // ignore: void_checks
                                    onPressed: () async {
                                     await GeneralFunctions.showCancelAppointment(context, id);
                                        Future.microtask(
                                          () {
                                            Navigator.pushNamed(
                                              context,
                                              Home.routeName,
                                            );
                                          },
                                        );
                                    },
                                    child: const Text('Cancelar Cita'),
                                  ),
                                ],
                              )
                            ],
                          );
                  },
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
