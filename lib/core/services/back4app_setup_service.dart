import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class Back4AppSetupService {
  final Dio dio;

  Back4AppSetupService(this.dio);

  Future<Map<String, dynamic>> createSamplePosts() async {
    final results = {
      'success': <String>[],
      'errors': <String>[],
    };

    final posts = [
      {
        'title': 'Bem-vindo ao ESIG Social Feed!',
        'content':
            'Este é o primeiro post do aplicativo. Explore todas as funcionalidades e crie seus próprios posts!',
        'userId': 'admin',
        'username': 'admin',
      },
      {
        'title': 'Dicas de Flutter',
        'content':
            'Flutter é um framework incrível para desenvolvimento mobile multiplataforma. Permite criar apps nativos para iOS, Android, Web e Desktop com um único código.',
        'userId': 'admin',
        'username': 'admin',
      },
      {
        'title': 'Back4App é incrível!',
        'content':
            'Usar Back4App torna muito mais fácil criar backends para aplicativos mobile. Não precisa configurar servidores ou gerenciar infraestrutura.',
        'userId': 'admin',
        'username': 'admin',
      },
    ];

    for (final post in posts) {
      try {
        final response = await dio.post(
          ApiConstants.postsEndpoint,
          data: post,
          options: Options(
            headers: {
              'X-Parse-Application-Id': ApiConstants.applicationId,
              'X-Parse-REST-API-Key': ApiConstants.clientKey,
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 201) {
          results['success']!.add('Post "${post['title']}" criado');
        }
      } catch (e) {
        if (e is DioException) {
          final statusCode = e.response?.statusCode;
          if (statusCode == 201) {
            results['success']!.add('Post "${post['title']}" criado');
          } else {
            final errorMsg = e.response?.data?['error'] ?? e.message ?? 'Erro desconhecido';
            results['errors']!.add('Post "${post['title']}": $errorMsg');
          }
        } else {
          results['errors']!.add('Post "${post['title']}": $e');
        }
      }
    }

    return results;
  }

  Future<bool> verifyPostClass() async {
    try {
      final response = await dio.get(
        ApiConstants.postsEndpoint,
        options: Options(
          headers: {
            'X-Parse-Application-Id': ApiConstants.applicationId,
            'X-Parse-REST-API-Key': ApiConstants.clientKey,
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

