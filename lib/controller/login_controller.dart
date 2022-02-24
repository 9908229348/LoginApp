import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ControllerMVC {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  LoginController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<String> logInUser() async {
    if (formKey.currentState?.validate() ?? false) {
      String res = await AuthMethods().loginUser(
        email: emailController.text,
        password: passwordController.text,
      );
      if (res == "success") {
        SharedPreferences sharedPreference =
            await SharedPreferences.getInstance();
        sharedPreference.setBool("isLoggedIn", true);
        return "Login successfully";
      }
      return "Something Went wrong";
    }
    return "";
  }
}
