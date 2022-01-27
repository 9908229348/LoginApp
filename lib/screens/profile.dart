import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/user.dart';
import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:dummy_pro/screens/login.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      nameController = TextEditingController(text: loggedInUser.name);
      emailController = TextEditingController(text: loggedInUser.email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async{
              await AuthMethods.editUserDetails(UserModel(uid: user?.uid, name: nameController.text, email: emailController.text));

            },
            splashRadius: 17,
            icon: Icon(Icons.save_outlined),
          )
        ],
      ),
        body: Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.lightBlueAccent, Colors.white24])),
      ),
      Column(
        children: [
          TextField(
            controller: nameController,
            cursorColor: white,
            style: TextStyle(color: Colors.lightBlueAccent),
            decoration: InputDecoration(hintText: "name"),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailController,
            cursorColor: white,
            style: TextStyle(color: Colors.lightBlueAccent),
            decoration: InputDecoration(hintText: "email"),
          ),
          CircleAvatar(
            child: IconButton(
              onPressed: (){logOut(context);},
              icon: Icon(Icons.logout),
            ),
          )
        ],
      )
    ]));
  }

  Future<void> logOut(BuildContext context) async {
    await AuthMethods().signOut();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool("isLoggedIn", false);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

}
