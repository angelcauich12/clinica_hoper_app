import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';

class MyAppointmentsScreen extends StatelessWidget {
  static const String routeName = 'myappointments';

  const MyAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final orderProvider = Provider.of<PedidosProvider>(context);
    // bool isLoading = orderProvider.isLoading;
    bool isLoading = false;

    return AppointmentsTabs();
    // child: (!isLoading)
    //     ? Container(
    //         child: Center(
    //           child: Text('My Appointments'),
    //         ),
    //       ) //PedidosList(pedidosProv: orderProvider.pedidosXProv)
    //     : Center(
    //         child: SpinKitSpinningLines(
    //           color: ThemeProvider.darkColor,
    //         ),
    //       ),
  }
}

class AppointmentsTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: ThemeProvider.white,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Preferences.isDarkMode
                      ? ThemeProvider.yellowColor
                      : ThemeProvider.secondaryColor),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Align(
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
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Align(
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
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Canceladas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: TabBarView(
              children: [
                AppointmentList(length: 2),
                AppointmentList(length: 1),
                AppointmentList(length: 5),
              ],
            ),
          )
        ],
      ),
    );
  }
}
