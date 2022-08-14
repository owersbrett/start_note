import 'package:start_note/data/models/note_table_cell.dart';

import '../models/note_table.dart';

class NoteTableEntity extends NoteTable {
  final List<NoteTableCell> cells;

  Map<int, Map<int, String>> get rowColumnTableMap {
    Map<int, Map<int, String>> map = {};
    cells.forEach((element) {
      if (map[element.row] == null) {
        map[element.row] = {};
      }
      map[element.row]![element.column] = element.content;
    });
    return map;
  }

  int get rowCount {
    Set uniqueRows = {};
    cells.forEach((element) {
      uniqueRows.add(element.row);
    });
    return uniqueRows.length;
  }
  int get columnCount {
    Set uniqueColumns = {};
    cells.forEach((element) {
      uniqueColumns.add(element.column);
    });
    return uniqueColumns.length;
  }

  NoteTableEntity({
    super.id,
    required super.noteId,
    required super.title,
    required super.createDate,
    required super.updateDate,
    this.cells = const [],
  });

  static NoteTableEntity fromNoteTableAndCells(NoteTable noteTable, List<NoteTableCell> cells) {
    NoteTableEntity entity = NoteTableEntity(
      id: noteTable.id,
      noteId: noteTable.noteId,
      title: noteTable.title,
      createDate: noteTable.createDate,
      updateDate: noteTable.updateDate,
    );
    return entity.copyWithCells(cells);
  }

  NoteTableEntity copyWithCells(List<NoteTableCell> cells) {
    return NoteTableEntity(
      id: id,
      noteId: noteId,
      title: title,
      createDate: createDate,
      updateDate: updateDate,
      cells: List<NoteTableCell>.from(cells),
    );
  }
}
