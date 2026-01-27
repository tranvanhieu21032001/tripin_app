import 'dart:io';

import 'package:injectable/injectable.dart';

import '../repositories/tasks_repository.dart';

@injectable
class UploadPhotoUseCase {
  final TasksRepository _repository;

  UploadPhotoUseCase(this._repository);

  Future<String> call(File photoFile) {
    return _repository.uploadPhoto(photoFile);
  }
}

