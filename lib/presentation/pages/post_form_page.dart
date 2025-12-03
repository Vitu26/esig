import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/di/service_locator.dart';
import '../../core/utils/file_helper.dart';
import '../../core/utils/image_file_helper.dart';
import '../../domain/entities/post.dart';

class PostFormPage extends StatefulWidget {
  final Post? post;

  const PostFormPage({
    super.key,
    this.post,
  });

  @override
  State<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends State<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _postStore = ServiceLocator().postStore;
  final _authStore = ServiceLocator().authStore;
  final _imagePickerService = ServiceLocator().imagePickerService;

  dynamic _selectedImage; // io.File no mobile, null no web
  XFile? _selectedXFile;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;
  bool _isLoadingImage = false;

  bool get isEditing => widget.post != null;


  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.post!.title;
      _contentController.text = widget.post!.content;
      _imageUrl = widget.post!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromCamera() async {
    try {
      setState(() => _isLoadingImage = true);
      if (kIsWeb) {
        final xFile = await _imagePickerService.pickXFileFromCamera();
        if (xFile != null) {
          final bytes = await xFile.readAsBytes();
          setState(() {
            _selectedXFile = xFile;
            _selectedImageBytes = bytes;
            _selectedImage = null;
            _imageUrl = null;
          });
        }
      } else {
        final image = await _imagePickerService.pickImageFromCamera();
        if (image != null) {
          setState(() {
            _selectedImage = image;
            _selectedXFile = null;
            _selectedImageBytes = null;
            _imageUrl = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingImage = false);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      setState(() => _isLoadingImage = true);
      if (kIsWeb) {
        final xFile = await _imagePickerService.pickXFileFromGallery();
        if (xFile != null) {
          final bytes = await xFile.readAsBytes();
          setState(() {
            _selectedXFile = xFile;
            _selectedImageBytes = bytes;
            _selectedImage = null;
            _imageUrl = null;
          });
        }
      } else {
        final image = await _imagePickerService.pickImageFromGallery();
        if (image != null) {
          setState(() {
            _selectedImage = image;
            _selectedXFile = null;
            _selectedImageBytes = null;
            _imageUrl = null;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoadingImage = false);
    }
  }

  Future<void> _showImageSourceDialog() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Imagem'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Câmera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      if (source == ImageSource.camera) {
        await _pickImageFromCamera();
      } else {
        await _pickImageFromGallery();
      }
    }
  }

  Future<void> _savePost() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;
      if (kIsWeb) {
        imageUrl = _selectedXFile?.path ?? _imageUrl;
      } else {
        if (_selectedXFile != null) {
          imageUrl = _selectedXFile!.path;
        } else if (_selectedImage != null) {
          imageUrl = getFilePath(_selectedImage);
        } else {
          imageUrl = _imageUrl;
        }
      }
      
      if (isEditing) {
        await _postStore.updatePost(
          objectId: widget.post!.objectId!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: imageUrl,
          userId: widget.post!.userId ?? _authStore.currentUserId,
          username: widget.post!.username ?? _authStore.currentUsername,
        );
      } else {
        await _postStore.createPost(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          imageUrl: imageUrl,
          userId: _authStore.currentUserId,
          username: _authStore.currentUsername,
        );
      }

      if (mounted) {
        if (_postStore.errorMessage == null) {
          Navigator.of(context).pop(true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing
                    ? 'Post atualizado com sucesso'
                    : 'Post criado com sucesso',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_postStore.errorMessage ?? 'Erro desconhecido'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Post' : 'Novo Post'),
      ),
      body: Observer(
        builder: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira um título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Conteúdo',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, insira o conteúdo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Imagem',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isLoadingImage ? null : _showImageSourceDialog,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _isLoadingImage
                        ? const Center(child: CircularProgressIndicator())
                        : _selectedImageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  _selectedImageBytes!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                        : !kIsWeb && _selectedImage != null
                            ? _buildSelectedImageFile()
                        : _imageUrl != null && _imageUrl!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _imageUrl!.startsWith('http') ||
                                        _imageUrl!.startsWith('data:') ||
                                        kIsWeb
                                    ? Image.network(
                                        _imageUrl!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                _buildImagePlaceholder(),
                                      )
                                    : (!kIsWeb && _imageUrl != null)
                                        ? _buildFileImage(_imageUrl!)
                                        : _buildImagePlaceholder(),
                              )
                            : _buildImagePlaceholder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed:
                      _postStore.isLoading ? null : _savePost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _postStore.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          isEditing ? 'Atualizar' : 'Criar',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImageFile() {
    if (kIsWeb || _selectedImage == null) {
      return _buildImagePlaceholder();
    }
    final imageWidget = buildImageFileWidget(
      _selectedImage!,
      fit: BoxFit.cover,
      width: double.infinity,
    );
    if (imageWidget == null) {
      return _buildImagePlaceholder();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    );
  }

  Widget _buildFileImage(String path) {
    if (kIsWeb) {
      return _buildImagePlaceholder();
    }
    final file = createFileFromPath(path);
    if (file == null) {
      return _buildImagePlaceholder();
    }
    final imageWidget = buildImageFileWidget(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
    );
    if (imageWidget == null) {
      return _buildImagePlaceholder();
    }
    return imageWidget;
  }

  Widget _buildImagePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Toque para adicionar imagem',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

enum ImageSource { camera, gallery }

