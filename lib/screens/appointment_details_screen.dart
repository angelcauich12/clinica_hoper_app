import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/custom_appbar.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  static const String routeName = 'appointment-details';

  @override
  Widget build(BuildContext context) {
    final Appointment appointment =
        ModalRoute.of(context)!.settings.arguments as Appointment;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Detalles de la Cita',
            image:
                'https://i.tribune.com.pk/media/images/2225461-doctor-1589963876/2225461-doctor-1589963876.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //Widgets de la página
            ]),
          )
        ],
      ),
    );
  }
}
