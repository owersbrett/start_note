import 'dart:convert';

class Note {
  static const String tableName = "Note";

  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "content TEXT",
    "createDateMillisecondsSinceEpoch INTEGER",
    "updateDateMillisecondsSinceEpoch INTEGER",
  ];

  final int? id;
  final String content;
  final DateTime createDate;
  final DateTime updateDate;
  Note({
    this.id,
    required this.content,
    required this.createDate,
    required this.updateDate,
  });
  static Note create() {
    return Note(
      content: "",
      createDate: DateTime.now(),
      updateDate: DateTime.now(),
    );
  }

  Note copyWith({
    int? id,
    String? content,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'content': content,
      'createDateMillisecondsSinceEpoch': createDate.millisecondsSinceEpoch,
      'updateDateMillisecondsSinceEpoch': updateDate.millisecondsSinceEpoch,
    };
    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDateMillisecondsSinceEpoch']),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDateMillisecondsSinceEpoch']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, content: $content, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.id == id &&
        other.content == content &&
        other.createDate == createDate &&
        other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^ content.hashCode ^ createDate.hashCode ^ updateDate.hashCode;
  }
}
