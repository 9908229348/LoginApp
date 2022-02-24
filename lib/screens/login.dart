import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/controller/login_controller.dart';
import 'package:dummy_pro/screens/home.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:dummy_pro/utils/validators.dart';
import 'package:dummy_pro/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forget_password.dart';
import 'registration.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends StateMVC<Login> {
  late LoginController loginController;
  bool isLoading = false;

  LoginState() : super(LoginController()) {
    loginController = controller as LoginController;
  }

  @override
  void initState() {
    super.initState();
    checkIfUserIsAlreadyLoggedIn();
  }

  checkIfUserIsAlreadyLoggedIn() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getBool("isLoggedIn") ?? false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  void logInUser() async {
    String result = await loginController.logInUser();
    if (result == "Login successfully") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else if (result == "Something Went wrong") {
      showSnackBar(context, result);
    } else {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: logInUser,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text("Login",
                style: TextStyle(color: Colors.black, fontSize: 25)),
      ),
    );

    final forgetPassword = FlatButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ForgetPassWord()));
      },
      child: const Text(
        'Forgot Password',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );

    return Scaffold(
      key: loginController.scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.lightBlueAccent, Colors.white24])),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: loginController.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFieldInput(
                          textEditingController:
                              loginController.emailController,
                          hintText: "Enter Email",
                          textInputType: TextInputType.emailAddress,
                          icon: const Icon(Icons.email),
                          validation: Validator.validateEmail),
                      const SizedBox(height: 20),
                      TextFieldInput(
                        textEditingController:
                            loginController.passwordController,
                        hintText: "Enter Password",
                        textInputType: TextInputType.text,
                        icon: const Icon(Icons.lock),
                        validation: Validator.validatePassword,
                        isPass: true,
                      ),
                      const SizedBox(height: 20,),
                      forgetPassword,
                      const SizedBox(height: 20,),
                      loginButton,
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account ??"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Registration()));
                            },
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.blue[900]),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          child: Image.asset(
                            "assets/images/google-signin.png",
                            width: 250,
                          ),
                          onTap: () async {
                            try {
                              await FireBaseManager.signInWithGoogle();
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
