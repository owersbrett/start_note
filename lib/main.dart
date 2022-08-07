import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notime/data/repositories/note_repository.dart';
import 'package:notime/pages/home_page.dart';
import 'package:notime/services/logging_service.dart';
import 'package:notime/theme/application_theme.dart';
import 'bloc/notes/notes.dart';
import 'services/l10n_service.dart';

void main({bool useMocks = false}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LoggingService.initialize();
  Directory hydratedBlocStore = Directory.systemTemp;
  final storage = await HydratedStorage.build(storageDirectory: hydratedBlocStore);
  var databasesPath = await getDatabasesPath();
  String path = '$databasesPath/notime.db';

// open the database
  Database database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
    // When creating the db, create the table
    String createNoteTableString = INoteRepository.createNoteTableString;
    await db.execute(createNoteTableString);
  });

  HydratedBlocOverrides.runZoned<Future<void>>(
    () async => runApp(MyApp(database, useMocks: useMocks)),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp(this.db, {Key? key, this.useMocks = false}) : super(key: key);
  final bool useMocks;
  final Database db;

  @override
  Widget build(BuildContext context) {
    INoteRepository noteRepository;

    // if (useMocks) {
    //   // MockService mockService = MockService()..initialize();
    //   // noteRepository = mockService.noteRepository;
    // } else {
    // }
    noteRepository = NoteRepository(db);

    return AppWrapper(
      noteRepository: noteRepository,
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    Key? key,
    required this.noteRepository,
  }) : super(key: key);
  final INoteRepository noteRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx) => noteRepository),
      ],
      child: Notime(
        noteRepository: noteRepository,
      ),
    );
  }
}

class Notime extends StatefulWidget {
  const Notime({
    required this.noteRepository,
  });
  final INoteRepository noteRepository;
  @override
  _NotimeState createState() => _NotimeState();
}

class _NotimeState extends State<Notime> {
  late NotesBloc notesBloc;
  @override
  void initState() {
    super.initState();
    notesBloc = NotesBloc(widget.noteRepository)..add(FetchNotes());
  }

  @override
  void dispose() {
    notesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => notesBloc),
      ],
      child: MaterialApp(
        localizationsDelegates: L10nService.delegates,
        supportedLocales: L10nService.locales,
        locale: L10nService.defaultLocale,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const HomePage(),
        theme: ApplicationTheme.theme,
      ),
    );
  }
}
