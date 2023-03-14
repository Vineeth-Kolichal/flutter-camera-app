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

  final status = permission.isGranted;

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

  if (Platform.isAndroid) {
    if (await requestPermission()) {
      String newPath = '';
      List<String> floders = directory!.path.split("/");

      for (int x = 1; x < floders.length; x++) {
        String folder = floders[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/CameraApp";

      directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        return directory;
      }
    }
  }

  return directory;
}

Future<String> saveImage(File imageFile, String imageName) async {
  final appDocumentDirectory = await getDirectory();

  final savedDir = Directory('${appDocumentDirectory?.path}/images');

  final dirPath = savedDir.path.toString();

  if (!Directory(dirPath).existsSync()) {
    Directory(dirPath).createSync(recursive: true);
  }

  final newPath = path.join(savedDir.path, imageName);
  await imageFile.copy(newPath);
  return newPath;
}
