import 'package:logging/logging.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/data/models/note_table.dart';
import 'package:start_note/data/repositories/_repository.dart';
import 'package:start_note/services/logging_service.dart';
import 'package:sqflite/sqlite_api.dart';

import '../models/note_table_cell.dart';

abstract class INoteTableRepository<T extends NoteTable> extends Repository<NoteTable> {
  Future<List<NoteTableEntity>> getNoteTablesFromNoteId(int noteId);
  Future<NoteTableEntity> createNoteTableEntity(NoteTable t);
  Future<NoteTableCell> updateNoteTableCell(NoteTableCell noteTableCell);
  Future<NoteTableEntity> addRow(NoteTableEntity noteTable);
  Future<NoteTableEntity?> removeRow(NoteTableEntity noteTable);
  Future<NoteTableEntity> addColumn(NoteTableEntity noteTable);
  Future<NoteTableEntity?> removeColumn(NoteTableEntity noteTable);
  Future<void> deleteLastRow(NoteTableEntity noteTable);
}

class NoteTableRepository<T extends NoteTable> implements INoteTableRepository<NoteTable> {
  Database db;
  NoteTableRepository(this.db);
  String get tableName => NoteTable.tableName;

  @override
  Future<List<NoteTableEntity>> getNoteTablesFromNoteId(int noteId) async {
    return await db.transaction((txn) async {
      List<Map> list = await txn.rawQuery('SELECT * FROM $tableName WHERE noteId = ?', [noteId]);
      List<NoteTable> tables = list.map((e) => NoteTable.fromMap(Map<String, dynamic>.from(e))).toList();
      List<NoteTableEntity> entities = [];
      for (var table in tables) {
        List<NoteTableCell> cells = await getCellsFromNoteAndTableId(txn, noteId, table.id!);

        entities.add(NoteTableEntity.fromNoteTableAndCells(table, cells));
      }

      return entities;
    });
  }

