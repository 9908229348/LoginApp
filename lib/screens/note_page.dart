import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/screens/remainder.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/utils.dart';
import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  Note noteToEdit;

  NoteView({Key? key, required this.noteToEdit}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.noteToEdit.title);
    descriptionController =
        TextEditingController(text: widget.noteToEdit.description);
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
                String result = FireBaseManager.delete(widget.noteToEdit);
                if (result == "success") {
                  showSnackBar(context, "deleted successfully");
                  Navigator.pop(context);
                } else {
                  showSnackBar(
                      context, " somthing went wrong unable to delete");
                }
              },
              splashRadius: 17,
              icon: const Icon(Icons.delete_outline)),
          IconButton(
              onPressed: () async {
                await FireBaseManager.editNote(Note(
                    id: widget.noteToEdit.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    isArchieve: widget.noteToEdit.isArchieve,
                    createdTime: widget.noteToEdit.createdTime));
                Navigator.pop(context);
              },
              splashRadius: 17,
              icon: const Icon(Icons.save_outlined)),
          IconButton(
              onPressed: () {
                widget.noteToEdit.isArchieve = !widget.noteToEdit.isArchieve;
                setState(() {});
                String result = FireBaseManager.archieveNote(
                    widget.noteToEdit.id, widget.noteToEdit.isArchieve);
                if (result == 'Success') {
                  showSnackBar(
                      context,
                      widget.noteToEdit.isArchieve
                          ? "Note is Archieved successfully"
                          : "Note is Unarchieved Successfully");
                } else {
                  showSnackBar(context, "Something went wrong");
                }
              },
              icon: Icon(widget.noteToEdit.isArchieve
                  ? Icons.archive_rounded
                  : Icons.archive_outlined)),
          IconButton(
            splashRadius: 17,
            icon: const Icon(Icons.alarm_add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RemainderPage(
                            note: widget.noteToEdit,
                          )));
            },
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                cursorColor: white,
                style: const TextStyle(color: white),
                decoration: const InputDecoration(
                    hintText: 'Title', border: InputBorder.none),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextField(
                  controller: descriptionController,
                  cursorColor: white,
                  maxLines: null,
                  style: const TextStyle(color: white),
                  expands: true,
                  decoration: const InputDecoration(
                      hintText: 'Content', border: InputBorder.none),
                ),
              )
            ],
          )),
    );
  }
}
