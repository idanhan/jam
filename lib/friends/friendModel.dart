import 'package:flutter/material.dart';

class FriendModel {
  final username;
  final id;
  final password;
  final country;
  final city;
  final genre;
  final level;
  final instruments;
  final email;
  FriendModel(
      {required this.city,
      required this.country,
      required this.email,
      required this.genre,
      required this.id,
      required this.instruments,
      required this.level,
      required this.password,
      required this.username});

  factory FriendModel.fromJson(Map<String, dynamic> json, String username) {
    return FriendModel(
        city: json['city'],
        country: json['country'],
        email: json['email'],
        genre: json['genre'],
        id: json['id'],
        instruments: json['instruments'],
        level: json['level'],
        password: json['password'],
        username: username);
  }
}
