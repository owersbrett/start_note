import 'dart:convert';

class NoteTableCell {
  final int id;
  final int tableId;
  final String content;
  final int row;
  final int column;
  NoteTableCell({
    required this.id,
    required this.tableId,
    required this.content,
    required this.row,
    required this.column,
  });

  NoteTableCell copyWith({
    int? id,
    int? tableId,
    String? content,
    int? row,
    int? column,
  }) {
    return NoteTableCell(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      content: content ?? this.content,
      row: row ?? this.row,
      column: column ?? this.column,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tableId': tableId,
      'content': content,
      'row': row,
      'column': column,
    };
  }

  factory NoteTableCell.fromMap(Map<String, dynamic> map) {
    return NoteTableCell(
      id: map['id']?.toInt() ?? 0,
      tableId: map['tableId']?.toInt() ?? 0,
      content: map['content'] ?? '',
      row: map['row']?.toInt() ?? 0,
      column: map['column']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory NoteTableCell.fromJson(String source) => NoteTableCell.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NoteTableCell(id: $id, tableId: $tableId, content: $content, row: $row, column: $column)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is NoteTableCell &&
      other.id == id &&
      other.tableId == tableId &&
      other.content == content &&
      other.row == row &&
      other.column == column;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      tableId.hashCode ^
      content.hashCode ^
      row.hashCode ^
      column.hashCode;
  }
}
