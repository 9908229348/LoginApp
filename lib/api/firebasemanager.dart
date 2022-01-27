import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseManager {
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static Future<List<Note>> fetchNotes() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    CollectionReference ref =
        _fireStore.collection("users").doc(uid).collection("notes");
    QuerySnapshot snapShot = await ref.get();
    final allData = snapShot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    print(allData);
    print("++++++=========+================");
    return allData;
  }

  static Future<String> addNote(Note note) async {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference documentReference = _fireStore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .doc();
    note.id = documentReference.id;
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
