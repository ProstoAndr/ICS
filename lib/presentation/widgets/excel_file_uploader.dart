import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gap/gap.dart';
import 'package:ics/theme/MainColors.dart';

import 'dashed_border_painter.dart';

class ExcelUploaderWidget extends StatefulWidget {
  const ExcelUploaderWidget({super.key});

  @override
  State<ExcelUploaderWidget> createState() => _ExcelUploaderWidgetState();
}

class _ExcelUploaderWidgetState extends State<ExcelUploaderWidget> {
  DropzoneViewController? dropzoneController;
  String? fileName;
  bool isDragging = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Файлы игры (Excel таблица)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          Stack(
            alignment: Alignment.center,
            children: [
              // DropZone с пунктирной границей
              CustomPaint(
                painter: DashedBorderPainter(borderRadius: 8),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isDragging
                        ? Colors.grey.shade300
                        : MainColors.neutral030,
                  ),
                  child: DropzoneView(
                    onCreated: (controller) => dropzoneController = controller,
                    onHover: () => setState(() => isDragging = true),
                    onLeave: () => setState(() => isDragging = false),
                    onDrop: (dynamic file) async {
                      final String name =
                          await dropzoneController!.getFilename(file);
                      setState(() {
                        fileName = name;
                        isDragging = false;
                      });
                    },
                  ),
                ),
              ),

              // Иконка загрузки и текст
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Colors.grey),
                  SizedBox(height: 5),
                  Text("Переместите файл сюда или\nнажмите для загрузки",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Text("Формат: .XLSX, .XLS. Максимальный размер — 100 МБ",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),

              // Кнопка загрузки файла
              Positioned.fill(
                child: GestureDetector(
                  onTap: pickFile,
                  child: Container(color: Colors.transparent),
                ),
              ),

              // Отображение загруженного файла
              if (fileName != null)
                Positioned(
                  right: 15,
                  top: 15,
                  child: Column(
                    children: [
                      const Icon(Icons.insert_drive_file,
                          size: 40, color: Colors.amber),
                      const SizedBox(height: 5),
                      Text(fileName!,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
