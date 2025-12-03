import '../constants/app_constants.dart';

class AuthValidator {
  static bool validateCredentials(String username, String password) {
    return username == AppConstants.defaultUsername &&
        password == AppConstants.defaultPassword;
  }
}

