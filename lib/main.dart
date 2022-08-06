import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logging/logging.dart';
import 'package:notime/bloc/notes.dart';
import 'package:notime/data/repositories/note_repository.dart';

import 'package:notime/pages/home_page.dart';
import 'package:notime/services/logging_service.dart';
import 'package:notime/theme/application_theme.dart';

import 'services/l10n_service.dart';
import 'services/mock_service.dart';

void main({bool useMocks = false}) async {
  await LoggingService.initialize();
  Directory directory =  Directory.systemTemp;
  final storage = await HydratedStorage.build(storageDirectory: directory);

  HydratedBlocOverrides.runZoned<Future<void>>(
    () async => runApp(MyApp(useMocks: useMocks)),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.useMocks = false}) : super(key: key);
  final bool useMocks;

  @override
  Widget build(BuildContext context) {
    INoteRepository noteRepository;

    if (useMocks) {
      MockService mockService = MockService()..initialize();
      noteRepository = mockService.noteRepository;
    } else {
      noteRepository = NoteRepository();
    }

    return AppWrapper(
      noteRepository: noteRepository,
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({
    required this.noteRepository,
  });
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
    notesBloc = NotesBloc();
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
