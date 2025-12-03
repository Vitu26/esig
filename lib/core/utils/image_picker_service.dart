import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'file_helper.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<dynamic> pickImageFromCamera() async {
    try {
      if (kIsWeb) {
        return null;
      }
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
      
      if (image != null) {
        return createFileFromPath(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error picking image from camera: $e');
    }
  }

  Future<dynamic> pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        return null;
      }
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      
      if (image != null) {
        // Usa helper para criar File apenas quando não estiver na web
        return createFileFromPath(image.path);
      }
      return null;
    } catch (e) {
      throw Exception('Error picking image from gallery: $e');
    }
  }

  Future<XFile?> pickXFileFromCamera() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );
    } catch (e) {
      throw Exception('Error picking image from camera: $e');
    }
  }

  Future<XFile?> pickXFileFromGallery() async {
    try {
      return await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
    } catch (e) {
      throw Exception('Error picking image from gallery: $e');
    }
  }
}

