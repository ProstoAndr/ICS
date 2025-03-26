import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../boundary/storage/file_storage.dart';
import '../../boundary/usecase/upload_file_usecase.dart';
import '../../domain/entity/file.dart';
import '../entity/file_data.dart';

class UploadFileUseCaseImpl implements UploadFileUseCase {
  final FileStorage fileStorage;

  UploadFileUseCaseImpl({required this.fileStorage});

  @override
  Future<void> deleteFile() async {
    await fileStorage.removeFile();
  }

  @override
  Future<FileData?> getFile() async {
    final file = await fileStorage.getFile();
    if (file != null) {
      final listPlenty = await _convertFile(file.fileBytes);
      return FileData(fileName: file.fileName, listPlenty: listPlenty);
    } else {
      return null;
    }
  }

  @override
  Future<List<Plenty>> uploadFile(
    Uint8List fileBytes,
    String fileName,
  ) async {
    final listPlenty = await _convertFile(fileBytes);
    final file = File(
      fileName: fileName,
      fileBytes: fileBytes,
    );
    await fileStorage.saveFile(file);
    return listPlenty;
  }

  Future<List<Plenty>> _convertFile(Uint8List fileBytes) async {
    final excel = Excel.decodeBytes(fileBytes);
    final List<Plenty> result = [];

    for (final sheetName in excel.tables.keys) {
      final sheet = excel.tables[sheetName];
      if (sheet == null) continue;

      if (sheet.rows.isEmpty) continue;

      final firstRow = sheet.rows.first;
      if (firstRow.isEmpty) continue;

      final headers = firstRow.map((cell) {
        return cell?.value?.toString() ?? '';
      }).toList();

      for (int colIndex = 0; colIndex < headers.length; colIndex++) {
        final columnName = headers[colIndex];
        final List<double> columnData = [];

        for (int rowIndex = 1; rowIndex < sheet.rows.length; rowIndex++) {
          final row = sheet.rows[rowIndex];
          double parsedValue = 0.0;

          if (colIndex < row.length) {
            final cell = row[colIndex];
            final dynamic cellVal = cell?.value;

            if (cellVal != null) {
              if (cellVal is num) {
                parsedValue = cellVal.toDouble();
              } else {
                parsedValue = double.tryParse(cellVal.toString()) ?? 0.0;
              }
            }
          }

          columnData.add(parsedValue);
        }

        result.add(
          Plenty(name: columnName, data: columnData),
        );
      }
    }

    return result;
  }
}
