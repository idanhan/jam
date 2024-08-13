import 'dart:convert';
import 'dart:io';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../ApiConstants.dart';
import '../youtubeplayer.dart';
import '../qualificationpage/authservices.dart';

class ProfileController extends ChangeNotifier {
  late ProfileData data;
  XFile? file;
  CroppedFile? croppedFile;
  final TextEditingController youtubeurlController = TextEditingController();
  final TextEditingController Desccontroller = TextEditingController();
  Map<String, YoutubeP> youtubemap = {};
  List<Widget> listwid = [];
  bool initialized = true;
  Image? imageProvidernew;

  Future<void> signout() async {
    return await FirebaseAuth.instance.signOut();
  }

  bool loading = false;
  Services services = Services();

  Future<ProfileData> getPostdata(
      BuildContext context, String name, String email) async {
    loading = true;
    data = await services.getData(context, name, email);
    loading = false;

    return data;
  }

  void changeimageprovider(Image? newimage) {
    imageProvidernew = newimage;
    notifyListeners();
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
        changeimageprovider(Image.file(File(croppedFile!.path)));
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
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> addplayer(String url, String description, String username,
      double height, double width) async {
    // youtubemap.addAll({description: YoutubeP(youtubeUrl: url)});
    final Map<String, String> map = {description: url};
    listwid.add(map.entries
        .map((e) => SizedBox(
              height: height * 0.3,
              width: width * 0.9,
              child: Column(
                children: [
                  Text(e.key),
                  YoutubeP(
                    youtubeUrl: e.value,
                    width: width,
                  )
                ],
              ),
            ))
        .first);
    notifyListeners();
    var uri = Uri.parse("${constants.baseurl}/user/urlList/$username");
    http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"url": url, "description": description}));
  }

  Future<void> addurlvideos(ProfileData user) async {
    notifyListeners();
  }

  void initialvidoes(Map<String, String> map, double height, double width) {
    if (initialized) {
      listwid = map.entries
          .map((e) => SizedBox(
                height: height * 0.3,
                width: width * 0.9,
                child: Column(
                  children: [
                    Text(e.key),
                    YoutubeP(
                      youtubeUrl: e.value,
                      width: width,
                    )
                  ],
                ),
              ))
          .toList();
      initialized = false;
    }
  }
}
