import 'dart:io';
import 'package:image/image.dart' as Im;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class Utils {
  static String getUserName(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");

    String firstNameInitial = nameSplit[0][0];
    String secondNameInitial = nameSplit[1][0];

    return firstNameInitial + secondNameInitial;
  }

  static Future<File> pickImage({@required ImageSource source}) async {
    File selectedImage = await ImagePicker.pickImage(source: source);

    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image, width: 500, height: 500);

    return new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }
}
