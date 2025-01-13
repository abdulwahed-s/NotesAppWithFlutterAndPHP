// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:nots/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final textFieldFocusNode = FocusNode();
  final _foucs = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void initState() {
    textFieldFocusNode.addListener(() {
      textFieldFocusNode.hasFocus ? setState(() {}) : setState(() {});
    });

    _foucs.addListener(() {
      _foucs.hasFocus ? setState(() {}) : setState(() {});
    });
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();

  Curd curd = Curd();
  bool isLoading = false;

  Future<void> login() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      isLoading = true;
    });
    var response = await curd.postReq(
        linkLogin, {"username": email.text, "password": password.text});
    setState(() {
      isLoading = false;
    });
    if (response['status'] == 'success') {
      shared.setString('id', response['data']['id'].toString());
      shared.setString('username', response['data']['username']);
      shared.setString('email', response['data']['email']);
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
    } else {
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
              "username or password is incorrect.\nplease try logging in again.",
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
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 130,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('images/shar.png'))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                        key: formstate,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: email,
                              focusNode: _foucs,
                              decoration: InputDecoration(
                                  labelText: "Username",
                                  labelStyle: TextStyle(
                                      fontFamily: 's',
                                      color: _foucs.hasFocus
                                          ? Color.fromARGB(255, 185, 83, 233)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 110, 34, 133),
                                          width: 2.0),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)))),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            TextFormField(
                                controller: password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscured,
                                focusNode: textFieldFocusNode,
                                onTap: () {},
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                      fontFamily: 's',
                                      color: textFieldFocusNode.hasFocus
                                          ? Color.fromARGB(255, 185, 83, 233)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 110, 34, 133),
                                          width: 2.0),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          topLeft: Radius.circular(20))),
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                                    child: GestureDetector(
                                      onTap: _toggleObscured,
                                      child: Icon(
                                        color: textFieldFocusNode.hasFocus
                                            ? Color.fromARGB(255, 185, 83, 233)
                                            : Colors.red,
                                        _obscured
                                            ? Icons.visibility_off_rounded
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
                      text: 'Login',
                      textStyle: TextStyle(
                          fontSize: 22, fontFamily: 's', color: Colors.white),
                      isReverse: true,
                      selectedBackgroundColor: Color.fromARGB(255, 51, 0, 66),
                      selectedTextColor: Color.fromARGB(255, 204, 102, 252),
                      transitionType: TransitionType.LEFT_TOP_ROUNDER,
                      backgroundColor: const Color.fromARGB(255, 97, 4, 4),
                      borderRadius: 50,
                      onPress: () async {
                        await Future.delayed(Duration(seconds: 1),() {
                          login();
                        },);
                      },
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "don't have account? ",
                            style: TextStyle(
                                fontFamily: 's',
                                color: Colors.red,
                                fontSize: 20),
                          ),
                          InkWell(
                            child: Text("sign up",
                                style: TextStyle(
                                    fontFamily: 's',
                                    color: Color.fromARGB(255, 204, 102, 252),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.of(context).pushNamed('signup');
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
