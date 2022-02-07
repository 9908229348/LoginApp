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

    switch (queryType) {
      case "fetchNotes":
        ref = _fireStore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .where('isArchieve', isEqualTo: false)
            .orderBy("time")
            .limit(10);
        break;
      default:
        if (lastDoc != null) {
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isArchieve', isEqualTo: false)
              .orderBy("time")
              .startAfterDocument(lastDoc!)
              .limit(10);
          print("----------inside more fetch----------");
        } else {
          print(
              "----------------------inside else of fetch----------------------------");
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isArchieve', isEqualTo: false)
              .orderBy("time")
              .limit(10);
        }
    }

    QuerySnapshot snapShot = await ref.get();
    final allData = snapShot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    lastDoc = snapShot.docs.last;
    return allData;
  }

  static Future<List<Note>> fetchArchieveNotes(String queryType) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;

    Query<Map<String, dynamic>> ref;

    switch (queryType) {
      case "fetchNotes":
        ref = _fireStore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .where('isArchieve', isEqualTo: true)
            .orderBy("time")
            .limit(10);
        break;
      default:
        if (lastDoc != null) {
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isArchieve', isEqualTo: true)
              .orderBy("time")
              .startAfterDocument(lastDoc!)
              .limit(10);
          print("----------inside more fetch----------");
        } else {
          print(
              "----------------------inside else of fetch----------------------------");
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isArchieve', isEqualTo: true)
              .orderBy("time")
              .limit(10);
        }
    }

    QuerySnapshot snapShot = await ref.get();
    final allData = snapShot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    lastDoc = snapShot.docs.last;
    return allData;
  }

  static Future<List<Note>> fetchRemaindedNotes(String queryType) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;

    Query<Map<String, dynamic>> ref;

    switch (queryType) {
      case "fetchNotes":
        ref = _fireStore
            .collection("users")
            .doc(uid)
            .collection("notes")
            .where('isRemainded', isEqualTo: true)
            .orderBy("time")
            .limit(10);
        break;
      default:
        if (lastDoc != null) {
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isRemainded', isEqualTo: true)
              .orderBy("time")
              .startAfterDocument(lastDoc!)
              .limit(10);
          print("----------inside more fetch----------");
        } else {
          print(
              "----------------------inside else of fetch----------------------------");
          ref = _fireStore
              .collection("users")
              .doc(uid)
              .collection("notes")
              .where('isRemainded', isEqualTo: true)
              .orderBy("time")
              .limit(10);
        }
    }

    QuerySnapshot snapShot = await ref.get();
    final allData = snapShot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
    print("============================$allData=========================");
    lastDoc = snapShot.docs.last;
    return allData;
  }


  static Future<String> addNote(Note note) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference documentReference =
        _fireStore.collection("users").doc(uid).collection("notes").doc();
    note.id = documentReference.id;
    documentReference.set(note.toJson());
    if (documentReference != null) {
      return "success";
    }
    return "something went wrong";
  }

  static Future<String> editNote(Note note) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference = _fireStore
        .collection("users")
        .doc(uid)
        .collection("notes")
        .doc(note.id);
    reference.update({'title': note.title, 'description': note.description});
    if (reference != null) {
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
        .collection("notes")
        .doc(note.id);
    reference.delete();
    if (reference != null) {
      reference.delete();
      return "success";
    }
    return "something went wrong";
  }

  static String archieveNote(String? noteId, bool isArchieve) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference =
        _fireStore.collection("users").doc(uid).collection("notes").doc(noteId);
    reference.update({'isArchieve': isArchieve});
    if (reference != null) {
      return "Success";
    }
    return "Something wrong";
  }

  static String remaindNote(String? noteId, bool isRemainded) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference =
        _fireStore.collection("users").doc(uid).collection("notes").doc(noteId);
    reference.update({'isRemainded': isRemainded});
    if (reference != null) {
      return "Success";
    }
    return "Something wrong";
  }
}
