import 'package:flutter/material.dart';
import 'package:hope_app/providers/providers.dart';
import 'package:hope_app/shared/preferences.dart';
import 'package:hope_app/ui/input_decorations.dart';
import 'package:hope_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicalRecordsScreen extends StatefulWidget {
  static const String routeName = 'medical-records';

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  final TextEditingController _dateController = TextEditingController();
  final _pageController = PageController();

  int _activePage = 0;

  final List<Widget> _pages = [
    const MedRecordsForm1(),
    const MedRecordsForm2(),
    const MedRecordsForm3(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _dateController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Historial Clínico',
            image: 'assets/images/modules/medicalRecords.jpg',
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: size.height - 200,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _activePage = page;
                          });
                        },
                        itemCount: _pages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _pages[index % _pages.length];
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          // color: Colors.black38,
                          child: PageControlButtons(
                            size: size,
                            activePage: _activePage,
                            pageController: _pageController,
                            pages: _pages,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PageControlButtons extends StatelessWidget {
  const PageControlButtons({
    super.key,
    required this.size,
    required int activePage,
    required PageController pageController,
    required List<Widget> pages,
  })  : _activePage = activePage,
        _pageController = pageController,
        _pages = pages;

  final Size size;
  final int _activePage;
  final PageController _pageController;
  final List<Widget> _pages;

  @override
  Widget build(BuildContext context) {
    final medRecordsForm1 = Provider.of<MedRecordsForm1Provider>(context);
    final medRecordsForm2 = Provider.of<MedRecordsForm2Provider>(context);
    final medRecordsForm3 = Provider.of<MedRecordsForm3Provider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            fixedSize: Size((size.width / 3), 50),
            foregroundColor: Colors.white,
            backgroundColor: Colors.teal,
            disabledForegroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
          ),
          onPressed: (_activePage == 0)
              ? null
              : () {
                  print('activePage $_activePage');

                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
          child: const Text('Anterior'),
        ),
        const SizedBox(width: 15),
        (_activePage == _pages.length - 1)
            ? TextButton(
                style: TextButton.styleFrom(
                  fixedSize: Size((size.width / 3), 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  if (_activePage == 2 && !medRecordsForm3.isValidForm())
                    return;

                  print('Enviar Formulario!!!');
                },
                child: const Text(' Guardar '),
              )
            : TextButton(
                style: TextButton.styleFrom(
                  fixedSize: Size((size.width / 3), 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.teal,
                  elevation: 5,
                  shadowColor: Colors.black87,
                ),
                onPressed: () {
                  print('activePage $_activePage');
                  if (_activePage == 0 && !medRecordsForm1.isValidForm())
                    return;
                  if (_activePage == 1 && !medRecordsForm2.isValidForm())
                    return;

                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                child: const Text('Siguiente'),
              ),
      ],
    );
  }
}

class MedRecordsForm1 extends StatelessWidget {
  const MedRecordsForm1({super.key});

  @override
  Widget build(BuildContext context) {
    final medRecordsForm1 = Provider.of<MedRecordsForm1Provider>(context);
    final Color myColor = ThemeProvider.secondColor;
    final TextEditingController dateController = TextEditingController();
    dateController.text = medRecordsForm1.birthday;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Form(
        key: medRecordsForm1.form1Key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    'Género',
                    style: TextStyle(
                      fontSize: 14,
                      color: myColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    alignment: Alignment.center,
                    hint: const Text(
                      'Selecciona...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    isExpanded: false,
                    value: medRecordsForm1.gender,
                    items: const [
                      DropdownMenuItem(
                          value: 'F',
                          alignment: AlignmentDirectional.center,
                          child: Text('Femenino')),
                      DropdownMenuItem(
                          value: 'M',
                          alignment: AlignmentDirectional.center,
                          child: Text('Masculino')),
                      DropdownMenuItem(
                          value: 'O',
                          alignment: AlignmentDirectional.center,
                          child: Text('Otro')),
                    ],
                    onChanged: (value) => medRecordsForm1.gender = value!,
                    validator: (value) {
                      return (value != null) ? null : 'Debe elegir un genero.';
                    },
                  ),
                ),
              ],
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: dateController,
              readOnly: true,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: '10-04-1979',
                  labelText: 'F. Nacimiento',
                  suffixIcon: Icons.calendar_month_outlined),
              textAlign: TextAlign.center,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2025),
                );

                if (selectedDate == null) return; //if Cancel

                var formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                print('si Se pudo ${formattedDate.toString()}');
                medRecordsForm1.birthday = formattedDate;
                dateController.text = formattedDate;
              },
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Debe elegir una fecha válida.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm1.ocupation,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'A que se dedica el paciente.',
                  labelText: 'Ocupación',
                  suffixIcon: Icons.work_outline_sharp),
              onChanged: (value) => medRecordsForm1.ocupation = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Ocupación debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm1.maritalStatus,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'casado/soltero/divorciado/viudo',
                  labelText: 'Estado Civil',
                  suffixIcon: Icons.people_alt_outlined),
              onChanged: (value) => medRecordsForm1.maritalStatus = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Estado civil debe contener más de 3 caracteres.';
              },
            ),
            TextFormField(
              initialValue: medRecordsForm1.address,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'Escriba su Dirección',
                  labelText: 'Dirección',
                  suffixIcon: Icons.person_pin_outlined),
              onChanged: (value) => medRecordsForm1.address = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Dirección debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm1.phone,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'Teléfono del paciente',
                  labelText: 'Teléfono',
                  suffixIcon: Icons.phone_enabled_outlined),
              onChanged: (value) => medRecordsForm1.phone = value,
              validator: (value) {
                return (value != null && value.length == 10)
                    ? null
                    : 'Teléfono deben ser 10 números.';
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MedRecordsForm2 extends StatelessWidget {
  const MedRecordsForm2({super.key});

// address
// state
// city
// postalCode
// celPhone
// contactSchedule

  @override
  Widget build(BuildContext context) {
    final medRecordsForm2 = Provider.of<MedRecordsForm2Provider>(context);
    final Color myColor = ThemeProvider.secondColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Form(
        key: medRecordsForm2.form2Key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    'Estado',
                    style: TextStyle(
                      fontSize: 14,
                      color: myColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    alignment: Alignment.center,
                    hint: const Text(
                      'Selecciona...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    isExpanded: false,
                    value: medRecordsForm2.state,
                    items: const [
                      DropdownMenuItem(
                          value: 'YUC',
                          alignment: AlignmentDirectional.center,
                          child: Text('Yucatan')),
                      DropdownMenuItem(
                          value: 'CAMP',
                          alignment: AlignmentDirectional.center,
                          child: Text('Campeche')),
                      DropdownMenuItem(
                          value: 'QROO',
                          alignment: AlignmentDirectional.center,
                          child: Text('QuintanaRoo')),
                    ],
                    onChanged: (value) => medRecordsForm2.state = value!,
                    validator: (value) {
                      return (value != null) ? null : 'Debe elegir un estado.';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    'Ciudad',
                    style: TextStyle(
                      fontSize: 14,
                      color: myColor,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: DropdownButtonFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                    alignment: Alignment.center,
                    hint: const Text(
                      'Selecciona...',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    isExpanded: false,
                    value: medRecordsForm2.city,
                    items: const [
                      DropdownMenuItem(
                          value: 'MER',
                          alignment: AlignmentDirectional.center,
                          child: Text('Merida')),
                      DropdownMenuItem(
                          value: 'CAMP',
                          alignment: AlignmentDirectional.center,
                          child: Text('Campeche')),
                      DropdownMenuItem(
                          value: 'CUN',
                          alignment: AlignmentDirectional.center,
                          child: Text('Cancun')),
                    ],
                    onChanged: (value) => medRecordsForm2.city = value!,
                    validator: (value) {
                      return (value != null) ? null : 'Debe elegir un estado.';
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm2.contactSchedule,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'Horario en que podemos llamarle',
                  labelText: 'Horario de contacto',
                  suffixIcon: Icons.calendar_month_outlined),
              onChanged: (value) => medRecordsForm2.contactSchedule = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Horario debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm2.contactName,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'John Doe',
                  labelText: 'Contacto de Emergencia',
                  suffixIcon: Icons.person_pin_outlined),
              onChanged: (value) => medRecordsForm2.contactName = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'Contacto debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              initialValue: medRecordsForm2.contactPhone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'XXXX-XXXXXX',
                  labelText: 'Teléfono de Contacto',
                  suffixIcon: Icons.phone_android_outlined),
              onChanged: (value) => medRecordsForm2.contactPhone = value,
              validator: (value) {
                return (value != null && value.length >= 10)
                    ? null
                    : 'Contacto debe contener 10 numeros.';
              },
            ),
            TextFormField(
              initialValue: medRecordsForm2.relationship,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(
                  color: myColor,
                  hintText: 'Parentesco',
                  labelText: 'Parentesco',
                  suffixIcon: Icons.supervised_user_circle_outlined),
              onChanged: (value) => medRecordsForm2.relationship = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'El Parentesco debe contener más de 3 caracteres.';
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class MedRecordsForm3 extends StatelessWidget {
  const MedRecordsForm3({super.key});

  @override
  Widget build(BuildContext context) {
    final medRecordsForm3 = Provider.of<MedRecordsForm3Provider>(context);
    final Color myColor = ThemeProvider.secondColor;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Form(
          key: medRecordsForm3.form3Key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SwitchFormFields(
                  myColor: myColor, medRecordsForm3: medRecordsForm3),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchFormFields extends StatelessWidget {
  const SwitchFormFields({
    super.key,
    required this.myColor,
    required this.medRecordsForm3,
  });

  final Color myColor;
  final MedRecordsForm3Provider medRecordsForm3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Toma Medicamentos',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.tomaMedicamentos,
                  onChanged: (value) {
                    medRecordsForm3.tomaMedicamentos = value;
                    print(
                        'Swtich Value tomaMedicamentos ${medRecordsForm3.tomaMedicamentos}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alergias',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.alergias,
                  onChanged: (value) {
                    medRecordsForm3.alergias = value;
                    print('Swtich Value alergias ${medRecordsForm3.alergias}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cardiopatías',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.cardiopatias,
                  onChanged: (value) {
                    medRecordsForm3.cardiopatias = value;
                    print(
                        'Swtich Value cardiopatias ${medRecordsForm3.cardiopatias}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Coagulopatías',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.cuagulopatias,
                  onChanged: (value) {
                    medRecordsForm3.cuagulopatias = value;
                    print(
                        'Swtich Value cuagulopatias ${medRecordsForm3.cuagulopatias}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Presión Arterial',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.alteracionPresionArterial,
                  onChanged: (value) {
                    medRecordsForm3.alteracionPresionArterial = value;
                    print(
                        'Swtich Value alteracionPresionArterial ${medRecordsForm3.alteracionPresionArterial}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Embarazo',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.embarazo,
                  onChanged: (value) {
                    medRecordsForm3.embarazo = value;
                    print('Swtich Value embarazo ${medRecordsForm3.embarazo}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Diabetes',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.diabetes,
                  onChanged: (value) {
                    medRecordsForm3.diabetes = value;
                    print('Swtich Value diabetes ${medRecordsForm3.diabetes}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hepatitis',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.hepatitis,
                  onChanged: (value) {
                    medRecordsForm3.hepatitis = value;
                    print(
                        'Swtich Value hepatitis ${medRecordsForm3.hepatitis}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fiebre Reumática',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.fiebreReumatica,
                  onChanged: (value) {
                    medRecordsForm3.fiebreReumatica = value;
                    print(
                        'Swtich Value fiebreReumatica ${medRecordsForm3.fiebreReumatica}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fuma',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.fuma,
                  onChanged: (value) {
                    medRecordsForm3.fuma = value;
                    print('Swtich Value fuma ${medRecordsForm3.fuma}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inmunosupresión',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.inmunosupresion,
                  onChanged: (value) {
                    medRecordsForm3.inmunosupresion = value;
                    print(
                        'Swtich Value inmunosupresion ${medRecordsForm3.inmunosupresion}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bebe Alcohol',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.bebeAlcohol,
                  onChanged: (value) {
                    medRecordsForm3.bebeAlcohol = value;
                    print(
                        'Swtich Value bebeAlcohol ${medRecordsForm3.bebeAlcohol}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trastornos Gástricos',
                  style: TextStyle(
                    fontSize: 14,
                    color: myColor,
                  ),
                ),
                Switch(
                  value: medRecordsForm3.trastornosGastricos,
                  onChanged: (value) {
                    medRecordsForm3.trastornosGastricos = value;
                    print(
                        'Swtich Value trastornosGastricos ${medRecordsForm3.trastornosGastricos}');
                  },
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Epilepsia',
                      style: TextStyle(
                        fontSize: 14,
                        color: myColor,
                      ),
                    ),
                    Switch(
                      value: medRecordsForm3.epilepsia,
                      onChanged: (value) {
                        medRecordsForm3.epilepsia = value;
                        print(
                            'Swtich Value epilepsia ${medRecordsForm3.epilepsia}');
                      },
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enfermedades Renales',
              style: TextStyle(
                fontSize: 14,
                color: myColor,
              ),
            ),
            Switch(
              value: medRecordsForm3.enfermedadesRenales,
              onChanged: (value) {
                medRecordsForm3.enfermedadesRenales = value;
                print(
                    'Swtich Value enfermedadesRenales ${medRecordsForm3.enfermedadesRenales}');
              },
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Trastornos Respiratorios',
              style: TextStyle(
                fontSize: 14,
                color: myColor,
              ),
            ),
            Switch(
              value: medRecordsForm3.trastornosRespiratorios,
              onChanged: (value) {
                medRecordsForm3.trastornosRespiratorios = value;
                print(
                    'Swtich Value trastornosRespiratorios ${medRecordsForm3.trastornosRespiratorios}');
              },
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
