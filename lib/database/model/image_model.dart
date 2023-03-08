import 'package:hive_flutter/hive_flutter.dart';
part 'image_model.g.dart';

@HiveType(typeId: 1)
class ImageModel extends HiveObject {
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String imageName;

  ImageModel({required this.imagePath, required this.imageName});
}
