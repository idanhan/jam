import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderusername;
  final String senderEmail;
  final String receiverusername;
  final Timestamp timestamp;
  final String message;
  final String receiveruserEmail;

  Message(
      {required this.receiverusername,
      required this.senderEmail,
      required this.senderusername,
      required this.timestamp,
      required this.message,
      required this.receiveruserEmail});

  Map<String, dynamic> toMap() {
    return {
      "senderusername": senderusername,
      "senderemail": senderEmail,
      "receiverusername": receiverusername,
      "receiveruserEmail": receiveruserEmail,
      "timestamp": timestamp,
      "message": message,
    };
  }
}
