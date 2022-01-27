import 'package:cloud_firestore/cloud_firestore.dart';


final String tableNotes = "notes";

class NoteFields{

  static final List<String> values = [
    id, title, description
  ];
  static final String id = "_id";
  static final String title = "title";
  static final String description = "description";
  //static final String time = "time";
}

class Note{
  
  late String? id;
  late final String title;
  late final String description;
  //late final DateTime? createdTime;

  Note({this.id,required this.title, required this.description, /*this.createdTime*/});

  // Note fromSnap(DocumentSnapshot snap){
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return Note(
  //     id: snapshot["id"],
  //     title: snapshot["title"],
  //     description: snapshot["description"]
  //   );
  // }


  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as String?,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
  );
  Map<String, dynamic> toJson(){
    return{
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
      //NoteFields.time: createdTime?.toIso8601String()
    };
  }

  Note copy({
    String? id,
    String? title,
    String? description,
    //DateTime? createdTime
  }) =>
  Note(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    //createdTime: createdTime ?? this.createdTime,
  );
}