part of 'upload_file_cubit.dart';

@immutable
sealed class UploadFileState {}

class UploadFileInitial extends UploadFileState {}

class UploadFileLoading extends UploadFileState {}

class UploadFileLoaded extends UploadFileState {
  final List<Plenty> listPlenty;
  final String fileName;

  UploadFileLoaded({
    required this.listPlenty,
    required this.fileName,
  });
}

class UploadFileError extends UploadFileState {}
