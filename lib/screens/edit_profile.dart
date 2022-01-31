import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/user.dart';
import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:dummy_pro/screens/login.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Uint8List? _image;
  String? _imageFromFirebase;

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
      _imageFromFirebase = loggedInUser.photoUrl;
      setState(() {

      });
    });
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
              onPressed: () async{
                print("+++++++++++++++++++++++++++++++++ $_image");
                String message = await AuthMethods.editUserDetails(user!.uid, nameController.text, emailController.text, _image);
                if(message == "success"){
                  Navigator.pop(context);
                  showSnackBar(context, "Saved Successfully");
                }else{
                  showSnackBar(context, "Something went wrong");
                }
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
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Center(
                  child: Stack(children: [
                    //     CircleAvatar(
                    //   radius: 64,
                    //   backgroundImage: NetworkImage(_imageFromFirebase!),
                    // ),
                    _image != null
                        ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                        : CircleAvatar(
                      radius: 64,
                      backgroundImage: _imageFromFirebase != null ? NetworkImage(_imageFromFirebase!
                          ) : NetworkImage("https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                    ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.lightBlueAccent,
                          ),
                        ))
                  ]),
                ),
                SizedBox(height: 20,),
                Text("name", style: TextStyle(fontSize: 20),),
                TextField(
                  controller: nameController,
                  cursorColor: white,
                  style: TextStyle(fontSize: 25, color: Colors.blue),
                  decoration: InputDecoration(hintText: "name"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("email", style: TextStyle(fontSize: 20),),
                TextField(
                  controller: emailController,
                  cursorColor: white,
                  style: TextStyle(fontSize: 25, color: Colors.blue),
                  decoration: InputDecoration(hintText: "email"),
                ),
                // CircleAvatar(
                //   child: IconButton(
                //     onPressed: (){logOut(context);},
                //     icon: Icon(Icons.logout),
                //   ),
                // )
              ],
            ),
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