import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/auth_validator.dart';
import '../../domain/repositories/user_repository.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final UserRepository? userRepository;

  _AuthStore(this.userRepository);

  @observable
  bool isLoggedIn = false;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  String? currentUsername;

  @observable
  String? currentUserId;
  
  @observable
  String? sessionToken;

  @action
  Future<void> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;

    try {
      if (AuthValidator.validateCredentials(username, password)) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.isLoggedInKey, true);
        await prefs.setString(AppConstants.usernameKey, username);
        isLoggedIn = true;
        currentUsername = username;
        currentUserId = username;
      } else {
        errorMessage = 'Usuário ou senha incorretos';
        isLoggedIn = false;
        currentUsername = null;
        currentUserId = null;
      }
    } catch (e) {
      errorMessage = 'Erro ao fazer login: $e';
      isLoggedIn = false;
    } finally {
      isLoading = false;
    }
  }
  
  @action
  Future<void> register({
    required String username,
    required String password,
    String? email,
  }) async {
    isLoading = true;
    errorMessage = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.isLoggedInKey, true);
      await prefs.setString(AppConstants.usernameKey, username);
      
      isLoggedIn = true;
      currentUsername = username;
      currentUserId = username;
    } catch (e) {
      String message = e.toString();
      if (message.startsWith('Exception: ')) {
        message = message.substring('Exception: '.length);
      }
      errorMessage = message;
      isLoggedIn = false;
      currentUsername = null;
      currentUserId = null;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.isLoggedInKey, false);
      await prefs.remove(AppConstants.usernameKey);
      isLoggedIn = false;
      currentUsername = null;
      currentUserId = null;
      sessionToken = null;
    } catch (e) {
      errorMessage = 'Erro ao fazer logout: $e';
    }
  }

  @action
  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
      if (isLoggedIn) {
        currentUsername = prefs.getString(AppConstants.usernameKey);
        currentUserId = currentUsername;
      }
    } catch (e) {
      isLoggedIn = false;
      currentUsername = null;
      currentUserId = null;
    }
  }
}

