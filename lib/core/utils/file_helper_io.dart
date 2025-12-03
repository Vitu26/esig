import 'dart:io' as io;

/// Helper para criar File apenas quando não estiver na web
dynamic createFileFromPath(String path) {
  return io.File(path);
}

/// Helper para obter path de File apenas quando não estiver na web
String? getFilePath(dynamic file) {
  if (file == null) {
    return null;
  }
  return (file as io.File).path;
}

