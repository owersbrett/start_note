import 'dart:convert';

class Note {
  final int id;
  final String content;
  final DateTime createDate;
  final DateTime updateDate;
  Note({
    required this.id,
    required this.content,
    required this.createDate,
    required this.updateDate,
  });

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
    return {
      'id': id,
      'content': content,
      'createDateMillisSinceEpoch': createDate.millisecondsSinceEpoch,
      'updateDateMillisSinceEpoch': updateDate.millisecondsSinceEpoch,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    print(map['id']);
    print(map['content']);
    print(map['createDateMillisSinceEpoch']);
    print(map['updateDateMillisSinceEpoch']);
    return Note(
      id: map['id']?.toInt() ?? 0,
      content: map['content'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDateMillisSinceEpoch']),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDateMillisSinceEpoch']),
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
