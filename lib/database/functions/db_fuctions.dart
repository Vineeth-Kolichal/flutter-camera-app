import 'dart:io';

import 'package:camera_app/database/model/image_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

ValueNotifier<List<ImageModel>> imageNotifier = ValueNotifier([]);
Future<void> addImage(ImageModel image) async {
  final imgDB = await Hive.openBox<ImageModel>('image_db');
  imgDB.add(image);
  print('-------------');
  print(image.imageName);
  print(image.imagePath);
  //imgDB.deleteAt(index);
}

Future<void> getImages() async {
  final imgDB = await Hive.openBox<ImageModel>('image_db');
  imageNotifier.value.clear();
  imageNotifier.value.addAll(imgDB.values);

  imageNotifier.notifyListeners();
}

Future<void> deleteImage() async {}

Future<Directory> getDirectory() async {
  return await path_provider.getApplicationDocumentsDirectory();
}

Future<String> saveImage(File imageFile, String imageName) async {
  final appDocumentDirectory = await getDirectory();
  final savedDir = Directory('${appDocumentDirectory.path}/images');
  final dirPath = savedDir.path.toString();
  // bool hasExisted = await savedDir.exists();
  if (!Directory(dirPath).existsSync()) {
    Directory(dirPath).createSync(recursive: true);
  }
  // if (!hasExisted) {
  //   savedDir.create();
  // }
  final newPath = path.join(savedDir.path, imageName);
  await imageFile.copy(newPath);
  return newPath;
}
