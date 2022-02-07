import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/screens/base_home_page.dart';
import 'package:flutter/material.dart';

class ArchieveNotes extends BaseHomeView {
  const ArchieveNotes({Key? key}) : super(key: key);

  @override
  _ArchieveNotesState createState() => _ArchieveNotesState();
}

class _ArchieveNotesState extends BaseHomeViewState {
  @override
  fetchNotes(String queryType) async {
    if (allLoaded) {
      return;
    }
    setState(() {
      super.isFetchingNotes = true;
    });
    List<Note> newNotes = await FireBaseManager.fetchArchieveNotes(queryType);
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
