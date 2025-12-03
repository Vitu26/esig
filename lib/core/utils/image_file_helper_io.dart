import 'dart:io' as io;
import 'package:flutter/material.dart';

/// Helper para criar um widget Image.file apenas quando não estiver na web
Widget? buildImageFileWidget(dynamic file, {
  BoxFit fit = BoxFit.cover,
  double? width,
  ImageErrorWidgetBuilder? errorBuilder,
}) {
  if (file == null) {
    return null;
  }
  
  final ioFile = file as io.File;
  
  return Image.file(
    ioFile,
    fit: fit,
    width: width,
    errorBuilder: errorBuilder,
  );
}

