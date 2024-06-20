import 'package:flutter/material.dart';
import '../profilepage/ProfileData.dart';

class UserModel {
  Image? image;
  ProfileData profileData;
  UserModel({required this.profileData, this.image});
}
