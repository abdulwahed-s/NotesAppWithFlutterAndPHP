// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:nots/components/curd.dart';
import 'package:nots/constant/apilink.dart';
import 'package:nots/screens/editnote.dart';

class ViewNote extends StatefulWidget {
  final note;
  const ViewNote({super.key, this.note});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    Curd curd = Curd();

    deleteNote() async {
      var response = await curd.postReq(linkDelete, {
        'id': widget.note['notes_id'].toString(),
        'imgname': widget.note['notes_img'],
      });
      print(response);
      if (response['status'] == 'success') {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
      } else {
        print(response);
      }
    }

    void handleClick(String value) {
      switch (value) {
        case 'Edit':
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditNote(note: widget.note),
          ));
          break;
        case 'Delete':
          deleteNote();
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note['notes_title'],
          style: TextStyle(
              fontFamily: 's',
              color: Colors.purple[100],
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Edit', 'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(
                        fontFamily: 's',
                        color: Colors.purple[300],
                        fontWeight: FontWeight.bold),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Text(
            widget.note['notes_content'],
            style: TextStyle(
                fontFamily: 's',
                fontSize: 22,
                color: Colors.pink[300],
                fontWeight: FontWeight.bold),
          ),
          Image.network('$linkImage/${widget.note['notes_img']}')
        ],
      ),
    );
  }
}
