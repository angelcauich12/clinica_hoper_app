import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final User apiUser = User.fromJson(Preferences.apiUser);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade800,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Mi Perfil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Preferences.isDarkMode
                ? ThemeProvider.white
                : ThemeProvider.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const CircleAvatar(
                //   radius: 70,
                //   backgroundImage: AssetImage('assets/user1.png'),
                // ),
                (apiUser.image == null)
                    ? const CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            AssetImage('assets/images/user-icon.png'),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage(
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          placeholder: const AssetImage('assets/loading.gif'),
                          image: NetworkImage(apiUser.image!),
                        ),
                      ),
                const SizedBox(height: 20),
                Text(
                  getCapitalizedString(
                      str: '${apiUser.name} ${apiUser.lastName}'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    letterSpacing: 1.5,
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Anton",
                  ),
                ),
                Text(
                  apiUser.miPerfil.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
                const SizedBox(
                  height: 20,
                  child: Divider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                ),
                Text(
                  apiUser.email,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                    fontFamily: "Barlow",
                  ),
                ),
                // Text(
                //   Preferences.licenseExp,
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     overflow: TextOverflow.ellipsis,
                //     fontSize: 25,
                //     fontWeight: FontWeight.normal,
                //     color: Colors.white,
                //     fontFamily: "Barlow",
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String getCapitalizedString({required String str}) {
  if (str.length <= 1) {
    return str.toUpperCase();
  }
  return '${str[0].toUpperCase()}${str.substring(1)}';
}
