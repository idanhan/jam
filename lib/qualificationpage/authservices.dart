import 'package:budget_app/calander/EventProvider.dart';
import 'package:budget_app/friends/friendController.dart';
import 'package:budget_app/profilepage/profileController.dart';
import 'package:budget_app/requests/requestsController.dart';
import 'package:budget_app/signin/SigninController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class AuthServices extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserCredential> signInWithEmailPassword(
      String Email, String Password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: Email, password: Password);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': userCredential.user!.uid,
        'email': Email,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<void> signout(BuildContext context) async {
    final provider = Provider.of<SignInController>(context, listen: false);
    final profileprovider =
        Provider.of<ProfileController>(context, listen: false);
    final requestprovider =
        Provider.of<RequestsController>(context, listen: false);
    final eventprovider = Provider.of<EventProvider>(context, listen: false);
    final friedprovider = Provider.of<FriendController>(context, listen: false);
    friedprovider.friendsSearch.clear();
    friedprovider.friend = null;
    friedprovider.friends.clear();
    friedprovider.friendstatus = "";
    friedprovider.friends.clear();
    friedprovider.image = null;
    friedprovider.mapfriends.clear();
    eventprovider.removeallevents();
    profileprovider.listwid.clear();
    profileprovider.initialized = true;
    requestprovider.friends.clear();
    requestprovider.addedfriends.clear();
    requestprovider.image = null;
    requestprovider.images.clear();
    provider.UsernameController.clear();
    provider.emailnameController.clear();
    provider.events.clear();
    provider.friends.clear();
    provider.image = null;
    provider.mapevents.clear();
    provider.mapeventsimages.clear();
    provider.mapfriends.clear();
    provider.passwordController.clear();
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String Email, String Password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: Email, password: Password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> deleteuser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      user.delete();
    } else {
      print("user does not exist");
    }
  }
}
