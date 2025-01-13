// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:unicons/unicons.dart';

class EditNote extends StatefulWidget {
  final note;
  const EditNote({super.key, this.note});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  File? myfile;

  final _foucs = FocusNode();
  final textFieldFocusNode = FocusNode();

  void initState() {
    title.text = widget.note['notes_title'];
    content.text = widget.note['notes_content'];

    textFieldFocusNode.addListener(() {
      textFieldFocusNode.hasFocus ? setState(() {}) : setState(() {});
    });

    _foucs.addListener(() {
      _foucs.hasFocus ? setState(() {}) : setState(() {});
    });
    super.initState();
  }

  Curd curd = Curd();

  bool isloding = false;

  editnote() async {
    if (formstate.currentState!.validate()) {
      isloding = true;
      var response;
      if (myfile == null) {
        response = await curd.postReq(linkEdit, {
          'title': title.text,
          'content': content.text,
          'imagename': widget.note['notes_img'],
          'id': widget.note['notes_id'].toString(),
        });
      } else {
        response = await curd.postFileReq(
            linkEdit,
            {
              'title': title.text,
              'content': content.text,
              'imagename': widget.note['notes_img'],
              'id': widget.note['notes_id'].toString(),
            },
            myfile!);
      }

      isloding = false;
      print(response);
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        print(response);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "edit note",
          style: TextStyle(fontFamily: 's', color: Colors.purple[100]),
        ),
      ),
      body: isloding
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
          : Form(
              key: formstate,
              child: Column(
                children: [
                  Image.asset('images/e.gif'),
                  SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.length <= 0) {
                        return "title can't be null";
                      }
                      return null;
                    },
                    controller: title,
                    focusNode: _foucs,
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: TextStyle(
                            fontFamily: 's',
                            color: _foucs.hasFocus
                                ? Color.fromARGB(255, 114, 152, 255)
                                : Colors.purple[200],
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 114, 152, 255),
                                width: 2.0),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 206, 147, 216),
                            ),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20)))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.length <= 0) {
                        return "content can't be null";
                      }
                      return null;
                    },
                    controller: content,
                    focusNode: textFieldFocusNode,
                    decoration: InputDecoration(
                        labelText: "Content",
                        labelStyle: TextStyle(
                            fontFamily: 's',
                            color: textFieldFocusNode.hasFocus
                                ? Color.fromARGB(255, 114, 152, 255)
                                : Colors.purple[200],
                            fontWeight: FontWeight.bold),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 114, 152, 255),
                                width: 2.0),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 206, 147, 216),
                            ),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20))),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20)))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Material(
                      color: Color.fromARGB(255, 107, 29, 29),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 140,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          XFile? xfile = await ImagePicker()
                                              .pickImage(
                                                  source: ImageSource.camera);
                                          if (xfile != null) {
                                            myfile = File(xfile.path);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "you didn't choose any image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                fontSize: 16.0);
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                UniconsLine.camera,
                                                size: 30,
                                              ),
                                              Text(
                                                "from camera",
                                                style: TextStyle(
                                                    fontFamily: 's',
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                        )),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (xfile != null) {
                                          myfile = File(xfile.path);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "you didn't choose any image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0);
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              UniconsLine.image,
                                              size: 30,
                                            ),
                                            Text(
                                              "from gallery",
                                              style: TextStyle(
                                                  fontFamily: 's',
                                                  fontSize: 18),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                            radius: 44,
                            backgroundColor: Colors.transparent,
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.photo,
                                  color: Color.fromARGB(255, 255, 215, 213),
                                ),
                                Text(
                                  "Image",
                                  style: TextStyle(
                                      fontFamily: 's',
                                      color: Color.fromARGB(255, 255, 215, 213),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  SwipeButton.expand(
                    thumb: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    activeThumbColor: Color.fromARGB(255, 226, 63, 255),
                    activeTrackColor: Color.fromARGB(255, 0, 0, 0),
                    onSwipe: () async {
                      await editnote();
                    },
                    child: Text(
                      'swipe to edit the note',
                      style: TextStyle(
                          fontFamily: 's',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
