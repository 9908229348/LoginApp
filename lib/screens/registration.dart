import 'dart:typed_data';
import 'package:dummy_pro/resources/auth_methods.dart';
import 'package:dummy_pro/screens/home.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:dummy_pro/utils/validators.dart';
import 'package:dummy_pro/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Uint8List? image;
  bool isLoading = false;

  signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String res = await AuthMethods().signUpUser(
          email: emailEditingController.text,
          password: passwordEditingController.text,
          name: nameEditingController.text,
          file: image!);

      setState(() {
        isLoading = false;
      });
      if (res == "success") {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordController.text != passwordEditingController.text) {
          return "Password dont match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );

    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlueAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: signUp,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                "SignUp",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );

    void selectImage() async {
      Uint8List im = await pickImage(ImageSource.gallery);
      setState(() {
        image = im;
      });
    }

    return Scaffold(
        //key: RegistrationController.scaffoldKey,
        body: Stack(children: <Widget>[
      Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.lightBlueAccent, Colors.white24])),
      ),
      Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Stack(children: [
                    image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(image!),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.lightBlueAccent,
                          ),
                        ))
                  ]),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFieldInput(
                      textEditingController: nameEditingController,
                      hintText: "Enter name",
                      textInputType: TextInputType.text,
                      icon: const Icon(Icons.person_rounded),
                      validation: Validator.validateName),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                      textEditingController: emailEditingController,
                      hintText: "Enter Email",
                      textInputType: TextInputType.emailAddress,
                      icon: const Icon(Icons.email),
                      validation: Validator.validateEmail),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFieldInput(
                    textEditingController: passwordEditingController,
                    hintText: "Enter Password",
                    textInputType: TextInputType.text,
                    icon: const Icon(Icons.lock),
                    validation: Validator.validatePassword,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  confirmPasswordField,
                  const SizedBox(
                    height: 20,
                  ),
                  signUpButton,
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("Already have an account ??"),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'LogIn',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.blue[900]),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    ]));
  }
}
