import 'dart:io';

import 'package:camera_app/database/model/image_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

ValueNotifier<List<ImageModel>> imageNotifier = ValueNotifier([]);
Future<void> addImage(ImageModel image) async {
  final imgDB = await Hive.openBox<ImageModel>('image_db');
  imgDB.add(image);
  // print('-------------');
  // print(image.imageName);
  // print(image.imagePath);
  //imgDB.deleteAt(index);
}

Future<void> getImages() async {
  final imgDB = await Hive.openBox<ImageModel>('image_db');
  imageNotifier.value.clear();
  imageNotifier.value.addAll(imgDB.values);

  imageNotifier.notifyListeners();
}

Future<void> deleteImage(int key) async {
  final imgDB = await Hive.openBox<ImageModel>('image_db');
  await imgDB.delete(key);
  await getImages();
}

Future<bool> requestPermission() async {
  final permission = await Permission.storage.request();
  print('is it working');
  final status = permission.isGranted;
  print(status);
  if (status) {
    return true;
  } else {
    var result = await Permission.storage.request();
    if (result == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<Directory?> getDirectory() async {
  Directory? directory = await path_provider.getExternalStorageDirectory();
  // Directory directory = await path_provider.getApplicationDocumentsDirectory();
  print(directory?.path);
  if (Platform.isAndroid) {
    print('Android');
    if (await requestPermission()) {
      print('Permission');
      String newPath = '';
      List<String> floders = directory!.path.split("/");
      print(floders);

      for (int x = 1; x < floders.length; x++) {
        String folder = floders[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/CameraApp";
      print('------------------------');
      print(newPath);
      print('-----------------------');
      directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        return directory;
      }
    }
  }
  print('888888888888888888888888888888888888888');
  print(directory?.path);
  print('*******************************');
  return directory;
}

Future<String> saveImage(File imageFile, String imageName) async {
  final appDocumentDirectory = await getDirectory();
  print(appDocumentDirectory?.path);
  final savedDir = Directory('${appDocumentDirectory?.path}/images');
  print(savedDir);
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
