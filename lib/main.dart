import 'package:camera/camera.dart';
import 'package:camera_app/database/functions/db_fuctions.dart';
import 'package:camera_app/database/model/image_model.dart';
import 'package:camera_app/screens/camera_screen/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

late List<CameraDescription> cameras;
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  final appDocumentDirectory = await getDirectory();
  Hive.initFlutter(appDocumentDirectory?.path);
  if (!Hive.isAdapterRegistered(ImageModelAdapter().typeId)) {
    Hive.registerAdapter(ImageModelAdapter());
  }
  runApp(const CameraApp());
}

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CameraScreen(),
    );
  }
}
