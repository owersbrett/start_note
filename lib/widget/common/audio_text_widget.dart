import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:start_note/data/models/note_audio.dart';

import '../../bloc/note_page/note_page.dart';
import '../../data/models/note.dart';

class AudioTextWidget extends StatefulWidget {
  final AudioPlayer? masterAudioPlayer;
  final NoteAudio noteAudio;
  final NotePageBloc notePageBloc;
  final Note note;

  const AudioTextWidget(
      {Key? key,
      required this.notePageBloc,
      required this.note,
      this.masterAudioPlayer,
      required this.noteAudio})
      : super(key: key);

  @override
  State<AudioTextWidget> createState() => _AudioTextWidgetState();
}

class _AudioTextWidgetState extends State<AudioTextWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController _noteController = TextEditingController();
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLooping = false;
  bool _isUserDragging = false;
  late NoteAudio? _noteAudio = widget.noteAudio;

  double _sliderValue = 0;

  Future<File?> pickAndCopyAudioFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);
    ;
    if (result != null) {
      File originalFile = File(result.files.single.path!);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final copiedFilePath = "$appDocPath/${result.files.single.name}";
      setState(() {
        _noteAudio = NoteAudio.fromUpload(copiedFilePath, widget.note.id!, "");
      });
      widget.notePageBloc.add(AddNoteAudio(_noteAudio!, _audioPlayer.position));
      return await originalFile.copySync(copiedFilePath);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.masterAudioPlayer ?? AudioPlayer();
    _noteController.text = widget.noteAudio.content;
  }

  @override
  void dispose() {
    if (widget.masterAudioPlayer == null) {
      // Only dispose the audio player if it's not provided by the parent
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      if (_audioPlayer.audioSource == null) {
        if (widget.noteAudio != null) {
          _audioPlayer
              .setAudioSource(AudioSource.file(widget.noteAudio!.filePath));
          _audioPlayer.play();
        } else {
          pickAndCopyAudioFile().then((file) {
            if (file != null) {
              _audioPlayer.setAudioSource(AudioSource.file(file.path));
            }
            // Set the source of the audio player to the picked file
            // and then play
          });
        }
      } else {
        if (widget.noteAudio != null) {
          File file = File(widget.noteAudio!.filePath);
          if (await file.exists()) {
            print("File exists!");
          } else {
            print("File does not exist...");
          }
          _audioPlayer
              .setAudioSource(AudioSource.file(widget.noteAudio!.filePath));
          _audioPlayer.play();
        }
        _audioPlayer.play();
      }
    }
    setState(() {
      _isPlaying = _audioPlayer.playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.noteAudio?.content ?? "Upload Audio",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  strutStyle: StrutStyle(
                    fontSize: 16.0,
                    height: 1.5, // Line spacing is 1.5 times the font size
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  controller: _noteController,
                  decoration: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  onChanged: (value) {
                    NoteAudio updatedNoteAudio = widget.noteAudio;
                    widget.notePageBloc.add(UpdateNoteAudio(updatedNoteAudio));
                  },
                  minLines: 4,
                  maxLines: 16,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(_isLooping ? Icons.loop : Icons.repeat),
                onPressed: () {
                  setState(() {
                    _isLooping = !_isLooping;
                    _audioPlayer
                        .setLoopMode(_isLooping ? LoopMode.one : LoopMode.off);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.restart_alt),
                onPressed: () {
                  _audioPlayer.seek(Duration.zero);
                },
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: Icon(Icons.skip_next),
                onPressed: () {
                  // Logic to skip the song
                },
              ),
              IconButton(
                icon: Icon(Icons.cut),
                onPressed: () {
                  final noteAudio = _noteAudio;
                  if (noteAudio != null) {
                    widget.notePageBloc.add(CutNoteAudio(
                        _noteAudio!, _audioPlayer.position, _audioPlayer));
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  final noteAudio = _noteAudio;
                  if (noteAudio != null) {
                    widget.notePageBloc.add(DeleteNoteAudio(noteAudio));
                  }
                },
              ),
            ],
          ),
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration.zero;
              return Slider(
                min: 0,
                max: duration.inMilliseconds.toDouble(),
                value: _isUserDragging
                    ? _sliderValue
                    : position.inMilliseconds.toDouble(),
                onChangeStart: (value) {
                  setState(() {
                    _isUserDragging = true;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                onChangeEnd: (value) {
                  _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                  setState(() {
                    _isUserDragging = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
