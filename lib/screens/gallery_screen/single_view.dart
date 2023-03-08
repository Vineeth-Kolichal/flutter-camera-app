import 'dart:io';

import 'package:camera_app/database/functions/db_fuctions.dart';
import 'package:flutter/material.dart';

class SingleView extends StatelessWidget {
  final File imageFile;
  final int keyToDel;
  const SingleView(
      {super.key, required this.imageFile, required this.keyToDel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Stack(children: [
              Image.file(imageFile),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40))),
                    onPressed: () async {
                      await deleteImage(keyToDel);
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
