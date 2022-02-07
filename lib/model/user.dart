import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? photoUrl;

  UserModel({this.uid, this.email, this.name, this.photoUrl});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        photoUrl: map['photoUrl']);
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        name: snapshot["name"],
        uid: snapshot['uid'],
        email: snapshot["email"],
        photoUrl: snapshot['photoUrl']);
  }
}
