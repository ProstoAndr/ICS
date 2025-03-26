import 'dart:typed_data';

import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../domain/entity/file_data.dart';

abstract class UploadFileUseCase {
  Future<List<Plenty>> uploadFile(
    Uint8List fileBytes,
    String fileName,
  );

  Future<void> deleteFile();

  Future<FileData?> getFile();
}
