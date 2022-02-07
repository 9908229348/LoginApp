import 'package:dummy_pro/api/firebasemanager.dart';
import 'package:dummy_pro/component/custom_search_bar.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:dummy_pro/model/user.dart';
import 'package:dummy_pro/screens/profile.dart';
import 'package:dummy_pro/screens/side_menubar.dart';
import 'package:dummy_pro/utils/colors.dart';
import 'package:dummy_pro/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'addnote.dart';
import 'note_page.dart';

class BaseHomeView extends StatefulWidget {
  const BaseHomeView({Key? key}) : super(key: key);

  @override
  BaseHomeViewState createState() => BaseHomeViewState();
}

class BaseHomeViewState extends State<BaseHomeView> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel? loginUser;

  bool isGridView = false;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  TextEditingController textEditingController = TextEditingController();

  List<Note> noteList = [];
  List<Note> filteredNoteList = [];

  bool isSearchMode = false;
  int noteLimit = 10;
  bool isFetchingNotes = false;
  bool allLoaded = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNotes(Constants.FETCH_NOTES);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !isFetchingNotes) {
        fetchNotes(Constants.FETCH_MORE_NOTES);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // void searchNotes(String enteredWord) {
  //   List<Note> results = [];
  //   print("77777777777777777777777777");
  //   print(enteredWord);
  //   if (enteredWord.isEmpty) {
  //     print("888888888888888");
  //     results = noteList;
  //   } else {
  //     results = noteList
  //         .where((note) =>
  //             note.title.toLowerCase().contains(enteredWord.toLowerCase()))
  //         .toList();
  //     print("result isssssssssss ${results.toString()}");
  //   }

  //   setState(() {
  //     foundNotes = results;
  //   });
  // }

  void searchNotes(String enteredWord) {
    filteredNoteList.clear();

    isSearchMode = true;
    print("77777777777777777777777777");
    print(enteredWord);
    if (enteredWord.isEmpty) {
      print("888888888888888");
      isSearchMode = false;
      setState(() {});
      //filteredNoteList = noteList;
    } else {
      filteredNoteList = noteList
          .where((note) =>
              note.title.toLowerCase().contains(enteredWord.toLowerCase()))
          .toList();
      print("result isssssssssss ${filteredNoteList.toString()}");
    }

    setState(() {
      //foundNotes = filteredNoteList;
    });
  }

  fetchNotes(String queryType) async {
    if (allLoaded) {
      return;
    }
    setState(() {
      isFetchingNotes = true;
    });
    List<Note> newNotes = await FireBaseManager.fetchNotes(queryType);
    if (newNotes.isNotEmpty) {
      noteList.addAll(newNotes);
    }
    if (newNotes.length < noteLimit) {
      allLoaded = true;
    }
    setState(() {
      isFetchingNotes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(filteredNoteList.length);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        splashColor: bgColor,
        elevation: 1.0,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 40.0,
        ),
        backgroundColor: cardColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNote()));
        },
      ),
      endDrawerEnableOpenDragGesture: true,
      key: _drawerKey,
      drawer: SideMenu(),
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3)
                      ]),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              _drawerKey.currentState!.openDrawer();
                            },
                            icon: Icon(Icons.menu),
                            color: white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CustomSearchBar(searchInputCallBack: (value) {
                            searchNotes(value);
                          })
                        ],
                      ),
                      TextButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateColor.resolveWith(
                                  (states) => white.withOpacity(0.1)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ))),
                          onPressed: () {
                            isGridView = !isGridView;
                            setState(() {});
                          },
                          child: Icon(
                            isGridView == true
                                ? Icons.list_outlined
                                : Icons.grid_view,
                            color: white,
                          )),
                      IconButton(
                        icon: Icon(Icons.perm_contact_cal_rounded,
                            color: white.withOpacity(0.7)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                      ),
                    ],
                  ),
                ),
                NotesGridView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget NotesGridView() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: (!isSearchMode && filteredNoteList.isEmpty)
            ? StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount:
                    isSearchMode ? filteredNoteList.length : noteList.length,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                crossAxisCount: 4,
                staggeredTileBuilder: (index) =>
                    StaggeredTile.fit(isGridView == true ? 2 : 4),
                itemBuilder: (context, index) {
                  Note note =
                      isSearchMode ? filteredNoteList[index] : noteList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoteView(docToEdit: note)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: white.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            note.description,
                            style: TextStyle(color: white),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : Text(
                "No Results",
                style: TextStyle(color: white),
              ));
  }
}
