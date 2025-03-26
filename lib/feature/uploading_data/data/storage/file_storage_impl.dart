import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../boundary/storage/file_storage.dart';
import '../../domain/entity/file.dart';

class FileStorageImpl implements FileStorage{
  static const _keyFile = 'stored_file';

  /// Сохранение объекта File в SharedPreferences
  @override
  Future<void> saveFile(File file) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Кодируем байты в Base64-строку
    final base64String = base64Encode(file.fileBytes);

    // 2. Формируем Map, чтобы хранить и имя файла, и его содержимое
    final Map<String, dynamic> fileMap = {
      'fileName': file.fileName,
      'fileBytes': base64String,
    };

    // 3. Превращаем Map в JSON-строку
    final jsonString = jsonEncode(fileMap);

    // 4. Сохраняем JSON-строку в SharedPreferences под ключом _keyFile
    await prefs.setString(_keyFile, jsonString);
  }

  /// Получение объекта File из SharedPreferences
  @override
  Future<File?> getFile() async {
    final prefs = await SharedPreferences.getInstance();

    // Извлекаем JSON-строку
    final jsonString = prefs.getString(_keyFile);
    if (jsonString == null) {
      // Ничего не сохранено
      return null;
    }

    try {
      // Декодируем JSON в Map
      final Map<String, dynamic> fileMap = jsonDecode(jsonString);

      final String fileName = fileMap['fileName'] as String;
      final String base64String = fileMap['fileBytes'] as String;

      // Декодируем Base64 обратно в байты
      final fileBytes = base64Decode(base64String);

      // Создаём объект File
      return File(fileBytes: fileBytes, fileName: fileName);
    } catch (e) {
      // Если что-то пошло не так (например, неверный формат),
      // можно очистить ключ или просто вернуть null
      return null;
    }
  }

  /// Удаление файла из SharedPreferences
  @override
  Future<void> removeFile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFile);
  }
}