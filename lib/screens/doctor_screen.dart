import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';

class DoctorScreen extends StatelessWidget {
  static const String routeName = 'doctor-details';

  @override
  Widget build(BuildContext context) {
    final String doctor =
        ModalRoute.of(context)?.settings.arguments.toString() ?? 'No-doctor';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: doctor,
            image:
                'https://previews.123rf.com/images/fongfong/fongfong1909/fongfong190900087/130110064-doctor-in-hospital-background-with-copy-space.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _DoctorImage(),
              const Experience(),
              _AboutDoctor(),
              const BookAppointmentBtn(),
              const SizedBox(height: 50)
            ]),
          )
        ],
      ),
    );
  }
}

class _DoctorImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      margin: const EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        children: [DoctorPosterAndName()],
      ),
    );
  }
}

class DoctorPosterAndName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
                color: Color.fromARGB(100, 0, 0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: const FadeInImage(
              width: 100,
              height: 120,
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(
                  'https://ochsner-craft.s3.amazonaws.com/imager/wwwdoctors/6162509/Samant-Hrishikesh-1982087755-3053e96218.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              "Ginecología",
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
    );
  }
}

class Experience extends StatelessWidget {
  const Experience({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Row(
        children: <Widget>[
          ExperienceCard(
            name: 'Pacientes',
            value: '100+',
          ),
          const SizedBox(width: 10),
          ExperienceCard(
            name: 'Experiencia',
            value: '5 años',
          ),
          const SizedBox(width: 10),
          ExperienceCard(
            name: 'Calificaciones',
            value: '4.5',
          ),
        ],
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  String name;
  String value;

  ExperienceCard({required this.name, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Preferences.isDarkMode ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 25,
              color: Preferences.isDarkMode
                  ? ThemeProvider.white
                  : ThemeProvider.lightColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    ));
  }
}

class _AboutDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acerca de mi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: Preferences.isDarkMode
                  ? ThemeProvider.white
                  : ThemeProvider.lightColor,
            ),
          ),
          const SizedBox(height: 15),
          _AboutDoctorDescription(),
          _AboutDoctorDescription(),
          _AboutDoctorDescription(),
        ],
      ),
    );
  }
}

class _AboutDoctorDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 25),
      width: double.infinity,
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Qui necessitatibus doloremque quaerat nemo quod nisi ullam. Nesciunt tempore quisquam omnis porro quasi quos similique ut, eos distinctio expedita facilis consequatur!. ',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 14.0,
          letterSpacing: 1.2,
          color: Preferences.isDarkMode
              ? ThemeProvider.white
              : ThemeProvider.lightGrey,
          fontWeight: FontWeight.w500,
          fontFamily: 'LibreBaskerville',
        ),
      ),
    );
  }
}

class BookAppointmentBtn extends StatelessWidget {
  const BookAppointmentBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
      child: ElevatedButton(
        onPressed: () =>
            Navigator.pushNamed(context, CreateAppointmentScreen.routeName),
        style: ElevatedButton.styleFrom(
            backgroundColor: ThemeProvider.lightColor,
            shape: const StadiumBorder()),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Text(
            'Agendar Cita',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
              color: ThemeProvider.white,
            ),
          ),
        ),
      ),
    );
  }
}
