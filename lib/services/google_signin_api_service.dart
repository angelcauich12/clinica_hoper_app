import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAPi extends ChangeNotifier {
  static final _googlSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googlSignIn.signIn();
  static Future<GoogleSignInAccount?> logout() => _googlSignIn.disconnect();
}
