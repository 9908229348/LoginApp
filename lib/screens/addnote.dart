import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddNote extends StatefulWidget {

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(onPressed: () async{
            Note note = Note(title: titleEditingController.text, description: descriptionEditingController.text);
            String result = await FireBaseManager.addNote(note);
            if(result == "success"){
              showSnackBar(context, "Note is added successfully");
              Navigator.pop(context);
            }else{
              showSnackBar(context, "something went wrong");
            }
          },
          splashRadius: 17, 
          icon: Icon(Icons.save_outlined))
        ],
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: titleEditingController,
              cursorColor: white,
              style: TextStyle(fontSize: 25, color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "Title",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey.withOpacity(0.8)
                )
              )
            ),
            Container(
              height: 190,
              child: TextField(
                controller: descriptionEditingController,
                cursorColor: white,
                keyboardType: TextInputType.multiline,
                minLines: 50,
                maxLines: null,
                style: TextStyle(fontSize: 17, color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: "Note",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.8)
                  )
                ),
              ))
          ],
        ),
      ),
    );
  }
}