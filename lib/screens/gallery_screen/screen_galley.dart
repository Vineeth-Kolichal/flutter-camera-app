import 'dart:io';

import 'package:camera_app/database/functions/db_fuctions.dart';
import 'package:camera_app/database/model/image_model.dart';
import 'package:camera_app/screens/gallery_screen/single_view.dart';
import 'package:flutter/material.dart';

class ScreenGalley extends StatelessWidget {
  const ScreenGalley({super.key});

  @override
  Widget build(BuildContext context) {
    getImages();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text('Photo Gallery'),
              ),
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ValueListenableBuilder(
                  valueListenable: imageNotifier,
                  builder: (BuildContext ctx, List<ImageModel> image,
                      Widget? child) {
                    return GridView.builder(
                        itemCount: image.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0),
                        itemBuilder: (BuildContext context, int index) {
                          final img = image[index];
                          File imgfile = File(img.imagePath);
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((ctx) => SingleView(
                                        imageFile: imgfile,
                                        keyToDel: img.key,
                                      ))));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                imgfile,
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ),
        ],
      )),
    );
  }
}
