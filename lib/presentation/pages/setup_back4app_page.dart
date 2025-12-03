import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../core/services/back4app_setup_service.dart';

class SetupBack4AppPage extends StatefulWidget {
  const SetupBack4AppPage({super.key});

  @override
  State<SetupBack4AppPage> createState() => _SetupBack4AppPageState();
}

class _SetupBack4AppPageState extends State<SetupBack4AppPage> {
  final _setupService = Back4AppSetupService(ServiceLocator().dio);
  bool _isLoading = false;
  String? _message;
  bool _isSuccess = false;
  List<String> _successList = [];
  List<String> _errorList = [];

  Future<void> _createSamplePosts() async {
    setState(() {
      _isLoading = true;
      _message = null;
      _isSuccess = false;
      _successList = [];
      _errorList = [];
    });

    try {
      final canConnect = await _setupService.verifyPostClass();
      
      if (!canConnect) {
        setState(() {
          _isLoading = false;
          _message = 'Erro: Não foi possível conectar ao Back4App. Verifique suas credenciais e se a classe Post foi criada.';
          _isSuccess = false;
        });
        return;
      }

      final results = await _setupService.createSamplePosts();

      setState(() {
        _isLoading = false;
        _successList = results['success'] as List<String>;
        _errorList = results['errors'] as List<String>;
        
        if (_errorList.isEmpty) {
          _message = '✅ ${_successList.length} posts criados com sucesso!';
          _isSuccess = true;
        } else if (_successList.isNotEmpty) {
          _message = '⚠️ Alguns posts foram criados, mas houve erros.';
          _isSuccess = false;
        } else {
          _message = '❌ Erro ao criar posts. Verifique as configurações.';
          _isSuccess = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Erro: $e';
        _isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Back4App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Criar Posts de Exemplo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Este botão cria posts de exemplo no Back4App automaticamente.',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _createSamplePosts,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.cloud_upload),
                      label: Text(_isLoading ? 'Criando...' : 'Criar Posts de Exemplo'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_message != null)
              Card(
                color: _isSuccess ? Colors.green[50] : Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _message!,
                        style: TextStyle(
                          color: _isSuccess ? Colors.green[800] : Colors.orange[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (_successList.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Posts criados:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._successList.map((msg) => Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, size: 16, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      msg,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                      if (_errorList.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Erros:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._errorList.map((msg) => Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.error, size: 16, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      msg,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📋 Checklist de Configuração',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildChecklistItem(
                      'Classe Post criada no Back4App',
                      Icons.check_circle_outline,
                    ),
                    _buildChecklistItem(
                      'Campos Title, content, imageUrl adicionados',
                      Icons.check_circle_outline,
                    ),
                    _buildChecklistItem(
                      'Campos userId e username adicionados',
                      Icons.check_circle_outline,
                    ),
                    _buildChecklistItem(
                      'Permissões da classe Post configuradas (public)',
                      Icons.check_circle_outline,
                    ),
                    _buildChecklistItem(
                      'Credenciais configuradas no código',
                      Icons.check_circle_outline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

