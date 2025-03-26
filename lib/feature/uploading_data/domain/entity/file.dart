import 'dart:typed_data';

class File {
  final Uint8List fileBytes;

  final String fileName;

  File({required this.fileBytes, required this.fileName});
}
