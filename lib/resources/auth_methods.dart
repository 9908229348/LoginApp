import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/resources/storage.dart';
import 'package:dummy_pro/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String name,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoUrl =
            await StorageMethods().uploadImageToStorage("profilePic", file);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "name": name,
          "uid": cred.user!.uid,
          "email": email,
          "photoUrl": photoUrl
        });
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<String> editUserDetails(
      String uid, String name, String email, Uint8List? file) async {
    var userId = _auth.currentUser?.uid;
    print("++++++Uid++++++++ $uid");
    if (file != null) {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("profilePic", file);
      await _firestore
          .collection("users")
          .doc(userId)
          .update({"name": name, "email": email, "photoUrl": photoUrl});
    } else {
      print("---------------------------");
      print("Inside Else $name $email");
      try {
        await _firestore.collection("users").doc(userId).update({
          "name": name,
          "email": email,
        });
      } catch (e) {
        print(e.toString());
      }
    }
    return "success";
  }

  void signInWithGoogle(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        final UserCredential authResult =
            await auth.signInWithCredential(credential);

        final User? user = authResult.user;

        var userData = {
          'name': googleSignInAccount.displayName,
          'provider': 'google',
          'photoUrl': googleSignInAccount.photoUrl,
          'email': googleSignInAccount.email,
        };

        users.doc(user?.uid).get().then((doc) {
          if (doc.exists) {
            doc.reference.update(userData);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            users.doc(user?.uid).set(userData);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        });
      }
    } catch (PlatformException) {
      print(PlatformException);
      print("Sign in not successful !");
    }
  }
}
