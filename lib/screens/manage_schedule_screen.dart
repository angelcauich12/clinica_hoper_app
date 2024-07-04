import 'package:flutter/material.dart';
import 'package:hope_app/widgets/widgets.dart';
import '../providers/providers.dart';
class ManageScheduleScreen extends StatelessWidget {
  static const String routeName = 'manage-schedule';
  const ManageScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 1,
          bottom: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: ThemeProvider.white,
              indicator: const BoxDecoration(
                 color: Colors.transparent),
              tabs:  const [
                Text(
            'Calendario de exclusión',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              fontSize: 20,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 10.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
            ),
          ),
              ]),
          centerTitle: true,
        ),
        body: const TabBarView(children: [
         ScheduleCalendar()
        ],),
      ),
    );
  }
}
