import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({
    required this.remoteDatasource,
  });

  @override
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String password,
    String? email,
  }) async {
    try {
      return await remoteDatasource.registerUser(
        username: username,
        password: password,
        email: email,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      return await remoteDatasource.loginUser(
        username: username,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}

