import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  ImagePicker _imagepicker =
      ImagePicker(); //ImagePciker class i coming from the image_picker package
  XFile? _file = await _imagepicker.pickImage(
      source: source); //pickImage method is of type XFlie? Future
  if (_file != null) {
    //if not equal to null return image as bytes
    return await _file.readAsBytes();
  }
  print('No image selected');
}

//to show snack on signup
showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(content),
  ));
}
