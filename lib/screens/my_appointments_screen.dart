import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

List<String> statusList = [
  'Confirmada',
  'Reservada',
  'Atendida',
  'Cancelada',
];

class MyAppointmentsScreen extends StatelessWidget {
  static const String routeName = 'myappointments';

  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppointmentsTabs();
  }
}

class AppointmentsTabs extends StatelessWidget {
  const AppointmentsTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // backgroundColor: Preferences.isDarkMode ? ThemeProvider.brown : Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Citas',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Preferences.isDarkMode
                  ? ThemeProvider.white
                  : ThemeProvider.brown,
            ),
          ),
          backgroundColor: Preferences.isDarkMode
              ? ThemeProvider.transparent
              : ThemeProvider.white,
        ),
        body: AppointmentsTabsBody(),
      ),
    );
  }
}

class AppointmentsTabsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final List<MyAppointment> reservadasList = appointmentProvider.reservadasList;
    final List<MyAppointment> confirmadasList =  appointmentProvider.confirmadasList;
    User apiUser = User.fromJson(Preferences.apiUser);

    // final List<MyAppointment> atendidasYCanceladasList = appointmentProvider.atendidasYCanceladasList;

    return SafeArea(
      child: (appointmentProvider.isLoading)
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
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    labelColor: ThemeProvider.white,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Preferences.isDarkMode
                            ? ThemeProvider.yellowColor
                            : ThemeProvider.secondColor),
                    tabs:  [
                      const Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Próximas",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                     apiUser.miPerfil.nombre != 'Doctor' ?  const Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Confirmadas",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      : Container(),
                      // Tab(
                      //   child: Align(
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       "Historial",
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: TabBarView(
                    children: [
                      AppointmentList(appointments: reservadasList),
                      AppointmentList(appointments: confirmadasList),
                      // AppointmentList(appointments: atendidasYCanceladasList),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
