abstract class UserRepository {
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String password,
    String? email,
  });
  
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  });
}

