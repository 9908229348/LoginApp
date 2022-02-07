import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/screens/remainder.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  Note docToEdit;
  NoteView({required this.docToEdit});

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.docToEdit.title);
    descriptionController =
        TextEditingController(text: widget.docToEdit.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () {
                String result = FireBaseManager.delete(widget.docToEdit);
                if (result == "success") {
                  showSnackBar(context, "deleted successfully");
                  Navigator.pop(context);
                } else {
                  showSnackBar(
                      context, " somthing went wrong unable to delete");
                }
              },
              splashRadius: 17,
              icon: Icon(Icons.delete_outline)),
          IconButton(
              onPressed: () async {
                await FireBaseManager.editNote(Note(
                    id: widget.docToEdit.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    isArchieve: widget.docToEdit.isArchieve,
                    createdTime: widget.docToEdit.createdTime));
                Navigator.pop(context);
              },
              splashRadius: 17,
              icon: Icon(Icons.save_outlined)),
          IconButton(
              onPressed: () {
                widget.docToEdit.isArchieve = !widget.docToEdit.isArchieve;
                setState(() {
                });
                String result = FireBaseManager.archieveNote(widget.docToEdit.id, widget.docToEdit.isArchieve);
                if(result == 'Success'){
                  showSnackBar(context, widget.docToEdit.isArchieve ? "Note is Archieved successfully" : "Note is Unarchieved Successfully");
                }else{
                  showSnackBar(context, "Something went wrong");
                }
              },
              icon: Icon(widget.docToEdit.isArchieve
                  ? Icons.archive_rounded
                  : Icons.archive_outlined)),

          IconButton(
            splashRadius: 17,
            icon: Icon(Icons.alarm_add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RemainderPage(note: widget.docToEdit,)));
            },    
              )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                cursorColor: white,
                style: TextStyle(color: white),
                decoration: InputDecoration(
                    hintText: 'Title', border: InputBorder.none),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  cursorColor: white,
                  maxLines: null,
                  style: TextStyle(color: white),
                  expands: true,
                  decoration: InputDecoration(
                      hintText: 'Content', border: InputBorder.none),
                ),
              )
            ],
          )),
    );
  }
}
