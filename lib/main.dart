import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:start_note/bloc/app/app.dart';
import 'package:start_note/bloc/compare_table/compare_table_bloc.dart';
import 'package:start_note/data/repositories/note_repository.dart';
import 'package:start_note/data/repositories/note_table_repository.dart';
import 'package:start_note/pages/home_page.dart';
import 'package:start_note/services/logging_service.dart';
import 'package:start_note/theme/application_theme.dart';
import 'bloc/notes/notes.dart';
import 'services/database_service.dart';
import 'services/l10n_service.dart';

void main({bool useMocks = false}) async {
  runZoned<Future<void>>(
    () async {
      await WidgetsFlutterBinding.ensureInitialized();
      await LoggingService.initialize();

      Database database = await DatabaseService.initialize();
      HydratedBloc.storage = await HydratedStorage.build(
        storageDirectory: kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getTemporaryDirectory(),
      );
      runApp(MyApp(database, useMocks: useMocks));
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.db, {Key? key, this.useMocks = false}) : super(key: key);
  final bool useMocks;
  final Database db;

  @override
  Widget build(BuildContext context) {
    INoteRepository noteRepository;
    INoteTableRepository noteTableRepository;

    // if (useMocks) {
    //   // MockService mockService = MockService()..initialize();
    //   // noteRepository = mockService.noteRepository;
    // } else {
    // }
    noteRepository = NoteRepository(db);
    noteTableRepository = NoteTableRepository(db);

    return AppWrapper(
      noteRepository: noteRepository,
      noteTableRepository: noteTableRepository,
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    Key? key,
    required this.noteRepository,
    required this.noteTableRepository,
  }) : super(key: key);
  final INoteRepository noteRepository;
  final INoteTableRepository noteTableRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx) => noteRepository),
        RepositoryProvider(create: (ctx) => noteTableRepository),
      ],
      child: StartNote(
        noteRepository: noteRepository,
        noteTableRepository: noteTableRepository,
      ),
    );
  }
}

class StartNote extends StatefulWidget {
  const StartNote(
      {required this.noteRepository, required this.noteTableRepository});
  final INoteRepository noteRepository;
  final INoteTableRepository noteTableRepository;
  @override
  StartNoteState createState() => StartNoteState();
}

class StartNoteState extends State<StartNote> {
  late NotesBloc notesBloc;
  late AppBloc appBloc;
  late CompareTableBloc compareTableBloc;
  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
    compareTableBloc = CompareTableBloc(widget.noteTableRepository);
    notesBloc = NotesBloc(widget.noteRepository, widget.noteTableRepository)
      ..add(FetchNotes());
  }

  @override
  void dispose() {
    appBloc.close();
    notesBloc.close();
    compareTableBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => notesBloc),
        BlocProvider(create: (_) => appBloc),
        BlocProvider(create: (_) => compareTableBloc),
      ],
      child: MaterialApp(
        localizationsDelegates: L10nService.delegates,
        supportedLocales: L10nService.locales,
        locale: L10nService.defaultLocale,
        debugShowCheckedModeBanner: false,
        title: 'Start Note',
        home: const HomePage(),
        theme: ApplicationTheme.theme,
      ),
    );
  }
}
