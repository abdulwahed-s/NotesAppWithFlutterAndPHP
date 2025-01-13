// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:nots/main.dart';
import 'package:unicons/unicons.dart';
import 'package:path_provider/path_provider.dart'; // Add this for file system access

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  File? myfile;

  void initState() {
    textFieldFocusNode.addListener(() {
      textFieldFocusNode.hasFocus ? setState(() {}) : setState(() {});
    });

    _foucs.addListener(() {
      _foucs.hasFocus ? setState(() {}) : setState(() {});
    });
    super.initState();
    loadTransparentImage(); // Load the transparent image when initializing the state
  }

  // Method to load a transparent image as default
  Future<void> loadTransparentImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final transparentImagePath = '${directory.path}/transparent.png';

    // Here you would add your own logic to either create or find a transparent image
    // For simplicity, let's assume you have a transparent image asset`
    final byteData =
        await rootBundle.load('images/transparent.png'); // Load from assets
    final buffer = byteData.buffer;
    await File(transparentImagePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    myfile = File(
        transparentImagePath); // Set the default file as the transparent image
  }

  final _foucs = FocusNode();
  final textFieldFocusNode = FocusNode();

  Curd curd = Curd();

  bool isloding = false;

  addnote() async {
    if (formstate.currentState!.validate()) {
      isloding = true;
       setState(() {
        
      });
      var imageToUpload = myfile ?? File('path_to_transparent_image');
      var response = await curd.postFileReq(
          linkAdd,
          {
            'title': title.text,
            'content': content.text,
            'userid': shared.getString('id'),
          },
          imageToUpload);
      isloding = false;
      setState(() {
        
      });
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        print(response);
      }
    }
  }

  GlobalKey<FormState> formstate = GlobalKey();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "add notes",
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
              child: ListView(
                children: [
                  Image.asset('images/sa.gif'),
                  SizedBox(
                    height: 18,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
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
                                          } else
                                            Fluttertoast.showToast(
                                                msg:
                                                    "you didn't choose any image",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                fontSize: 16.0);
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
                                        } else
                                          Fluttertoast.showToast(
                                              msg:
                                                  "you didn't choose any image",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              fontSize: 16.0);
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
                    height: 16,
                  ),
                  SwipeButton.expand(
                    thumb: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    activeThumbColor: Color.fromARGB(255, 226, 63, 255),
                    activeTrackColor: Color.fromARGB(255, 0, 0, 0),
                    onSwipe: () async {
                      await addnote();
                    },
                    child: Text(
                      'swipe to add note',
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
