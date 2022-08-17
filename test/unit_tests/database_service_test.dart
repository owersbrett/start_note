import 'package:start_note/services/database_service.dart';
import 'package:test/test.dart';

void main() {
  test('DatabaseService.getCreateTableString should eliminate final space and comma of the schema list', () {
    String tableName = "NoteTable";
    List<String> schemaList = [
      "id INTEGER",
      "noteId INTEGER NOT NULL",
      "rowCount INTEGER",
      "columnCount INTEGER",
      "title TEXT",
      "PRIMARY KEY (id, noteId)"
    ];

    String createTableString = DatabaseService.getCreateTableString(schemaList, tableName);
    print(createTableString);

    assert(createTableString.endsWith(");"), "Table String should end closing paranthesis and semicolon");
    assert(!createTableString.endsWith(", );"), "Table String should not end with an extra comma");
    // assert(true);
  });
}
