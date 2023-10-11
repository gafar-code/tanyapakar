import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class FungsiPakar {
  Future<CroppedFile?> getImage(ImageSource source) async {
    try {
      final XFile? gambar = await ImagePicker().pickImage(source: source);

      if (gambar != null) {
        CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: gambar.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 300,
          maxHeight: 300,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(toolbarTitle: "Crop Gambar"),
            IOSUiSettings(title: "Crop Gambar")
          ],
        );

        return cropped;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<CroppedFile?> getSerti(ImageSource source) async {
    try {
      final XFile? gambar = await ImagePicker().pickImage(source: source);

      if (gambar != null) {
        CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: gambar.path,
          compressQuality: 100,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(toolbarTitle: "Crop Gambar"),
            IOSUiSettings(title: "Crop Gambar")
          ],
        );

        return cropped;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
