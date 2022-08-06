import 'dart:convert';

class Note {
  final int noteId;
  final String content;
  final DateTime createDate;
  final DateTime updateDate;
  Note({
    required this.noteId,
    required this.content,
    required this.createDate,
    required this.updateDate,
  });
  

  Note copyWith({
    int? noteId,
    String? content,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      content: content ?? this.content,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'content': content,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteId: map['noteId']?.toInt() ?? 0,
      content: map['content'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate']),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(noteId: $noteId, content: $content, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Note &&
      other.noteId == noteId &&
      other.content == content &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return noteId.hashCode ^
      content.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
