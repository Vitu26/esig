import 'dart:io';
import 'package:dio/dio.dart';

// Configurações do Back4App
const String applicationId = '2NtEaOfkCHCImeh8RmHB131wpmGGz3MSrTj5PY4W';
const String clientKey = 'JDkWDaVezEtvA8kTj1nMquMnMAMKQI4nxbbbtcan';
// IMPORTANTE: Para criar usuários, você precisa do Master Key
// Obtenha em: App Settings > Security & Keys > Master key
// Substitua abaixo pela sua Master Key:
const String? masterKey = null; // Cole sua Master Key aqui se quiser criar usuários
const String baseUrl = 'https://parseapi.back4app.com';

void main() async {
  print('🚀 Configurando Back4App...\n');
  print('📝 Nota: Para criar usuários via script, você precisa configurar o Master Key.\n');
  print('   Ou crie os usuários manualmente no Back4App primeiro.\n');

  final dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {
      'X-Parse-Application-Id': applicationId,
      if (masterKey != null)
        'X-Parse-Master-Key': masterKey
      else
        'X-Parse-REST-API-Key': clientKey,
      'Content-Type': 'application/json',
    },
  ));

  try {
    // 1. Criar usuários (apenas se Master Key estiver configurado)
    if (masterKey != null) {
      print('📝 Criando usuários...');
      await createUsers(dio);
      print('✅ Usuários criados!\n');
    } else {
      print('⏭️  Pulando criação de usuários (configure Master Key para criar via script)\n');
      print('   Você pode criar usuários manualmente no Back4App ou configurar o Master Key.\n');
    }

    // 2. Criar posts de exemplo
    print('📝 Criando posts de exemplo...');
    await createSamplePosts(dio);
    print('✅ Posts criados!\n');

    print('🎉 Configuração concluída com sucesso!');
  } catch (e) {
    print('❌ Erro durante a configuração: $e');
    exit(1);
  }
}

Future<void> createUsers(Dio dio) async {
  final users = [
    {'username': 'admin', 'password': 'admin123', 'email': 'admin@esig.com'},
    {'username': 'joao', 'password': '123456', 'email': 'joao@esig.com'},
    {'username': 'maria', 'password': '123456', 'email': 'maria@esig.com'},
  ];

  for (final user in users) {
    try {
      final response = await dio.post(
        '/users',
        data: {
          'username': user['username'],
          'password': user['password'],
          'email': user['email'],
        },
      );

      if (response.statusCode == 201 || response.statusCode == 202) {
        print('  ✓ Usuário ${user['username']} criado');
      }
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 201 || statusCode == 202) {
          print('  ✓ Usuário ${user['username']} criado');
        } else if (statusCode == 400 || statusCode == 202) {
          // Usuário já existe ou erro de validação
          final errorData = e.response?.data;
          if (errorData != null && errorData.toString().contains('already')) {
            print('  ✓ Usuário ${user['username']} já existe');
          } else {
            print('  ⚠ Erro ao criar usuário ${user['username']}: ${errorData ?? e.message}');
          }
        } else {
          print('  ⚠ Erro ao criar usuário ${user['username']}: Status $statusCode');
        }
      } else {
        print('  ⚠ Erro ao criar usuário ${user['username']}: $e');
      }
    }
  }
}

Future<void> createSamplePosts(Dio dio) async {
  final posts = [
    {
      'title': 'Bem-vindo ao ESIG Social Feed!',
      'content':
          'Este é o primeiro post do aplicativo. Explore todas as funcionalidades!',
      'userId': 'admin',
      'username': 'admin',
    },
    {
      'title': 'Dicas de Flutter',
      'content':
          'Flutter é um framework incrível para desenvolvimento mobile multiplataforma.',
      'userId': 'joao',
      'username': 'joao',
    },
    {
      'title': 'Back4App é incrível!',
      'content':
          'Usar Back4App torna muito mais fácil criar backends para aplicativos mobile.',
      'userId': 'maria',
      'username': 'maria',
    },
  ];

  for (final post in posts) {
    try {
      final response = await dio.post(
        '/classes/Post',
        data: post,
      );

      if (response.statusCode == 201) {
        print('  ✓ Post "${post['title']}" criado por ${post['username']}');
      }
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 201) {
          print('  ✓ Post "${post['title']}" criado');
        } else {
          print(
              '  ⚠ Erro ao criar post "${post['title']}": ${e.response?.data ?? e.message}');
        }
      } else {
        print('  ⚠ Erro ao criar post "${post['title']}": $e');
      }
    }
  }
}

