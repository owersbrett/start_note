import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start_note/common/stopwatch_app_bar.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import 'package:start_note/pages/note_page/table_tab.dart';
import '../bloc/app/app_bloc.dart';
import '../bloc/app/app_events.dart';
import '../bloc/compare_table/compare_table_bloc.dart';
import '../bloc/compare_table/compare_table_events.dart';
import '../bloc/note_page/note_page.dart';
import '../bloc/notes/notes.dart';
import '../data/repositories/note_repository.dart';
import 'note_page/note_tab.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key, required this.note}) : super(key: key);
  final NoteEntity note;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> with SingleTickerProviderStateMixin {
  late TextEditingController noteController;
  late NotePageBloc notePageBloc;
  late FocusNode focusNode;
  late TabController _controller;
  @override
  void initState() {
    super.initState();
    notePageBloc = NotePageBloc(
      widget.note,
      RepositoryProvider.of<INoteRepository>(context),
      RepositoryProvider.of<INoteTableRepository>(context),
    )..add(FetchNotePage());
    noteController = TextEditingController(text: widget.note.content);
    focusNode = FocusNode();
    _controller = TabController(
        length: 2, vsync: this, initialIndex: BlocProvider.of<AppBloc>(context).state.mostRecentNotePageTabIndex);

    _controller.addListener(_tabListener);
  }

  void _tabListener() {
    FocusScope.of(context).unfocus();
    BlocProvider.of<AppBloc>(context).add(TabBarTapped(_controller.index));
  }

  @override
  void dispose() {
    notePageBloc.close();
    _controller.removeListener(_tabListener);
    _controller.dispose();
    super.dispose();
  }

  void onChanged(int? id) {
    BlocProvider.of<NotesBloc>(context).add(UpdateNote(noteController.text, id!));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        BlocProvider.of<NotesBloc>(context).add(FetchNotes());
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx < 100) {
            Navigator.of(context).pop();
          }
        },
        child: BlocConsumer<NotePageBloc, NotePageState>(
          listener: (context, state) {
            if (state is NotePageLoaded) BlocProvider.of<CompareTableBloc>(context).add(FetchCompareTable(state.note));
          },
          bloc: notePageBloc,
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: StopwatchAppBar(
                key: ValueKey(state.note.id),
                notePageBloc: notePageBloc,
              ),
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    onTap: (value) {
                      FocusScope.of(context).unfocus();
                      BlocProvider.of<AppBloc>(context).add(TabBarTapped(value));
                    },
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    controller: _controller,
                    tabs: [
                      Tab(text: "Notes"),
                      Tab(text: "Tables"),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        NoteTab(
                          focusNode: focusNode,
                          note: state.note,
                          noteController: noteController,
                          onChanged: onChanged,
                        ),
                        TableTab(note: state.note, notePageBloc: notePageBloc)
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
