import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';


class FloatingMenu extends StatelessWidget {
  const FloatingMenu({
    super.key,
  });

 
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        _callNumber('+52','9991089659');
      },
      child: const Icon(
        Icons.phone_enabled_outlined,
        size: 25,
      ),
    );


    
  }
  _callNumber(String lada, String number ) async{
   await FlutterPhoneDirectCaller.callNumber('$lada $number');
}
}
