// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:nots/main.dart';
import 'package:nots/screens/viewnote.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Curd curd = Curd();

  getNotes() async {
    var response = await curd.postReq(linkView, {"id": shared.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('add');
        },
      ),
      body: FutureBuilder(
        future: getNotes(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            if (snapshot.data['data'] != null &&
                snapshot.data['data'] is List) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data['data'].length,
                itemBuilder: (context, index) {
                  final note = snapshot.data['data'][index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewNote(
                          note: note,
                        ),
                      ));
                    },
                    child: Column(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(1, 1))
                              ],
                              color: Color.fromARGB(171, 61, 61, 61)),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${note['notes_title'] ?? 'No Title'}",
                                      style: TextStyle(
                                          fontFamily: 's',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24),
                                    ),
                                    Text(
                                      "${note['notes_content'] ?? 'No Content'}",
                                      style: TextStyle(
                                          fontFamily: 's', fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                           
                                    image: note['notes_img'] != null
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                '$linkImage/${note['notes_img']}'),
                                            fit: BoxFit.cover)
                                        : null),
                                height: 120,
                                width: 140,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("No notes available"));
            }
          } else {
            return Center(child: Text("Unexpected error"));
          }
        },
      ),
    );
  }
}
