final String tableNotes = "notes";

class NoteFields{

  static final List<String> values = [
    id, title, description, time, isArchieve, isRemainded
  ];
  static final String id = "_id";
  static final String title = "title";
  static final String description = "description";
  static final String isArchieve = "isArchieve";
  static final String time = "time";
  static final String isRemainded = "isRemainded";
}

class Note{

  String? id;
  final String title;
  final String description;
  bool isArchieve;
  bool isRemainded;
  DateTime? createdTime;

  Note({this.id,required this.title, required this.description, this.isArchieve = false, this.isRemainded = false,  this.createdTime});

  static Note fromJson(Map<String, dynamic> json) => Note(
      id: json[NoteFields.id] as String,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      isArchieve : json[NoteFields.isArchieve] ?? false,
      isRemainded: json[NoteFields.isRemainded] ?? false,
      createdTime: json[NoteFields.time].toDate()

  );
  Map<String, dynamic> toJson(){
    return{
      NoteFields.id: id,
      NoteFields.title: title,
      NoteFields.description: description,
      NoteFields.isArchieve : isArchieve,
      NoteFields.isRemainded : isRemainded,
      NoteFields.time: createdTime
    };
  }

  Note copy({
    String? id,
    String? title,
    String? description,
    bool? isArchieve,
    bool? isRemainded,
    DateTime? createdTime
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isArchieve:isArchieve ?? this.isArchieve,
        isRemainded: isRemainded ?? this.isRemainded,
        createdTime: createdTime ?? this.createdTime,
      );
}