  Future<List<NoteTableCell>> getCellsFromNoteAndTableId(Transaction txn, int noteId, int noteTableId) async {
    List<Map> list = await txn.rawQuery(
        'SELECT * FROM ${NoteTableCell.tableName} WHERE noteId = ? AND noteTableId = ?', [noteId, noteTableId]);
    return list.map((e) => NoteTableCell.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<NoteTableEntity> create(NoteTable t) async {
    // int noteTableId = await db.insert(tableName, t.toMap());
    // return t.copyWith(id: noteTableId);
    int noteTableId;
    NoteTableEntity entity;
    // await db.insert(tableName, t.toMap());
    return await db.transaction((txn) async {
      noteTableId = await txn.insert(NoteTable.tableName, t.toMap());
      NoteTableCell cellOneOne = await insertNoteTableCell(txn, t.noteId, noteTableId, 1, 1);
      NoteTableCell cellOneTwo = await insertNoteTableCell(txn, t.noteId, noteTableId, 1, 2);
      NoteTableCell cellTwoOne = await insertNoteTableCell(txn, t.noteId, noteTableId, 2, 1);
      NoteTableCell cellTwoTwo = await insertNoteTableCell(txn, t.noteId, noteTableId, 2, 2);

      List<NoteTableCell> cells = [cellOneOne, cellOneTwo, cellTwoOne, cellTwoTwo];
      entity = NoteTableEntity.fromNoteTableAndCells(t.copyWith(id: noteTableId), cells);
      Logger.root.info('inserted1: $noteTableId');
      return entity;
    });
  }

  Future<NoteTableCell> insertNoteTableCell(Transaction txn, int noteId, int noteTableId, int row, int column) async {
    NoteTableCell cell = NoteTableCell.create(noteId, noteTableId, row, column);
    int cellId = await txn.insert(NoteTableCell.tableName, cell.toMap());
    return cell.copyWith(id: cellId);
  }

  Future<bool> deleteNoteTableColumn(Transaction txn, int noteId, int noteTableId, int column) async {
    await txn.rawDelete('DELETE FROM ${NoteTableCell.tableName} WHERE noteId = ? AND noteTableId = ? AND column = ?',
        [noteId, noteTableId, column]);
    return true;
  }

  Future<bool> deleteNoteTableRow(Transaction txn, int noteId, int noteTableId, int row) async {
    await txn.rawDelete('DELETE FROM ${NoteTableCell.tableName} WHERE noteId = ? AND noteTableId = ? AND row = ?',
        [noteId, noteTableId, row]);
    return true;
  }

  @override
  Future<bool> delete(NoteTable t) async {
    try {
      await db.rawDelete('DELETE FROM $tableName WHERE id = ?', [t.id.toString()]);
    } catch (e) {
      LoggingService.logger.fine(e.toString());
      return false;
    }

    return true;
  }

  @override
  Future<NoteTable> getById(int id) async {
    List<Map> list = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    print(list.toString());
    return list.map((e) => NoteTable.fromMap(Map<String, dynamic>.from(e))).toList().first;
  }

  @override
  Future<bool> update(NoteTable t) async {
    int count = await db.rawUpdate(
        'UPDATE $tableName SET title = ?, createDateMillisecondsSinceEpoch = ?, updateDateMillisecondsSinceEpoch = ? WHERE id = ?',
        [t.title, t.createDate.millisecondsSinceEpoch, t.updateDate.millisecondsSinceEpoch, t.id]);
    print('updated: $count');
    return true;
  }

  @override
  Future<NoteTableEntity> createNoteTableEntity(NoteTable t) {
    return create(t);
  }

  @override
  Future<NoteTableCell> updateNoteTableCell(NoteTableCell noteTableCell) async {
    await db.rawUpdate(
        'UPDATE ${NoteTableCell.tableName} SET content = ? WHERE row = ? AND column = ? AND noteTableId = ?',
        [noteTableCell.content, noteTableCell.row, noteTableCell.column, noteTableCell.noteTableId]);
    return noteTableCell;
  }

  @override
  Future<NoteTableEntity> addColumn(NoteTableEntity noteTable) async {
    return await db.transaction((txn) async {
      int newColumnKey = noteTable.rowColumnTableMap[1]!.length + 1;
      for (var entry in noteTable.rowColumnTableMap.entries) {
        await insertNoteTableCell(txn, noteTable.noteId, noteTable.id!, entry.key, newColumnKey);
      }
      noteTable = noteTable.copyWithCells(await getCellsFromNoteAndTableId(txn, noteTable.noteId, noteTable.id!));
      return noteTable;
    });
  }

  @override
  Future<NoteTableEntity> addRow(NoteTableEntity noteTable) async {
    return await db.transaction((txn) async {
      int newRowKey = noteTable.rowCount + 1;
      noteTable.rowColumnTableMap[newRowKey] = {};
      for (var entry in noteTable.rowColumnTableMap[1]!.entries) {
        await insertNoteTableCell(txn, noteTable.noteId, noteTable.id!, newRowKey, entry.key);
      }
      noteTable = noteTable.copyWithCells(await getCellsFromNoteAndTableId(txn, noteTable.noteId, noteTable.id!));
      return noteTable;
    });
  }

  @override
  Future<NoteTableEntity?> removeColumn(NoteTableEntity noteTable) async {
    return await db.transaction((txn) async {
      int columnKeyToDelete = noteTable.columnCount;
      await deleteNoteTableColumn(txn, noteTable.noteId, noteTable.id!, columnKeyToDelete);
      List<NoteTableCell> cells = await getCellsFromNoteAndTableId(txn, noteTable.noteId, noteTable.id!);
      noteTable = noteTable.copyWithCells(cells);
      if (noteTable.cells.isEmpty) {
        await txn.rawDelete('DELETE FROM $tableName WHERE id = ?', [noteTable.id.toString()]);
        return null;
      }
      return noteTable;
    });
  }

  @override
  Future<NoteTableEntity?> removeRow(NoteTableEntity noteTable) async {
    return await db.transaction((txn) async {
      int rowKeyToDelete = noteTable.rowColumnTableMap.length;
      await deleteNoteTableRow(txn, noteTable.noteId, noteTable.id!, rowKeyToDelete);
      noteTable = noteTable.copyWithCells(await getCellsFromNoteAndTableId(txn, noteTable.noteId, noteTable.id!));
      if (noteTable.cells.isEmpty) {
        await txn.rawDelete('DELETE FROM $tableName WHERE id = ?', [noteTable.id.toString()]);
        return null;
      }
      return noteTable;
    });
  }

  @override
  Future<void> deleteLastRow(NoteTableEntity noteTable) async {
    await removeRow(noteTable);
  }
}
  // 'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, noteId INTEGER FOREIGN KEY, rowCount INTEGER, columnCount INTEGER, title TEXT, createDateMillisSinceEpoch INTEGER, updateDateMillisSinceEpoch INTEGER)';
