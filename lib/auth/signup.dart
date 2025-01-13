// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:nots/main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final textFieldFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, don't unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  void initState() {
    super.initState();

    textFieldFocusNode.addListener(() {
      setState(() {});
    });

    emailFocusNode.addListener(() {
      setState(() {});
    });

    usernameFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    emailFocusNode.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  final Curd _curd = Curd();
  bool isLoading = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formState = GlobalKey();

  Future<void> signup() async {
    await Future.delayed(Duration(seconds: 1));
    try {
      setState(() {
        isLoading = true;
      });
      var response = await _curd.postReq(linkSignup, {
        "username": username.text,
        "email": email.text,
        "password": password.text,
      });
      setState(() {
        isLoading = false;
      });
      if (response['status'] == "success") {
        shared.setString('id', response['data']['id'].toString());
        shared.setString('username', response['data']['username']);
        shared.setString('email', response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {}
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Column(
          children: [
            Image.asset("images/boro.gif"),
            SizedBox(
              height: 12,
            ),
            Text(
              "error\naccount with this email or username already exist",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 's',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 0, 0)),
            )
          ],
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/itachi.gif"),
                        fit: BoxFit.cover)),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                )),
              ),
            )
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/shar.png'))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Form(
                                key: formState,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: username,
                                      focusNode: usernameFocusNode,
                                      onChanged: (value) {
                                        formState.currentState!.validate();
                                      },
                                      validator: (value) {
                                        if (value!.length > 20) {
                                          return "Username can't be longer than 20 letters";
                                        }
                                        if (value.length < 2) {
                                          return "Username can't be less than 2 letters";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Username",
                                          labelStyle: TextStyle(
                                              fontFamily: 's',
                                              color: usernameFocusNode.hasFocus
                                                  ? Color.fromARGB(
                                                      255, 185, 83, 233)
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 110, 34, 133),
                                                  width: 2.0),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.only(bottomRight: Radius.circular(20), topLeft: Radius.circular(20))),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topLeft: Radius.circular(20)))),
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    TextFormField(
                                      controller: email,
                                      focusNode: emailFocusNode,
                                      onChanged: (value) {
                                        formState.currentState!.validate();
                                      },
                                      validator: (value) {
                                        RegExp emailValidator = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                        if (!emailValidator.hasMatch(value!)) {
                                          return "Please enter a valid email";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                              fontFamily: 's',
                                              color: emailFocusNode.hasFocus
                                                  ? Color.fromARGB(
                                                      255, 185, 83, 233)
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 110, 34, 133),
                                                  width: 2.0),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight: Radius.circular(20),
                                                  topLeft: Radius.circular(20))),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topLeft: Radius.circular(20)))),
                                    ),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    TextFormField(
                                        controller: password,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        obscureText: _obscured,
                                        focusNode: textFieldFocusNode,
                                        onChanged: (value) {
                                          formState.currentState!.validate();
                                        },
                                        validator: (value) {
                                          RegExp passwordValidator = RegExp(
                                              r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
                                          if (!passwordValidator
                                              .hasMatch(value!)) {
                                            return "Please enter a strong password";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          labelStyle: TextStyle(
                                              fontFamily: 's',
                                              color: textFieldFocusNode.hasFocus
                                                  ? Color.fromARGB(
                                                      255, 185, 83, 233)
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 110, 34, 133),
                                                  width: 2.0),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.red),
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  topLeft:
                                                      Radius.circular(20))),
                                          suffixIcon: Padding(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 0, 4, 0),
                                            child: GestureDetector(
                                              onTap: _toggleObscured,
                                              child: Icon(
                                                color:
                                                    textFieldFocusNode.hasFocus
                                                        ? Color.fromARGB(
                                                            255, 185, 83, 233)
                                                        : Colors.red,
                                                _obscured
                                                    ? Icons
                                                        .visibility_off_rounded
                                                    : Icons.visibility_rounded,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: AnimatedButton(
                              height: 70,
                              width: 200,
                              text: 'Signup',
                              isReverse: true,
                              textStyle: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 's',
                                  color: Colors.white),
                              selectedBackgroundColor:
                                  Color.fromARGB(255, 51, 0, 66),
                              selectedTextColor:
                                  Color.fromARGB(255, 204, 102, 252),
                              transitionType: TransitionType.LEFT_TOP_ROUNDER,
                              backgroundColor:
                                  const Color.fromARGB(255, 97, 4, 4),
                              borderRadius: 50,
                              onPress: () async {
                                if (formState.currentState!.validate()) {
                                  await signup();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 16.0), // Adjust padding as needed
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                                fontFamily: 's',
                                color: Colors.red,
                                fontSize: 20),
                          ),
                          InkWell(
                            child: Text("Log in",
                                style: TextStyle(
                                    fontFamily: 's',
                                    color: Color.fromARGB(255, 204, 102, 252),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('login');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
