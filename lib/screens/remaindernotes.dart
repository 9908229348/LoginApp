import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/screens/base_home_page.dart';
import 'package:flutter/material.dart';

class RemainderNotes extends BaseHomeView {
  const RemainderNotes({ Key? key }) : super(key: key);

  @override
  _RemainderNotesState createState() => _RemainderNotesState();
}

class _RemainderNotesState extends BaseHomeViewState {
  @override
  fetchNotes(String queryType) async {
    if (allLoaded) {
      return;
    }
    setState(() {
      super.isFetchingNotes = true;
    });
    List<Note> newNotes = await FireBaseManager.fetchRemaindedNotes(queryType);
    if (newNotes.isNotEmpty) {
      noteList.addAll(newNotes);
    }
    if (newNotes.length < noteLimit) {
      allLoaded = true;
    }
    setState(() {
      super.isFetchingNotes = false;
    });
  }
}