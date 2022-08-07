import 'dart:convert';

class NoteTable {
  final int id;
  final int noteId;
  final int rowCount;
  final int columnCount;
  final String title;
  final DateTime createDate;
  final DateTime updateDate;
  NoteTable({
    required this.id,
    required this.noteId,
    required this.rowCount,
    required this.columnCount,
    required this.title,
    required this.createDate,
    required this.updateDate,
  });

  NoteTable copyWith({
    int? id,
    int? noteId,
    int? rowCount,
    int? columnCount,
    String? title,
    DateTime? createDate,
    DateTime? updateDate,
  }) {
    return NoteTable(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      rowCount: rowCount ?? this.rowCount,
      columnCount: columnCount ?? this.columnCount,
      title: title ?? this.title,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'rowCount': rowCount,
      'columnCount': columnCount,
      'title': title,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate.millisecondsSinceEpoch,
    };
  }

  factory NoteTable.fromMap(Map<String, dynamic> map) {
    return NoteTable(
      id: map['id']?.toInt() ?? 0,
      noteId: map['noteId']?.toInt() ?? 0,
      rowCount: map['rowCount']?.toInt() ?? 0,
      columnCount: map['columnCount']?.toInt() ?? 0,
      title: map['title'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate']),
      updateDate: DateTime.fromMillisecondsSinceEpoch(map['updateDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteTable.fromJson(String source) => NoteTable.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoteTable(id: $id, noteId: $noteId, rowCount: $rowCount, columnCount: $columnCount, title: $title, createDate: $createDate, updateDate: $updateDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NoteTable &&
      other.id == id &&
      other.noteId == noteId &&
      other.rowCount == rowCount &&
      other.columnCount == columnCount &&
      other.title == title &&
      other.createDate == createDate &&
      other.updateDate == updateDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      noteId.hashCode ^
      rowCount.hashCode ^
      columnCount.hashCode ^
      title.hashCode ^
      createDate.hashCode ^
      updateDate.hashCode;
  }
}
