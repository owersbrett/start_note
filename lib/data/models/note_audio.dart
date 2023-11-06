import 'dart:convert';

import 'note.dart';

class NoteAudio {
  static const String tableName = "NoteAudio";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "noteId INTEGER",
    "filePath TEXT",
    "title TEXT",
    "content TEXT",
    "ordinal INTEGER",
    "createDateMillisecondsSinceEpoch INTEGER",
    "updateDateMillisecondsSinceEpoch INTEGER",
    "originalCutStartInMilliseconds INTEGER",
    "originalCutEndInMilliseconds INTEGER",
    "originalFilePath String",
    "FOREIGN KEY (noteId) REFERENCES ${Note.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION"
  ];

  final int? id;
  final int noteId;
  final String filePath;
  final String content;
  final int ordinal;
  final String title;
  final DateTime createDate;
  final DateTime updateDate;
  final Duration originalCutStart;
  final Duration originalCutEnd;
  final String originalFilePath;


  NoteAudio(
      {this.id,
      required this.noteId,
      required this.filePath,
      required this.content,
      required this.title,
      required this.ordinal,
      required this.createDate,
      required this.updateDate,
      required this.originalCutEnd,
      required this.originalCutStart,
      required this.originalFilePath});

  static List<NoteAudio> fromQuery(List<Map<String, dynamic>> query) {
    return query.map((e) => NoteAudio.fromMap(e)).toList();
  }

  factory NoteAudio.fromCopy(
      String filePath, int noteId, String content, Duration originalCutStart, Duration originalCutEnd,
      [int ordinal = 0, String title = '']) {
    return NoteAudio(
        noteId: noteId,
        title: title,
        filePath: filePath,
        content: content,
        ordinal: ordinal,
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
        originalCutStart: originalCutStart,
        originalCutEnd: originalCutEnd,
        originalFilePath: filePath);
  }
  factory NoteAudio.fromUpload(
      String filePath, int noteId, String content, Duration originalCutEnd,
      [int ordinal = 0, String title = '']) {
    return NoteAudio(
        noteId: noteId,
        title: title,
        filePath: filePath,
        content: content,
        ordinal: ordinal,
        createDate: DateTime.now(),
        updateDate: DateTime.now(),
        originalCutStart: Duration.zero,
        originalCutEnd: originalCutEnd,
        originalFilePath: filePath);
  }

  List<NoteAudio> bufferedCut() {
    List<NoteAudio> noteAudios = [];

    return noteAudios;
  }

  NoteAudio copyWith({
    int? id,
    int? noteId,
    String? filePath,
    String? content,
    int? index,
    DateTime? createDate,
    DateTime? updateDate,
    String? title,
    Duration? originalCutStart,
    Duration? originalCutEnd,
    String? originalFilePath,
  }) {
    return NoteAudio(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      filePath: filePath ?? this.filePath,
      content: content ?? this.content,
      ordinal: index ?? this.ordinal,
      title: title ?? this.title,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      originalCutStart: originalCutStart ?? this.originalCutStart,
      originalCutEnd: originalCutEnd ?? this.originalCutEnd,
      originalFilePath: originalFilePath ?? this.originalFilePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'filePath': filePath,
      'content': content,
      'title': title,
      'ordinal': ordinal,
      'createDateMillisecondsSinceEpoch': createDate.millisecondsSinceEpoch,
      'updateDateMillisecondsSinceEpoch': updateDate.millisecondsSinceEpoch,
      'originalCutStartInMilliseconds': originalCutStart.inMilliseconds,
      'originalCutEndInMilliseconds': originalCutEnd.inMilliseconds,
      'originalFilePath': originalFilePath,
    };
  }

  factory NoteAudio.fromMap(Map<String, dynamic> map) {
    return NoteAudio(
      id: map['id']?.toInt(),
      noteId: map['noteId']?.toInt() ?? 0,
      filePath: map['filePath'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      ordinal: map['ordinal']?.toInt() ?? 0,
      createDate:
          DateTime.fromMillisecondsSinceEpoch(map['createDate']?.toInt() ?? 0),
      updateDate:
          DateTime.fromMillisecondsSinceEpoch(map['updateDate']?.toInt() ?? 0),
        originalCutEnd: Duration(milliseconds: map['originalCutEndInMilliseconds']?.toInt() ?? 0),
        originalCutStart: Duration(milliseconds: map['originalCutStartInMilliseconds']?.toInt() ?? 0),
        originalFilePath: map['originalFilePath'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteAudio.fromJson(String source) =>
      NoteAudio.fromMap(json.decode(source));
}
