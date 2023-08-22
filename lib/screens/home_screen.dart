import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

const LatLng currentLocation = LatLng(20.988331640730305, -89.60906162570994);

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _homeGreetings(
              apiUser: apiUser,
            ),
            const SizedBox(height: 35),
            DangerMessageWithButton(
              color: const Color.fromRGBO(255, 191, 191, 1),
              paragraph1:
                  'Hemos detectado que no tiene completo su expediente clínico.',
              paragraph2: '',
              title: 'Estimado Paciente',
            ),
            const SizedBox(height: 25),
            const _homeButtons(),
            const SizedBox(height: 25),
            SpecialtySlider(specialties: specialties),
            const SizedBox(height: 25),
            _findUs(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _homeGreetings extends StatelessWidget {
  User apiUser;

  _homeGreetings({required this.apiUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hola",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Preferences.isDarkMode
                      ? ThemeProvider.white
                      : ThemeProvider.brown,
                ),
              ),
              Row(
                children: [
                  Text(
                    apiUser.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Preferences.isDarkMode
                          ? ThemeProvider.white
                          : ThemeProvider.brown,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '👋',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: Preferences.isDarkMode
                          ? ThemeProvider.white
                          : ThemeProvider.brown,
                    ),
                  ),
                ],
              ),
            ],
          ),
          PopupMenuList(
            apiUser: apiUser,
          ),
        ],
      ),
    );
  }
}

class _homeButtons extends StatelessWidget {
  const _homeButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        HomeActionButton(
          title: "En Clínica",
          subtitle: "Agenda una cita",
          backgroundColor: ThemeProvider.lightColor,
          iconColor: ThemeProvider.white,
          icon: Icons.medical_information_outlined,
        ),
        HomeActionButton(
          title: "A Domicilio",
          subtitle: "El doctor te visita.",
          iconColor: ThemeProvider.lightColor,
          backgroundColor: ThemeProvider.white,
          icon: Icons.home_outlined,
        ),
      ],
    );
  }
}

class HomeActionButton extends StatelessWidget {
  Color backgroundColor;
  Color iconColor;
  String subtitle;
  String title;
  IconData icon;

  HomeActionButton({
    super.key,
    required this.backgroundColor,
    required this.subtitle,
    required this.title,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          CreateAppointmentScreen.routeName,
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 4,
                ),
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(color: iconColor, shape: BoxShape.circle),
                child: Icon(
                  icon,
                  color: backgroundColor,
                  size: 35,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: iconColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(color: iconColor.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialtySlider extends StatelessWidget {
  const SpecialtySlider({
    super.key,
    required this.specialties,
  });

  final List<SpecialtyDTO> specialties;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nuestras Especialidades',
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
          Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: specialties.length,
              itemBuilder: (context, index) {
                return SpecialtyImageCard(
                  specialty: specialties[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SpecialtyImageCard extends StatelessWidget {
  SpecialtyDTO specialty;

  SpecialtyImageCard({required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      width: 300,
      child: Stack(
        children: <Widget>[
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: FadeInImage(
                width: double.infinity,
                height: double.infinity,
                placeholder: const AssetImage('assets/loading.gif'),
                image: NetworkImage(specialty.image!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    specialty.title!,
                    style: const TextStyle(
                      fontSize: 30.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialty.subtitle!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibreBaskerville',
                        shadows: [
                          Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _findUs extends StatefulWidget {
  @override
  State<_findUs> createState() => _findUsState();
}

class _findUsState extends State<_findUs> {
  late GoogleMapController mapController;

  Map<String, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ubícanos',
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
          Container(
            width: double.infinity,
            height: 350,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: currentLocation,
                zoom: 18,
              ),
              onMapCreated: (controller) {
                mapController = controller;
                _addMarker('Clínica Hoper', currentLocation);
              },
              markers: _markers.values.toSet(),
            ),
          ),
        ],
      ),
    );
  }

  _addMarker(String id, LatLng location) {
    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(
        title: 'Clínica Hoper',
        snippet: 'La mejor clínica de Mérida',
      ),
    );

    _markers[id] = marker;
    setState(() {});
  }
}

class SpecialtyDTO {
  String? title;
  String? subtitle;
  String? image;

  SpecialtyDTO({this.title, this.subtitle, this.image});
}

List<SpecialtyDTO> specialties = [
  SpecialtyDTO(
    title: "Odontología",
    subtitle: "Los mejores tratamientos",
    image:
        "https://post.healthline.com/wp-content/uploads/2019/04/Dentist_Teeth_Female_Patient-732x549-Thumbnail.jpg",
  ),
  SpecialtyDTO(
    title: "Ginecología",
    subtitle: "Consultas, control prenatal y atención de parto",
    image:
        "https://confiasalud.pe/wp-content/uploads/2022/05/ginecologia-1000x500.jpg",
  ),
  SpecialtyDTO(
    title: "Pediatría",
    subtitle:
        "Atención médica profesional. Los mejores especialistas médicos cuidando la salud de tu familia",
    image:
        "https://tupediatra.mx/wp-content/uploads/2019/05/pediatra-especialista.jpg",
  ),
  SpecialtyDTO(
    title: "Alergología",
    subtitle:
        "Atención médica profesional. Los mejores especialistas médicos cuidando la salud de tu familia",
    image: "https://escuelaelbs.lat/wp-content/uploads/alergologia.jpg",
  ),
  SpecialtyDTO(
    title: "Nutrición",
    subtitle:
        "Atención médica profesional. Los mejores especialistas médicos cuidando la salud de tu familia",
    image:
        "https://www.uvg.edu.mx/hubfs/Imported_Blog_Media/uvg-ramas-de-la-nutricion-1.jpg",
  ),
  SpecialtyDTO(
    title: "Medicina General",
    subtitle:
        "Atención médica profesional. Los mejores especialistas médicos cuidando la salud de tu familia",
    image:
        "https://centromedicopeninsular.com/wp-content/uploads/2020/03/service__details1.jpg",
  ),
];
