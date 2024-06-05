import 'package:flutter/material.dart';
import 'package:hope_app/providers/theme_provider.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class DayCalendar extends StatelessWidget {
  const DayCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.53,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Text(
              'Citas Confirmadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                color: Preferences.isDarkMode
                    ? ThemeProvider.white
                    : ThemeProvider.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(left: 15,right: 15,),
            decoration: BoxDecoration(
            color: ThemeProvider.primaryColor.withAlpha(40),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SfCalendar(
              view: CalendarView.schedule,
            ),
          ))
        ],
      ),
    );
  }
}
