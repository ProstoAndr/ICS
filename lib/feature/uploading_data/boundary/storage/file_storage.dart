import '../../domain/entity/file.dart';

abstract class FileStorage {
  Future<void> saveFile(File file);

  Future<File?> getFile();

  Future<void> removeFile();
}
