import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              spreadRadius: 4,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, DoctorScreen.routeName,
                arguments: 'Dra. Nayli Hoil Pérez'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://ochsner-craft.s3.amazonaws.com/imager/wwwdoctors/6162509/Samant-Hrishikesh-1982087755-3053e96218.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      "Dra. Nayli Hoil Pérez",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Preferences.isDarkMode
                            ? ThemeProvider.white
                            : ThemeProvider.lightColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Consulta - Ginecología",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: ThemeProvider.lightColor,
                ),
                Text(
                  "Lun, 21 Agosto 2023",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? ThemeProvider.white
                        : ThemeProvider.lightColor,
                  ),
                ),
                Icon(
                  Icons.timer_outlined,
                  color: ThemeProvider.lightColor,
                ),
                Text(
                  "11:00 - 12:00",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Preferences.isDarkMode
                        ? ThemeProvider.white
                        : ThemeProvider.lightColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 248, 248, 248),
                    shape: const StadiumBorder()),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Arial',
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.lightColor,
                    shape: const StadiumBorder()),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Text(
                    'Reagendar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Arial',
                      color: ThemeProvider.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
