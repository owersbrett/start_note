import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/bloc/compare_table/compare_table.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/entities/note_table_entity.dart';
import 'package:start_note/pages/note_page/table_display.dart';

import '../../bloc/note_page/note_page_bloc.dart';
import '../../bloc/note_page/note_page_events.dart';

class TableTab extends StatefulWidget {
  const TableTab({Key? key, required this.note, required this.notePageBloc}) : super(key: key);
  final NoteEntity note;
  final NotePageBloc notePageBloc;

  @override
  State<TableTab> createState() => _TableTabState();
}

class _TableTabState extends State<TableTab> {
  late NoteTableEntity selectedTable;
  late bool showPastTable;
  @override
  void initState() {
    super.initState();
    showPastTable = false;
    BlocProvider.of<CompareTableBloc>(context).add(EditTableHeader(widget.note));
  }

  void selectTable(NoteTableEntity noteTableEntity) {
    setState(() {
      selectedTable = noteTableEntity;
    });
    BlocProvider.of<CompareTableBloc>(context).add(SelectTable(noteTableEntity));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                itemCount: widget.note.noteTables.length,
                itemBuilder: (context, index) => TableDisplay(
                  noteTable: widget.note.noteTables[index],
                  notePageBloc: widget.notePageBloc,
                  isLast: widget.note.noteTables.length - 1 == index,
                  showPastTable: showPastTable,
                  noteEntity: widget.note,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<CompareTableBloc, CompareTableState>(
            builder: (context, state) {
              return Visibility(
                visible: state.similarTables.isNotEmpty,
                child: FloatingActionButton(
                  heroTag: "toggleEye",
                  child: showPastTable ? Icon(Icons.remove_red_eye) : Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      showPastTable = !showPastTable;
                    });
                  },
                ),
              );
            },
          ),
          FloatingActionButton(
            heroTag: "add",
            child: Icon(Icons.add),
            onPressed: () {
              widget.notePageBloc.add(AddTable());
            },
          ),
        ],
      ),
    );
  }
}
