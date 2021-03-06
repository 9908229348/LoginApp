import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/user.dart';
import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:dummy_pro/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  String? name;
  String? email;
  String? _image;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      name = loggedInUser.name;
      email = loggedInUser.email;
      _image = loggedInUser.photoUrl;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: Stack(children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.lightBlueAccent, Colors.white24])),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                Center(
                  child: CircleAvatar(
                      radius: 64,
                      backgroundImage: _image != null
                          ? NetworkImage(_image!)
                          : const NetworkImage(
                              "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg")),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  name ?? "Name",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  email ?? "Email",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Edit Details",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditProfilePage()));
                        },
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.blue,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("LogOut",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    IconButton(
                        onPressed: () {
                          logOut(context);
                        },
                        icon: const Icon(Icons.logout))
                  ],
                )
              ],
            )
          ]),
        ));
  }

  Future<void> logOut(BuildContext context) async {
    await AuthMethods().signOut();
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool("isLoggedIn", false);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()));
  }
}
