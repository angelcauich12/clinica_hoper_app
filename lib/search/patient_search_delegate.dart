import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hope_app/models/models.dart';
import 'package:hope_app/providers/providers.dart';
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

    return FutureBuilder(
      future: appointmentProv.searchUsers(query),
      builder: (context, AsyncSnapshot<List<User>> snapshot) {
        if (!snapshot.hasData) {
          return const emptyContainer();
        }

        final List<User> users = snapshot.data!;

        return UserSearchList(users: users);
      },
    );
  }
}

class emptyContainer extends StatelessWidget {
  const emptyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage('assets/images/searchPatient.png'),
        width: 130,
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
        final User user = users[index];
        final String initials =
            getInitials(string: '${user.name} ${user.lastName}', limitTo: 2);

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          leading: CircleAvatar(
            backgroundColor: ThemeProvider.secondColor,
            child: Text(initials),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.name} ${user.lastName}',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Tel: ',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  (user.phone != null)
                      ? Text(
                          '${user.phone}',
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : const Text('Sin Teléfono'),
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

  String getInitials({required String string, required int limitTo}) {
    var buffer = StringBuffer();
    var split = string.split(' ');
    for (var i = 0; i < (limitTo); i++) {
      if (split[i].isNotEmpty) {
        buffer.write(split[i][0]);
      }
    }

    return buffer.toString();
  }
}
