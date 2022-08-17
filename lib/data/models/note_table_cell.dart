import 'dart:convert';

import 'note.dart';
import 'note_table.dart';

class NoteTableCell {
  static const String tableName = "NoteTableCell";
  static const List<String> columnDeclarations = [
    "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL",
    "noteTableId INTEGER",
    "noteId INTEGER",
    "row INTEGER",
    "column INTEGER",
    "content TEXT",
    "FOREIGN KEY (noteTableId) REFERENCES ${NoteTable.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION",
    "FOREIGN KEY (noteId) REFERENCES ${Note.tableName}(id) ON DELETE CASCADE ON UPDATE NO ACTION"
  ];
  final int? id;
  final int noteTableId;
  final int noteId;
  final String content;
  final int row;
  final int column;
  NoteTableCell({
    this.id,
    required this.noteId,
    required this.noteTableId,
    required this.content,
    required this.row,
    required this.column,
  });

  static NoteTableCell create(int noteId, int noteTableId, int row, int column) {
    return NoteTableCell(
      noteId: noteId,
      noteTableId: noteTableId,
      content: "",
      row: row,
      column: column,
    );
  }

  NoteTableCell copyWith({
    int? id,
    int? noteId,
    int? noteTableId,
    String? content,
    int? row,
    int? column,
  }) {
    return NoteTableCell(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      noteTableId: noteTableId ?? this.noteTableId,
      content: content ?? this.content,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'noteId': noteId,
      'noteTableId': noteTableId,
      'content': content,
      'row': row,
      'column': column,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory NoteTableCell.fromMap(Map<String, dynamic> map) {
    return NoteTableCell(
      id: map['id']?.toInt() ?? 0,
      noteId: map['noteId']?.toInt() ?? 0,
      noteTableId: map['noteTableId']?.toInt() ?? 0,
      content: map['content'] ?? '',
      row: map['row']?.toInt() ?? 0,
      column: map['column']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteTableCell.fromJson(String source) => NoteTableCell.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoteTableCell(id: $id, noteId: $noteId, noteTableId: $noteTableId, content: $content, row: $row, column: $column)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteTableCell &&
        other.id == id &&
        other.noteId == noteId &&
        other.noteTableId == noteTableId &&
        other.content == content &&
        other.row == row &&
        other.column == column;
  }

  @override
  int get hashCode {
    return id.hashCode ^ noteId.hashCode ^ noteTableId.hashCode ^ content.hashCode ^ row.hashCode ^ column.hashCode;
  }
}
