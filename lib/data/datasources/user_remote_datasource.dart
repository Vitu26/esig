import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

abstract class UserRemoteDatasource {
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

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> registerUser({
    required String username,
    required String password,
    String? email,
  }) async {
    try {
      final response = await dio.post(
        '/users',
        data: {
          'username': username,
          'password': password,
          if (email != null && email.isNotEmpty) 'email': email,
        },
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            if (ApiConstants.masterKey != null && ApiConstants.masterKey!.isNotEmpty)
              'X-Parse-Master-Key': ApiConstants.masterKey!
            else
              'X-Parse-REST-API-Key': ApiConstants.clientKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return {
            'success': true,
            'user': data,
            'objectId': data['objectId']?.toString(),
            'username': data['username']?.toString(),
          };
        }
        throw Exception('Formato de resposta inválido do servidor');
      }
      throw Exception('Failed to register user: status ${response.statusCode}');
    } catch (e) {
      if (e is DioException) {
        final errorData = e.response?.data;
        String errorMessage = 'Erro ao registrar usuário';
        
        if (errorData != null) {
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('error')) {
              final error = errorData['error'];
              if (error is String) {
                errorMessage = error;
                if (error.toLowerCase() == 'unauthorized') {
                  errorMessage = 'Não autorizado. Configure as permissões da classe _User no Back4App:\n'
                      'App Settings > Security & Keys > Class-Level Permissions > _User > Create: public';
                }
              } else if (error is Map) {
                errorMessage = error['message']?.toString() ?? error.toString();
              } else {
                errorMessage = error.toString();
              }
            } else if (errorData.containsKey('message')) {
              errorMessage = errorData['message']?.toString() ?? errorMessage;
            } else if (errorData.containsKey('code')) {
              final code = errorData['code'];
              final msg = errorData['message'] ?? errorData['error'];
              if (msg != null) {
                errorMessage = msg.toString();
              } else if (code != null) {
                errorMessage = 'Erro ${code.toString()}';
              }
            }
          } else if (errorData is String) {
            errorMessage = errorData;
            if (errorMessage.toLowerCase() == 'unauthorized' || 
                errorMessage.toLowerCase() == 'unauthorised') {
              errorMessage = 'Não autorizado. Configure as permissões da classe _User no Back4App:\n'
                  'App Settings > Security & Keys > Class-Level Permissions > _User > Create: public';
            }
          }
        }
        
        if (errorMessage.toLowerCase().contains('unauthorized') || 
            errorMessage.toLowerCase().contains('unauthorised')) {
          if (!errorMessage.contains('Configure as permissões')) {
            errorMessage = 'Não autorizado. Configure as permissões da classe _User no Back4App:\n'
                'App Settings > Security & Keys > Class-Level Permissions > _User > Create: public';
          }
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Erro ao registrar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await dio.get(
        '/login',
        queryParameters: {
          'username': username,
          'password': password,
        },
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return {
            'success': true,
            'user': data,
            'objectId': data['objectId'] as String?,
            'username': data['username'] as String?,
            'sessionToken': data['sessionToken'] as String?,
          };
        }
        throw Exception('Formato de resposta inválido do servidor');
      }
      throw Exception('Failed to login');
    } catch (e) {
      if (e is DioException) {
        final errorData = e.response?.data;
        String errorMessage = 'Usuário ou senha incorretos';
        
        if (errorData != null) {
          if (errorData is Map<String, dynamic>) {
            if (errorData.containsKey('error')) {
              final error = errorData['error'];
              if (error is String) {
                errorMessage = error;
              } else if (error is Map) {
                errorMessage = error['message']?.toString() ?? error.toString();
              } else {
                errorMessage = error.toString();
              }
            } else if (errorData.containsKey('message')) {
              errorMessage = errorData['message']?.toString() ?? errorMessage;
            } else if (errorData.containsKey('code')) {
              final code = errorData['code'];
              final msg = errorData['message'] ?? errorData['error'];
              if (msg != null) {
                errorMessage = msg.toString();
              } else if (code != null) {
                errorMessage = 'Erro ${code.toString()}';
              }
            }
          } else if (errorData is String) {
            errorMessage = errorData;
          }
        }
        
        throw Exception(errorMessage);
      }
      throw Exception('Erro ao fazer login: ${e.toString()}');
    }
  }
}

