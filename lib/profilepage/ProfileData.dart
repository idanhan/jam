class ProfileData {
  String name;
  String email;
  String password;
  String created_at;
  String country;
  String city;
  List<String> instruments;
  String level;
  List<String> genres;
  Map<String, String> urls;

  ProfileData({
    required this.name,
    required this.email,
    required this.password,
    required this.created_at,
    required this.country,
    required this.city,
    required this.instruments,
    required this.level,
    required this.genres,
    required this.urls,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    if (json['genre'] is List<dynamic>) {
      print('true');
    }
    return ProfileData(
      name: json['username'],
      email: json['email'],
      password: json['password'],
      created_at: json['created_at'],
      country: json['country'],
      city: json['city'],
      instruments: (json['instrument'] as List).cast<String>(),
      level: json['level'],
      genres: (json['genre'] as List).cast<String>(),
      urls: (json['urls'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, '$value')),
    );
  }
}
