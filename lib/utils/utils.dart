import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

pickMultipleImages(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  List<Uint8List> images = [];
  List<XFile>? _files = await _imagePicker.pickMultiImage();
  if (_files != null) {
    _files.forEach((file) async {
      images.add(await file.readAsBytes());
    });
  } else {
    print('No Image Selected');
  }

  return images;
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
