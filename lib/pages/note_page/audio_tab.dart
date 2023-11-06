import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:start_note/bloc/note_page/note_page_bloc.dart';
import 'package:start_note/data/entities/note_entity.dart';
import 'package:start_note/data/models/note_audio.dart';
import 'package:start_note/util/uploader.dart';
import '../../bloc/note_page/note_page.dart';
import '../../services/date_service.dart';
import '../../widget/common/audio_text_widget.dart';

class AudioTab extends StatefulWidget {
  const AudioTab(
      {Key? key,
      required this.notePageBloc,
      required this.noteEntity,
      required this.focusNode,
      required this.noteController,
      required this.onChanged})
      : super(key: key);
  final NoteEntity noteEntity;
  final FocusNode focusNode;
  final NotePageBloc notePageBloc;
  final TextEditingController noteController;
  final Function(int) onChanged;

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotePageBloc, NotePageState>(
      bloc: widget.notePageBloc,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.note.noteAudios.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (state.note.noteAudios.length == 0) {
              return MaterialButton(
                  onPressed: () async {
                    File? file = await Uploader.pickAndCopyAudioFile();
                    if (file != null) {
                      _audioPlayer.setFilePath(file.path);
                      widget.notePageBloc.add(AddNoteAudio(
                          NoteAudio.fromUpload(
                            file.path,
                            state.note.id!,
                            "",
                            _audioPlayer.duration ?? Duration.zero,
                          ),
                          _audioPlayer.position));
                    }
                  },
                  child: Text("Add audio"));
            }
            if (index == state.note.noteAudios.length) {
              return Container();
            }
            NoteAudio e = state.note.noteAudios[index];

            return AudioTextWidget(
                noteAudio: e,
                note: widget.noteEntity,
                notePageBloc: widget.notePageBloc,
                masterAudioPlayer: null);
          },
        );
      },
    );
  }
}
