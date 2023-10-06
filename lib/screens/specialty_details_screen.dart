import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/widgets/widgets.dart';

class SpecialtyDetailsScreen extends StatelessWidget {
  static const String routeName = 'specialty-details';

  @override
  Widget build(BuildContext context) {
    final SpecialtyDTO specialty =
        ModalRoute.of(context)!.settings.arguments as SpecialtyDTO;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: specialty.title ?? '',
            image: specialty.image ?? 'assets/images/loading.gif',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Text(
                    specialty.description ?? '',
                    style: const TextStyle(
                      fontFamily: 'LibreBaskerville',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const BookAppointmentBtn(),
                const SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }
}
