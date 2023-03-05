import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SingleView extends StatelessWidget {
  final File imageFile;
  const SingleView({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Image.file(imageFile);
  }
}
