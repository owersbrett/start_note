import 'dart:convert';

import 'note.dart';

class NoteAudio {
  static const String tableName = "NoteAudio";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "noteId INTEGER",
    "filePath TEXT",
    "content TEXT",
    "ordinal INTEGER",
    "createDateMillisecondsSinceEpoch INTEGER",
    "updateDateMillisecondsSinceEpoch INTEGER",
    "FOREIGN KEY (noteId) REFERENCES ${Note.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION"
  ];

  final int? id;
  final int noteId;
  final String filePath;
  final String content;
  final int ordinal;
  final DateTime createDate;
  final DateTime updateDate;

  NoteAudio({
    this.id,
    required this.noteId,
    required this.filePath,
    required this.content,
    required this.ordinal,
    required this.createDate,
    required this.updateDate,
  });

  static List<NoteAudio> fromQuery(List<Map<String, dynamic>> query) {
    return query.map((e) => NoteAudio.fromMap(e)).toList();
  }

  factory NoteAudio.fromUpload(String filePath, int noteId, String content,
      [int index = 0]) {
    return NoteAudio(
      noteId: noteId,
      filePath: filePath,
      content: content,
      ordinal: index,
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
    );
  }

  List<NoteAudio> bufferedCut() {
    List<NoteAudio> noteAudios = [];

    return noteAudios;
  }

  NoteAudio copyWith(
      {int? id,
      int? noteId,
      String? filePath,
      String? content,
      int? index,
      DateTime? createDate,
      DateTime? updateDate}) {
    return NoteAudio(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      filePath: filePath ?? this.filePath,
      content: content ?? this.content,
      ordinal: index ?? this.ordinal,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'filePath': filePath,
      'content': content,
      'ordinal': ordinal,
      'createDateMillisecondsSinceEpoch': createDate.millisecondsSinceEpoch,
      'updateDateMillisecondsSinceEpoch': updateDate.millisecondsSinceEpoch,
    };
  }

  factory NoteAudio.fromMap(Map<String, dynamic> map) {
    return NoteAudio(
        id: map['id']?.toInt(),
        noteId: map['noteId']?.toInt() ?? 0,
        filePath: map['filePath'] ?? '',
        content: map['content'] ?? '',
        ordinal: map['ordinal']?.toInt() ?? 0,
        createDate: DateTime.fromMillisecondsSinceEpoch(
            map['createDate']?.toInt() ?? 0),
        updateDate: DateTime.fromMillisecondsSinceEpoch(
            map['updateDate']?.toInt() ?? 0));
  }

  String toJson() => json.encode(toMap());

  factory NoteAudio.fromJson(String source) =>
      NoteAudio.fromMap(json.decode(source));
}
