import 'package:flutter/material.dart';
import 'package:start_note/data/models/note_table_cell.dart';

import '../data/entities/note_table_entity.dart';

class TableUtility {
  static NoteTableCell? nextEmptyCell(Map<int, Map<int, FocusNode>> rowColumnFocusNodes, NoteTableEntity entity, int currentRow, int currentColumn) {
    NoteTableCell? cell;
    Map<int, Map<int, String>> rowColumnCellContents = entity.rowColumnTableMap;


    return cell;
  }
}
