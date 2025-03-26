import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:gap/gap.dart';
import 'package:ics/theme/main_colors.dart';

import '../cubit/upload_file_cubit.dart';
import 'dashed_border_painter.dart';

class ExcelUploaderWidget extends StatefulWidget {
  const ExcelUploaderWidget({super.key});

  @override
  State<ExcelUploaderWidget> createState() => _ExcelUploaderWidgetState();
}

class _ExcelUploaderWidgetState extends State<ExcelUploaderWidget> {
  DropzoneViewController? dropzoneController;
  String? exelFileName;
  bool isDragging = false;

  @override
  void initState() {
    final cubit = BlocProvider.of<UploadFileCubit>(context);
    cubit.getFile();
    super.initState();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = result.files.first;
      final fileBytes = pickedFile.bytes;
      final fileName = pickedFile.name;

      setState(() {
        exelFileName = fileName;
      });

      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Не удалось прочитать содержимое файла.')),
        );
        return;
      }
      final cubit = BlocProvider.of<UploadFileCubit>(context);
      await cubit.uploadFile(fileBytes, fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UploadFileCubit>(context);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Файлы игры (Excel таблица)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          BlocBuilder<UploadFileCubit, UploadFileState>(
            builder: (context, state) {
              if (state is UploadFileInitial) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
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
                            final name = await dropzoneController!.getFilename(file);
                            setState(() {
                              exelFileName = name;
                              isDragging = false;
                            });
                          },
                        ),
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Переместите файл сюда или\nнажмите для загрузки",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Gap(5),
                        Text(
                          "Формат: .XLSX, .XLS. Максимальный размер — 100 МБ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: pickFile,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ],
                );
              }
              if (state is UploadFileLoading) {
                return CustomPaint(
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
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (state is UploadFileLoaded) {
                return CustomPaint(
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.insert_drive_file,
                              size: 64,
                              color: Colors.amber,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              state.fileName,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 16,
                          top: 16,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                exelFileName = null;
                              });
                              cubit.deleteFile();
                            },
                            icon: const Icon(
                              Icons.clear,
                              size: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
