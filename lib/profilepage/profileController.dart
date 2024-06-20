import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:budget_app/models/User.dart';
import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../ApiConstants.dart';

class ProfileController extends ChangeNotifier {
  late ProfileData data;
  XFile? file;
  CroppedFile? croppedFile;

  bool loading = false;
  Services services = Services();

  Future<ProfileData> getPostdata(
      BuildContext context, String name, String email) async {
    loading = true;
    print("looookkk");
    data = await services.getData(context, name, email);
    loading = false;

    return data;
  }

  Future<void> pickimage() async {
    final image_picker = ImagePicker();
    final XFile? image =
        await image_picker.pickImage(source: ImageSource.gallery);

    file = image;
    notifyListeners();
  }

  Future<void> cropp() async {
    if (file != null) {
      final cropped = await ImageCropper().cropImage(sourcePath: file!.path);
      if (cropped != null) {
        croppedFile = cropped;
        notifyListeners();
      }
    } else {}
  }

  void delete() {
    file = null;
    croppedFile = null;
    notifyListeners();
  }

  Future<void> uploadImage(
      BuildContext context, String username, File imageFile) async {
    var uri = Uri.parse("${constants.baseurl}/user/image/$username");
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
      'image$username', // The name of the field expected by the server
      imageFile.path,
    ));
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
