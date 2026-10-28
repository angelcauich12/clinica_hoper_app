
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import '../ui/input_decorations.dart';

class DevMode extends StatefulWidget {
  const DevMode({
    super.key,
  });

  @override
  State<DevMode> createState() => _DevModeState();
}

class _DevModeState extends State<DevMode> {
  @override
  Widget build(BuildContext context) {
     String apiServer = Preferences.apiServer;
     String projectName = Preferences.projectName;
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.30,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: const AssetImage(
                              'assets/images/brand/devimage.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.9),
                            BlendMode.modulate,
                          ))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.14),
                  child: const Center(
                    child: Text(
                      'Modo Desarrollador',
                      style: TextStyle(
                          shadows: [
                            BoxShadow(
                              offset: Offset(10.0, 10.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(100, 0, 0, 0),
                            ),
                          ],
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: size.height * 0.27),
                    child: Center(
                      child: ElevatedButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.teal,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Salir'),
                              Icon(Icons.arrow_back_sharp)
                            ],
                          ),
                          onPressed: () => Navigator.pop(context)),
                    )),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 4,
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: size.width,
              height: size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Preferencias de usuario',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ThemeProvider.secondColor,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Servidor',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            color: ThemeProvider.primaryColor,
                            fontSize: 17),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) => Preferences.apiServer = value,
                    initialValue: apiServer,
                    decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Ingresa el servidor',
                      prefixIcon: Icons.wifi_tethering,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre del proyecto',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: ThemeProvider.primaryColor,
                              fontSize: 17),
                        )
                      ]),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    onChanged: (value) => Preferences.projectName = value,
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    initialValue: projectName,
                    decoration: InputDecorations.authInputDecoration(
                      color: Colors.grey[350]!,
                      hintText: 'Ingresa el nombre del proyecto',
                      prefixIcon: FontAwesomeIcons.connectdevelop,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Https',
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              color: ThemeProvider.primaryColor,
                              fontSize: 17),
                        )
                      ]),
                 const SizedBox(
                    height: 15,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Switch(
                      activeColor: Colors.blue.shade100,
                      activeTrackColor: Colors.blue,
                      value: Preferences.isHttps,
                      onChanged: (bool value) {
                        Preferences.isHttps = value;
                        setState(() {});
                    },
                    ),
                  ],
                ),
                  // MaterialButton(
                  //   onPressed: () {},
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(4)),
                  //   disabledColor: Colors.grey,
                  //   elevation: 0,
                  //   color: Colors.teal,
                  //   minWidth: double.infinity,
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 15, vertical: 15),
                  //     child: Text(
                  //       'Guardar',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontFamily: 'Roboto',
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
