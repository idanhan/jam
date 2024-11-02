import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './messagemodel.dart';
import 'package:budget_app/chatscreen/chatscreen.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  TextDirection direction = TextDirection.ltr;
  List<Message> messagelist = [];
  Map<String, Message> messagemap = {};

  Future<void> sendmessage(String receiverusername, String message,
      String username, String receiverEmail, String userEmail) async {
    final String currentusername = _firebaseAuth.currentUser!.uid;
    final String currentuserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        receiverusername: receiverusername,
        senderEmail: userEmail,
        senderusername: username,
        timestamp: timestamp,
        message: message,
        receiveruserEmail: receiverEmail);

    List<String> usernames = [userEmail, receiverEmail];
    usernames.sort();
    String chatroomId = usernames.join("_");

    await _firebaseFirestore.collection('chat_rooms').doc(chatroomId).set({
      'nameparts': usernames,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatroomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userEmail, String otheruserEmail) {
    List<String> usernames = [userEmail, otheruserEmail];
    usernames.sort();
    String chatRoomId = usernames.join("_");

    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<List<dynamic>> getUserChatRooms(String userId) {
    var f = FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('nameparts', arrayContains: userId)
        .snapshots()
        .map((event) {});
    print(f.first);

    Stream<List<dynamic>> list1 = FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('nameparts', arrayContains: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()['messages']).toList());
    return list1;
  }

  Future<List<Message>> getUserChatRooms2(String userId) async {
    List<Message> messageList = [];

    QuerySnapshot parentSnapshot = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .where('nameparts', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .get();

    for (QueryDocumentSnapshot doc in parentSnapshot.docs) {
      String docId = doc.id;
      QuerySnapshot messageSnapshot = await FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(docId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (messageSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> messageData =
            (messageSnapshot.docs.first.data() as Map<String, dynamic>);
        final message = Message(
          receiverusername: messageData['receiverusername'],
          senderEmail: messageData['senderemail'],
          senderusername: messageData['senderusername'],
          timestamp: messageData['timestamp'],
          message: messageData['message'],
          receiveruserEmail: messageData['receiveruserEmail'],
        );
        messageList.add(message);
        messagemap[docId] = message;
      }
    }
    return messageList;
  }

  void getHistory(String useremail) async {
    print("running");
    final DocumentSnapshot<Map<String, dynamic>> docslist =
        await _firebaseFirestore.collection('chat_rooms').doc().get();
    print("running id");
    print(docslist.id);
  }

  Future<void> gotomessagepage(
      BuildContext context,
      String otherusername,
      String username,
      String userEmail,
      String receiverEmail,
      double width) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatScreen(
        otherusername: otherusername,
        username: username,
        userEmail: userEmail,
        receiverEmail: receiverEmail,
        width: width,
      ),
    ));
  }

  void tolistandorderbytimestamp() {
    messagemap.forEach((key, value) {});
  }

  void replacetolatesttimestamp(Message message) {
    for (Message message1 in messagelist) {
      if ((message1.receiveruserEmail.compareTo(message.receiveruserEmail) ==
              0) &&
          (message1.senderEmail.compareTo(message.senderEmail) == 0)) {
        if (message1.timestamp.toDate().isBefore(message.timestamp.toDate())) {}
      }
    }
  }

  bool iflistcontainsmessage(Message message) {
    for (Message message1 in messagelist) {
      if ((message1.receiveruserEmail.compareTo(message.receiveruserEmail) ==
              0) &&
          (message1.senderEmail.compareTo(message.senderEmail) == 0)) {
        return true;
      }
    }
    return false;
  }

  bool _isrtl(String text) {
    if (text.isEmpty) return false;

    final rtlChars = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u0590-\u05FF]');
    return rtlChars.hasMatch(text.characters.first);
  }

  void tortl(String text) {
    if (_isrtl(text)) {
      direction = TextDirection.rtl;
      notifyListeners();
    } else {
      direction = TextDirection.ltr;
      notifyListeners();
    }
  }
}
