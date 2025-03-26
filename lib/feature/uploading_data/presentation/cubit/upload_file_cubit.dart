import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../boundary/usecase/upload_file_usecase.dart';

part 'upload_file_state.dart';

class UploadFileCubit extends Cubit<UploadFileState> {
  final UploadFileUseCase uploadFileUseCase;

  UploadFileCubit({
    required this.uploadFileUseCase,
  }) : super(UploadFileInitial());

  Future<void> uploadFile(
    Uint8List fileBytes,
    String fileName,
  ) async {
    emit(UploadFileLoading());

    final listPlenty = await uploadFileUseCase.uploadFile(
      fileBytes,
      fileName,
    );
    emit(UploadFileLoaded(listPlenty: listPlenty, fileName: fileName));
  }

  Future<void> deleteFile() async {
    emit(UploadFileLoading());
    await uploadFileUseCase.deleteFile();
    emit(UploadFileInitial());
  }

  Future<void> getFile() async {
    emit(UploadFileLoading());
    final fileData = await uploadFileUseCase.getFile();
    if (fileData == null) {
      emit(UploadFileInitial());
    } else {
      emit(UploadFileLoaded(
        listPlenty: fileData.listPlenty,
        fileName: fileData.fileName,
      ));
    }
  }
}
