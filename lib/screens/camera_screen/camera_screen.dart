import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/database/functions/db_fuctions.dart';
import 'package:camera_app/database/model/image_model.dart';
import 'package:camera_app/main.dart';
import 'package:camera_app/screens/gallery_screen/screen_galley.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  FlashMode mode = FlashMode.off;
  IconData icodta = Icons.flash_off;
  late CameraController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('access denied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  late XFile picture;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black,
                width: double.infinity,
              ),
            ),
            Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 5,
                  right: 5,
                  left: 5,
                  //width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(129, 46, 44, 44),
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.only(bottom: 7, left: 7, right: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((ctx) => const ScreenGalley()),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        IconButton(
                          focusColor: Colors.blue,
                          onPressed: () async {
                            if (!_controller.value.isInitialized) {
                              return;
                            }
                            if (_controller.value.isTakingPicture) {
                              return;
                            }
                            try {
                              await _controller.setFlashMode(mode);
                              picture = await _controller.takePicture();
                              print(File(picture.path));
                            } on CameraException catch (e) {
                              debugPrint(
                                  "error occured while taking picture:$e");
                              return;
                            }
                            final fileName = basename(picture.path);
                            final imagePath =
                                await saveImage(File(picture.path), fileName);
                            ImageModel img = ImageModel(
                                imagePath: imagePath, imageName: fileName);
                            addImage(img);
                          },
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (icodta == Icons.flash_off) {
                                icodta = Icons.flash_on;
                                mode = FlashMode.always;
                              } else {
                                icodta = Icons.flash_off;
                                mode = FlashMode.off;
                              }
                            });
                          },
                          icon: Icon(
                            icodta,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
