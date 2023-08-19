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

    Future<void> onRefresh() async {
      print('se ejecuta el refresh');
      // await orderProvider.getOrdenes();
    }

    return Scaffold(
      body: RefreshIndicator(
        color: ThemeProvider.darkColor,
        onRefresh: onRefresh,
        child: Column(
          children: [
            const SizedBox(height: 25),
            Text(
              'Citas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Preferences.isDarkMode
                    ? ThemeProvider.white
                    : ThemeProvider.brown,
              ),
            ),
            const SizedBox(height: 15),
            AppointmentList(),
          ],
        ),
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
      ),
    );
  }
}
