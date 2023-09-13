import 'package:flutter/material.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/screens/screens.dart';
import 'package:hope_app/services/services.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:provider/provider.dart';

class PopupMenuList extends StatelessWidget {
  User apiUser;

  PopupMenuList({required this.apiUser});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    User apiUser = User.fromJson(Preferences.apiUser);

    return PopUpMenu(
      menuList: [
        const PopupMenuItem(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          enabled: false,
          child: Column(
            children: [
              Text(
                'Bienvenido',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 1,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('Mi perfil'),
        ),
        const PopupMenuItem(
          value: 0,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Text('Preferencias'),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Text('Logout'),
          onTap: () async {
            await authService.logout();
            print('Is Google: ${apiUser.isGoogle}');
            if (apiUser.isGoogle != 0) {
              GoogleSignInAPiService.logoutGoogle();
            }
            // ignore: use_build_context_synchronously
            // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
            Future.microtask(
              () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
            );
          },
        ),
      ],
      icon: (apiUser.image == null)
          ? const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/user-icon.png'),
            )
          : CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(apiUser.image!),
            ),
    );
  }
}

class PopUpMenu extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;

  const PopUpMenu({super.key, required this.menuList, this.icon});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(7.0),
      )),
      padding: EdgeInsets.zero,
      onSelected: (result) {
        switch (result) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          default:
        }
      },
      itemBuilder: (context) => menuList,
      child: icon,
    );
  }
}
