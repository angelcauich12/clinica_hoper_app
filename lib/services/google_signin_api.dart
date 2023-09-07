import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAPi {
  static final _googlSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googlSignIn.signIn();
}
