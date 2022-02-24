import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy_pro/model/note.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        } else {
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
        } else {
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
        } else {
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
    return "success";
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
    return "Success";
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
      return "success";
  }

  static String archieveNote(String? noteId, bool isArchieve) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference =
        _fireStore.collection("users").doc(uid).collection("notes").doc(noteId);
    reference.update({'isArchieve': isArchieve});
      return "Success";
  }

  static String remaindNote(String? noteId, bool isRemainded) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var uid = _auth.currentUser?.uid;
    DocumentReference reference =
        _fireStore.collection("users").doc(uid).collection("notes").doc(noteId);
    reference.update({'isRemainded': isRemainded});
      return "Success";
  }

  static Future<String?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return "success";
  }
}
