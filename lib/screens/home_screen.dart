import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/utilities/general_functions.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

const LatLng currentLocation = LatLng(20.988331640730305, -89.60906162570994);

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final secondColor = ThemeProvider.secondColor;
  final primaryColor = ThemeProvider.primaryColor;
  User apiUser = User.fromJson(Preferences.apiUser);

  @override
  void initState() {
    super.initState();
    final appointmentProvider = context.read<AppointmentProvider>();
    appointmentProvider.getData();
    appointmentProvider.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final oneSignalProvider = Provider.of<OneSignalProvider>(context);
    oneSignalProvider.initOneSignal(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);

    return Scaffold(
      body:appointmentProvider.isLoadingCatalogs
          ? const SkeletonHome() 
          :Column(
          children: [
            Container(
              height: 280,
              padding: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 1.0,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ],
                color: secondColor,
              ),
              child: Column(
                children: [
                  _homeGreetings(
                    apiUser: apiUser,
                  ),
                  const SizedBox(height: 20),
                  _homeButtons(profile: apiUser.miPerfil.nombre),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    (apiUser.medicalHistory == null &&
                            apiUser.miPerfil.nombre == 'Patient')
                        ? Column(
                            children: [
                              const SizedBox(height: 35),
                              DangerMessageWithButton(
                                color: ThemeProvider.blue.withOpacity(0.3),
                                title: 'Estimado Paciente',
                                paragraph1:
                                    'Su expediente clínico no está completo.',
                                paragraph2: 'Rellenar el formulario',
                                btnTitle: 'Completar mi expediente',
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 15),
                    apiUser.miPerfil.nombre == 'Doctor'
                        ? ConfirmedSection(appointments: appointmentProvider.confirmadasList)
                        : Container(),
                    const SizedBox(height: 15),
                    apiUser.miPerfil.nombre != 'Doctor'
                        ? SpecialtySlider(specialties: specialties)
                        : Container(),
                    const SizedBox(height: 15),
                    _FindUs(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      floatingActionButton: apiUser.miPerfil.nombre != 'Doctor'
          ? const FloatingMenu()
          : Container(),
    );
  }
}

class AppointmentSwiper extends StatelessWidget {
  final User apiUser;
  const AppointmentSwiper({super.key, required this.apiUser});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointments =
        appointmentProvider.confirmadasList; //Debe ser confirmadas

    return (appointments.isNotEmpty)
        ? SizedBox(
            width: double.infinity,
            height: (apiUser.miPerfil.nombre != 'Doctor') ? 270 : 230,
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
                  itemHeight: (apiUser.miPerfil.nombre != 'Doctor') ? 190 : 150,
                  layout: SwiperLayout.STACK,
                  itemBuilder: (BuildContext context, int index) {
                    return AppointmentCardDoctor(
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
                      : ThemeProvider.white,
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
                          : ThemeProvider.white,
                    ),
                  ),
                  const SizedBox(width: 7),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (profile != 'Patient')
            ? HomeActionButton(
                title: "Bienvenid@ $profile!",
                subtitle: "Programa una cita",
                backgroundColor: ThemeProvider.lightColor,
                backgroundImg: 'nurse.png',
                iconColor: ThemeProvider.white,
                icon: FontAwesomeIcons.userDoctor,
              )
            : HomeActionButton(
                title: "¡Ahorra tiempo! 👩‍⚕️",
                subtitle: "Ver horarios disponibles",
                backgroundColor: ThemeProvider.lightColor,
                backgroundImg: 'doctor.png',
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
          CreateAppointmentScreen2.routeName,
        ),
        child: Container(
          height: 130,
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              // color: ThemeProvider.secondColor,
              gradient: ThemeProvider.secondGradientColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white12,
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ]),
          child: Row(
            children: [
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
                    const SizedBox(height: 10),
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
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadeInImage(
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: AssetImage('assets/images/$backgroundImg'),
                    fit: BoxFit.contain,
                    alignment: Alignment.topRight,
                  ),
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
                  : ThemeProvider.primaryColor,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
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
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        SpecialtyDetailsScreen.routeName,
        arguments: specialty,
      ),
      child: Container(
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
      ),
    );
  }
}

class _FindUs extends StatefulWidget {
  @override
  State<_FindUs> createState() => _FindUsState();
}

class _FindUsState extends State<_FindUs> {
  late GoogleMapController mapController;

  final Map<String, Marker> _markers = {};
  bool isMapCreated = false;

  changeMapMode(){
    if(Preferences.isDarkMode){
      GeneralFunctions.getJsonFile("assets/json/dark_map.json").then(setMapStyle);
    }
  }
  
  void setMapStyle(String mapStyle){
    mapController.setMapStyle(mapStyle);
  }

  @override
  Widget build(BuildContext context) {

    if(isMapCreated){
      changeMapMode();
    }

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
                  : ThemeProvider.primaryColor,
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
                isMapCreated = true;
                changeMapMode();
                setState(() {});
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

List<SpecialtyDTO> specialties = [
  SpecialtyDTO(
      id: '1',
      title: "Ginecología",
      subtitle: "Consultas, control prenatal y atención de parto",
      image: "assets/images/specialties/image02.jpg",
      description:
          "En la Clínica Hoper, comprendemos la importancia de la salud de la mujer en todas las etapas de la vida."),
  SpecialtyDTO(
    id: '2',
    title: "Odontología",
    subtitle: "Servicio integral a nuestros pacientes",
    image: "assets/images/specialties/image01.jpg",
    description:
        "Nuestra especialidad en Odontología en la Clínica Hoper se dedica a mantener tus dientes y encías en óptimas condiciones de salud.",
  ),
  SpecialtyDTO(
      id: '3',
      title: "Pediatría",
      subtitle:
          "Los mejores especialistas médicos cuidando la salud de tus hijos",
      image: "assets/images/specialties/image03.jpg",
      description:
          "En la Clínica Hoper, comprendemos lo especial que es la salud de tus hijos. Nuestros pediatras están dedicados a brindar la mejor atención médica pediátrica disponible."),
  SpecialtyDTO(
      id: '4',
      title: "Alergología",
      subtitle: "Tratamos todo tipo de Alergias",
      image: "assets/images/specialties/image04.jpg",
      description:
          "Las alergias pueden ser desafiantes, pero en la Clínica Hoper, nuestros alergólogos están listos para ayudarte a identificar y controlar tus alergias."),
  // SpecialtyDTO(
  //     id: '5',
  //     title: "Nutrición",
  //     subtitle: "El Comienzo de la Salud",
  //     image: "assets/images/specialties/image05.jpg",
  //     description:
  //         "En la Clínica Hoper, creemos que la nutrición es fundamental para una vida saludable. Nuestros especialistas en nutrición te ayudarán a diseñar un plan alimenticio personalizado que se adapte a tus necesidades y metas.\n\nYa sea que busques perder peso, mejorar tu salud general o manejar condiciones específicas, estamos aquí para guiarte. Tu viaje hacia una alimentación más saludable comienza aquí. Solicita una consulta de nutrición hoy y da el primer paso hacia un estilo de vida más saludable. La nutrición es la base de una buena salud.\n\nSolicita una cita de nutrición ahora y comienza a transformar tu vida a través de la alimentación."),
  // SpecialtyDTO(
  //   id: 5,
  //   title: "Medicina General",
  //   subtitle: "Cuidamos la salud de tu familia",
  //   image: "assets/images/specialties/image06.jpg",
  //   description:
  //       "En la Clínica Hoper, creemos en el poder de la atención médica familiar y la medicina general como piedra angular de la salud de todos.\n\nNuestros médicos generales son el primer punto de contacto para ti y tu familia cuando se trata de cuidado de la salud. Están dedicados a brindar atención integral y continua, desde chequeos médicos de rutina hasta el manejo de enfermedades crónicas.\n\nValoramos la relación médico-paciente y nos comprometemos a cuidar de ti en todas las etapas de la vida. La salud de tu familia es nuestra prioridad número uno. En Clínica Hoper, te ofrecemos un hogar para tu atención médica familiar.\n\nSolicita una cita de medicina general hoy y experimenta el cuidado y la dedicación que mereces.",
  // ),
];
