import 'dart:io';

import 'package:ig/features/domain/reposotories/firebase_repository.dart';

class UploadImageToStorage{
  final FirebaseRepository repository;
  UploadImageToStorage({required this.repository});
  Future<String> call(File? file,bool isPost,String childName)async{
    return await repository.uploadImageToStorage(file, isPost, childName);
  }
}