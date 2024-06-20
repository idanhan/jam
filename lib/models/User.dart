class User {
  int userid;
  String username;
  String email;
  DateTime jointime;
  List<Map<String, String>> tasks;

  User(
      {required this.email,
      required this.jointime,
      required this.userid,
      required this.username,
      required this.tasks});
}
