import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
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
    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    getData(appointmentProvider);
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
            (apiUser.medicalHistory == null &&
                    apiUser.miPerfil.nombre == 'Patient')
                ? Column(
                    children: [
                      const SizedBox(height: 35),
                      DangerMessageWithButton(
                        color: ThemeProvider.blue.withOpacity(0.3),
                        title: 'Estimado Paciente',
                        paragraph1: 'Su expediente clínico no está completo.',
                        paragraph2: 'Rellenar el formulario',
                        btnTitle: 'Completar mi expediente',
                      ),
                    ],
                  )
                : Container(),
            const SizedBox(height: 25),
            _homeButtons(
                profile: apiUser.miPerfil
                    .nombre), //se envia el nombre del perfil doctor, patient, admin
            const SizedBox(height: 25),
            const AppointmentSwiper(),
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

  void getData(AppointmentProvider appointmentProvider) async {
    await appointmentProvider.getData();
    await appointmentProvider.getAppointments();
  }
}

class AppointmentSwiper extends StatelessWidget {
  const AppointmentSwiper({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments =
        appointmentProvider.confirmadasList; //Debe ser confirmadas

    return (appointments.isNotEmpty)
        ? Container(
            width: double.infinity,
            height: 270,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Text(
                    'Citas Confirmadas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      color: Preferences.isDarkMode
                          ? ThemeProvider.white
                          : ThemeProvider.brown,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Swiper(
                  itemWidth: size.width * 0.9,
                  itemHeight: 190,
                  layout: SwiperLayout.STACK,
                  itemBuilder: (BuildContext context, int index) {
                    return AppointmentCard(
                        appointment: appointments[index], withMargin: false);
                  },
                  itemCount: appointments.length,
                ),
              ],
            ),
          )
        : Container();
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
  String profile;

  _homeButtons({required this.profile});

  @override
  Widget build(BuildContext context) {
    print(profile);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (profile != 'Patient')
            ? HomeActionButton(
                title: "Bienvenid@!",
                subtitle: "Programa tu paciente para cita",
                backgroundColor: ThemeProvider.lightColor,
                backgroundImg: 'bgHospital3.png',
                iconColor: ThemeProvider.white,
                icon: FontAwesomeIcons.userDoctor,
              )
            : HomeActionButton(
                title: "¡Ahorra tiempo! 👩‍⚕️",
                subtitle: "Programa tu cita ahora",
                backgroundColor: ThemeProvider.lightColor,
                backgroundImg: 'bgHospital2.png',
                iconColor: ThemeProvider.white,
                icon: FontAwesomeIcons.handHoldingMedical,
              )
      ],
    );
  }
}

class HomeActionButton extends StatelessWidget {
  Color backgroundColor;
  String backgroundImg;
  Color iconColor;
  String subtitle;
  String title;
  IconData icon;

  HomeActionButton({
    super.key,
    required this.backgroundColor,
    required this.backgroundImg,
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
          height: 180,
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              // color: ThemeProvider.secondColor,
              gradient: ThemeProvider.secondGradientColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  spreadRadius: 4,
                ),
              ]),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage(
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: const AssetImage('assets/loading.gif'),
                  image: AssetImage('assets/images/$backgroundImg'),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-2.0, 2.0),
                              blurRadius: 5,
                              color: ThemeProvider.brown,
                            ),
                          ]),
                      child: Icon(
                        icon,
                        color: backgroundColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 22,
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(-2.0, 2.0),
                              blurRadius: 5,
                              color: ThemeProvider.brown,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        shadows: [
                          Shadow(
                            offset: const Offset(-2.0, 2.0),
                            blurRadius: 5,
                            color: ThemeProvider.brown,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
              fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(5),
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
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage(
                width: double.infinity,
                height: double.infinity,
                placeholder: const AssetImage('assets/loading.gif'),
                image: AssetImage(specialty.image!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(5),
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
                    style: TextStyle(
                      fontSize: 32.0,
                      color: ThemeProvider.darkColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(
                          offset: const Offset(3.0, 3.0),
                          blurRadius: 7.5,
                          color: ThemeProvider.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialty.subtitle!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: ThemeProvider.darkColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibreBaskerville',
                        shadows: [
                          Shadow(
                            offset: const Offset(2.0, 2.0),
                            blurRadius: 10.0,
                            color: ThemeProvider.white,
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
              fontWeight: FontWeight.w600,
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
    subtitle: "Servicio integral a nuestros pacientes",
    image: "assets/images/specialties/image01.jpg",
  ),
  SpecialtyDTO(
    title: "Ginecología",
    subtitle: "Consultas, control prenatal y atención de parto",
    image: "assets/images/specialties/image02.jpg",
  ),
  SpecialtyDTO(
    title: "Pediatría",
    subtitle:
        "Los mejores especialistas médicos cuidando la salud de tus hijos",
    image: "assets/images/specialties/image03.jpg",
  ),
  SpecialtyDTO(
    title: "Alergología",
    subtitle: "Tratamos todo tipo de Alergias",
    image: "assets/images/specialties/image04.jpg",
  ),
  SpecialtyDTO(
    title: "Nutrición",
    subtitle: "El Comienzo de la Salud",
    image: "assets/images/specialties/image05.jpg",
  ),
  SpecialtyDTO(
    title: "Medicina General",
    subtitle: "Cuidamos la salud de tu familia",
    image: "assets/images/specialties/image06.jpg",
  ),
];
