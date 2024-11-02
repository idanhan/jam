import 'dart:convert';
import 'dart:io';

import 'package:budget_app/profilepage/ProfileData.dart';
import 'package:budget_app/profilepage/service.dart';

import 'package:budget_app/signup/signUpScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
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
  List<Widget> newid = [];

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
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> addplayer(String url, String description, String username,
      double height, double width, BuildContext context) async {
    final Map<String, String> map = {url.trim(): description};
    final String? videoId = YoutubePlayer.convertUrlToId(url.trim());

    // If the URL is invalid (cannot extract video ID), show an error and return
    if (videoId == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid YouTube URL"),
          content: const Text("Please enter a valid YouTube URL."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return; // Exit early since the URL is invalid
    }
    print("before");
    print(url);
    newid.add(map.entries
        .map((e) => SizedBox(
              key: ValueKey(e.key),
              height: height * 0.3,
              width: width * 0.9,
              child: Column(
                children: [
                  Text(e.value),
                  Stack(children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: YoutubeP(
                        youtubeUrl: e.key,
                        width: width,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                          onPressed: () {
                            if (context.mounted) {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text("remove video?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("cancel")),
                                          TextButton(
                                              onPressed: () async {
                                                print(username);
                                                final url = Uri.parse(
                                                    "${constants.baseurl}/user/removeyoutube");
                                                print(url);
                                                final response =
                                                    await http.delete(url,
                                                        headers: {
                                                          'Content-Type':
                                                              'application/json'
                                                        },
                                                        body: json.encode({
                                                          "url": e.key,
                                                          "username": username
                                                        }));
                                                print("sfdfsfsdf");
                                                if (response.statusCode ==
                                                    204) {
                                                  print(
                                                      "b length is: ${listwid.length}");
                                                  listwid.removeWhere((item) =>
                                                      item.key ==
                                                      ValueKey(e.key));
                                                  print(
                                                      "af length is: ${listwid.length}");
                                                  notifyListeners();
                                                  if (context.mounted) {
                                                    Navigator.of(context).pop();
                                                  }
                                                } else {
                                                  print("here");
                                                  print(response.body);
                                                }
                                              },
                                              child: const Text("remove"))
                                        ],
                                      ));
                            }
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.white,
                          )),
                    ),
                  ])
                ],
              ),
            ))
        .first);
    newid.addAll(listwid);
    // print(newid.length);
    listwid.clear();
    for (var item in newid) {
      listwid.add(item);
    }

    newid.clear();
    notifyListeners();
    var uri = Uri.parse("${constants.baseurl}/user/urlList/$username");

    http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"url": url, "description": description}));
  }

  Future<void> addurlvideos(ProfileData user) async {
    notifyListeners();
  }

  void initialvidoes(BuildContext context, Map<String, String> map,
      double height, double width, String username) {
    if (initialized) {
      listwid = map.entries
          .map((e) => SizedBox(
                key: ValueKey(e.key),
                height: height * 0.3,
                width: width * 0.9,
                child: Column(
                  children: [
                    Text(e.value),
                    Stack(children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: YoutubeP(
                          youtubeUrl: e.key,
                          width: width,
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: IconButton(
                            onPressed: () {
                              if (context.mounted) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text("remove video?"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("cancel")),
                                            TextButton(
                                                onPressed: () async {
                                                  print(username);
                                                  // final encodedUrl =
                                                  //     Uri.encodeComponent(
                                                  //         e.key);
                                                  print(e.key);
                                                  final url = Uri.parse(
                                                      "${constants.baseurl}/user/removeyoutube");
                                                  print(url);
                                                  final response =
                                                      await http.delete(url,
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json'
                                                          },
                                                          body: json.encode({
                                                            "url": e.key,
                                                            "username": username
                                                          }));
                                                  print("im hereeee");
                                                  if (response.statusCode ==
                                                      204) {
                                                    listwid.removeWhere(
                                                        (item) =>
                                                            item.key ==
                                                            ValueKey(e.key));
                                                    notifyListeners();
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    print("here");
                                                    print(response.body);
                                                  }
                                                },
                                                child: const Text("remove"))
                                          ],
                                        ));
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            )),
                      ),
                    ])
                  ],
                ),
              ))
          .toList();
      initialized = false;
    }
  }

  Future<void> deleteuser(
      String useremail, BuildContext context, String username) async {
    final url =
        Uri.parse('${constants.baseurl}/user/delete/$useremail,$username');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('UserEmail');
      await prefs.remove('UserPassword');
      await prefs.remove('UserName');
      try {
        final user = FirebaseAuth.instance.currentUser;
        QuerySnapshot userchats = await FirebaseFirestore.instance
            .collection('chat_rooms')
            .where('nameparts', arrayContains: useremail)
            .get();
        for (QueryDocumentSnapshot docs in userchats.docs) {
          await docs.reference.delete();
          QuerySnapshot<Map<String, dynamic>> collectionReference =
              await docs.reference.collection('messages').get();
          for (DocumentSnapshot subDoc in collectionReference.docs) {
            await subDoc.reference.delete();
          }
          await docs.reference.delete();
        }
        if (user != null) {
          user.delete();
        } else {
          print("there is a problem, user does not exist");
        }
        if (context.mounted) {
          final provider = Provider.of<AuthServices>(context, listen: false);
          await provider.signout(context);
          await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignUpScreen()));
        }
      } catch (e) {
        print("error: $e");
      }
    } else {
      print("error: ${response.body}");
    }
  }
}
