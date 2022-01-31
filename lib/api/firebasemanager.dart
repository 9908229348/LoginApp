import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseManager {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static QueryDocumentSnapshot? lastDoc;


  static Future<List<Note>> fetchNotes(String queryType) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;

    Query<Map<String, dynamic>> ref;

    switch(queryType){
       case "fetchNotes":
         ref = _fireStore.collection("users").doc(uid).collection("notes").orderBy("title").limit(10);
         break;
      default:
        if(lastDoc != null) {
        ref = _fireStore.collection("users").doc(uid).collection("notes")
            .orderBy("title").startAfterDocument(lastDoc!)
            .limit(10);
      }
        ref = _fireStore.collection("users").doc(uid).collection("notes").orderBy("title").limit(10);
    }

    QuerySnapshot snapShot = await ref.get();
    final allData = snapShot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    lastDoc = snapShot.docs.last;
    print(lastDoc);
    print(allData);
    print("++++++=========+================ inside fetchnote");
    return allData;
  }

  // static Future<List<Note>> fetchMoreNotes() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   var uid = _auth.currentUser?.uid;
  //   List<Note> allData = [];
  //
  //   if(lastDoc != null){
  //     Query<Map<String, dynamic>> ref =
  //     _fireStore.collection("users").doc(uid).collection("notes").orderBy("title").startAfterDocument(lastDoc!).limit(10);
  //     QuerySnapshot snapShot = await ref.get();
  //     allData = snapShot.docs
  //         .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //     lastDoc = snapShot.docs.last;
  //     print(allData);
  //     print("++++++=========+================");
  //   }
  //   return allData;
  // }

  static Future<String> addNote(Note note) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference documentReference = _fireStore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .doc();
    note.id = documentReference.id;
    print("----------------------Inside add Note-----------${note.toJson()}");
    documentReference.set(note.toJson());
    if (documentReference != null) {
      print("successsssssssssssssssssssssss $documentReference");
      return "success";
    }
    return "something went wrong";
  }

  static Future<String> editNote(Note note) async{
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference = _fireStore
        .collection("users")
        .doc(uid)
        .collection("notes").doc(note.id);
    print("///////////////////////");
    print(reference.toString());
    reference.update({'title': note.title, 'description': note.description});
    if(reference != null){
      print("EEEEEEEEEEEEEEEEEEEEEEEEE");
      return "Success";
    }
    return "Something wrong";
  }

  static String delete(Note note) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference = _fireStore
        .collection("users")
        .doc(uid)
        .collection("notes").doc(note.id);
    print("///////////////////////");
    print(reference.toString());
    reference.delete();
    if(reference != null){
      reference.delete();
      print("//////////////////////////////");
      print(reference.toString());
      return "success";
    }
    return "something went wrong";
  }
}
