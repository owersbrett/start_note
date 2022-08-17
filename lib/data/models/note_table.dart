import 'dart:convert';
import '../entities/note_entity.dart';
import 'note.dart';

class NoteTable {
  static const String tableName = "NoteTable";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "noteId INTEGER",
    "title TEXT",
    "createDateMillisecondsSinceEpoch INTEGER",
    "updateDateMillisecondsSinceEpoch INTEGER",
    "FOREIGN KEY (noteId) REFERENCES ${Note.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION"
  ];

  final int? id;
  final int noteId;
  final String title;
  final DateTime createDate;
  final DateTime updateDate;
  NoteTable({
    this.id,
    required this.noteId,
    required this.title,
    required this.createDate,
    required this.updateDate,
  });


  static NoteTable createFromNoteEntity(NoteEntity note) {
    return NoteTable(
      noteId: note.id!,
      title: "",
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
    );
  }

  NoteTable copyWith({
    int? id,
    int? noteId,
    String? title,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return NoteTable(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'noteId': noteId,
      'title': title,
      'createDateMillisecondsSinceEpoch': createDate.millisecondsSinceEpoch,
      'updateDateMillisecondsSinceEpoch': updateDate.millisecondsSinceEpoch,
    };
    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  factory NoteTable.fromMap(Map<String, dynamic> map) {
    return NoteTable(
      id: map['id']?.toInt() ?? 0,
      noteId: map['noteId']?.toInt() ?? 0,
      title: map['title'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDateMillisecondsSinceEpoch']),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDateMillisecondsSinceEpoch']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteTable.fromJson(String source) => NoteTable.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoteTable(id: $id, noteId: $noteId, title: $title, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteTable &&
        other.id == id &&
        other.noteId == noteId &&
        other.title == title &&
        other.createDate == createDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        noteId.hashCode ^
        title.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode;
  }
}
