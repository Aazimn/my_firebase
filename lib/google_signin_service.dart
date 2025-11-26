import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signinwithgoogle() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      return account;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isSignIn() async {
    return await _googleSignIn.isSignedIn();
  }

  Future<GoogleSignInAccount?> logout() async {
    return await _googleSignIn.signOut();
  }
}
