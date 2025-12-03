// Conditional exports - usa stub no web, implementação real no mobile
export 'image_file_helper_stub.dart' if (dart.library.io) 'image_file_helper_io.dart';

