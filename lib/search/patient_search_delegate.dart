import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/notifications.dart';
import 'package:provider/provider.dart';

class PatientSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar Paciente';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return const Text('Build Results!!');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final appointmentProv =
        Provider.of<AppointmentProvider>(context, listen: false);

    if (query.isEmpty) {
      return const emptyContainer();
    }

    appointmentProv.getUsersByQuery(query);

    // return FutureBuilder(
    return StreamBuilder(
      // future: appointmentProv.searchUsers(query),
      stream: appointmentProv.userStream,
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return const emptyContainer();
        }

        final List<User> users = snapshot.data!;

        return (users.isEmpty)
            ? emptyContainer(resultCount: users)
            : UserSearchList(users: users);
      },
    );
  }
}

class emptyContainer extends StatelessWidget {
  final resultCount;
  const emptyContainer({super.key, this.resultCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/images/searchPatient.png'),
            width: 130,
          ),
          const SizedBox(height: 15),
          (resultCount != null)
              ? Text(
                  'Sin resultados de búsqueda.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 15),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.green[400],
                ),
                foregroundColor: MaterialStateProperty.all(
                  ThemeProvider.white,
                ),
              ),
              onPressed: () {
                Notifications.showSnackBar(
                    'Aquí se mostrará un modal para dar de alta un usuario y agregarlo a la creación de la cita.');
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Agregar Paciente',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 10),
                  FaIcon(
                    FontAwesomeIcons.userPlus,
                    size: 16,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

class UserSearchList extends StatelessWidget {
  final List<User> users;
  const UserSearchList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final appointmentProv = Provider.of<AppointmentProvider>(context);
    final appointmentForm = Provider.of<AppointmentProvider>(context);

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (BuildContext context, int index) {
        final size = MediaQuery.of(context).size;
        final User user = users[index];
        final String initials = Preferences.getInitials(
          string: '${user.name} ${user.lastName}',
          limitTo: 2,
        );

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: ThemeProvider.secondColor,
            child: Text(initials),
          ),
          horizontalTitleGap: 10,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.55,
                        child: Text(
                          '${user.name} ${user.lastName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Preferences.isDarkMode
                                ? ThemeProvider.white
                                : ThemeProvider.lightColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "${user.phone}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                              color: Preferences.isDarkMode
                                  ? Colors.grey
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              (users[index].medicalHistory != null)
                  ? TextButton(
                      onPressed: () => {
                        Notifications.showSnackBar(
                            'Se mostrará el historial del Paciente en un modal')
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(75, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center),
                      child: const Text('H.Clínica'),
                    )
                  : TextButton(
                      onPressed: null,
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(85, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center),
                      child: const Text(
                        'Sin Historia',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
            ],
          ),
          trailing: IconButton(
            padding: EdgeInsets.zero,
            icon: FaIcon(
              FontAwesomeIcons.personCirclePlus,
              color: ThemeProvider.secondColor,
              size: 32,
            ),
            onPressed: () {
              appointmentForm.patientFullName = '${user.name} ${user.lastName}';
              appointmentProv.patientSelected = user.id.toString();
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
