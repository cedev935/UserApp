import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginProvider with ChangeNotifier {
  Map? userData;
  late LoginResult result;

  Future<void> login() async {
    result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
    if (result.status == LoginStatus.success) {
      userData = await FacebookAuth.instance.getUserData();

    } else {
      if (kDebugMode) {
        print(result.status);
      }
      if (kDebugMode) {
        print(result.message);
      }
    }
    notifyListeners();
  }

  logOut() async {
    await FacebookAuth.instance.logOut();
    userData = null;
    notifyListeners();
  }
}
