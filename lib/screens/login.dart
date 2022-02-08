import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:dummy_pro/screens/home.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:dummy_pro/utils/validators.dart';
import 'package:dummy_pro/widgets/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forget_password.dart';
import 'registration.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkIfUserIsAlreadyLoggedIn();
  }

  checkIfUserIsAlreadyLoggedIn() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    if (sharedPreference.getBool("isLoggedIn") ?? false) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  void logInUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods().loginUser(
        email: emailController.text,
        password: passwordController.text,
      );

      if (res == "success") {
        SharedPreferences sharedPreference =
            await SharedPreferences.getInstance();
        sharedPreference.setBool("isLoggedIn", true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        showSnackBar(context, res);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: logInUser,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text("Login",
                style: TextStyle(color: Colors.black, fontSize: 25)),
      ),
    );

    final forgetPassword = FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassWord()));
      },
      child: const Text(
        'Forgot Password',
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );

    return Scaffold(
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
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFieldInput(
                          textEditingController: emailController,
                          hintText: "Enter Email",
                          textInputType: TextInputType.emailAddress,
                          icon: Icon(Icons.email),
                          validation: Validator.validateEmail),
                      SizedBox(height: 20),
                      TextFieldInput(
                        textEditingController: passwordController,
                        hintText: "Enter Password",
                        textInputType: TextInputType.text,
                        icon: Icon(Icons.lock),
                        validation: Validator.validatePassword,
                        isPass: true,
                      ),
                      forgetPassword,
                      loginButton,
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account ??"),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Registration()));
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
                      SizedBox(height: 20,),
                      GestureDetector(
                          child: Image.asset(
                            "assets/images/google-signin.png",
                            width: 250,
                          ),
                          onTap: () async{
                            try{
                            await FireBaseManager.signInWithGoogle();
                            } on FirebaseAuthException catch(e){
                              print(e.message);
                            }
                          }),
                      GestureDetector(
                          child: Image.asset(
                            "assets/images/facebook-signin.png",
                            width: 250,
                          ),
                          onTap: () {}),
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
