import 'package:dummy_pro/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassWord extends StatefulWidget {
  const ForgetPassWord({Key? key}) : super(key: key);

  @override
  _ForgetPassWordState createState() => _ForgetPassWordState();
}

class _ForgetPassWordState extends State<ForgetPassWord> {
  var userEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: userEmailController,
              ),
              TextButton(
                  onPressed: () async {
                    try {
                      print("=========================================================================");
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: userEmailController.text);
                      showSnackBar(context, "Email sent");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print("Password weak");
                      } else if (e.code == 'email-already-in-use') {
                        print('Email is already in use');
                      }
                    } catch (e) {
                      print('inside $e');
                    }
                  },
                  child: Text("Send Email"))
            ],
          ),
        ),
      ),
    );
  }
}
