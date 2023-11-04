import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:start_note/data/models/note_audio.dart';

class AudioTextWidget extends StatefulWidget {
  final AudioPlayer? masterAudioPlayer;
  final NoteAudio noteAudio;

  const AudioTextWidget(
      {Key? key, this.masterAudioPlayer, required this.noteAudio})
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
  bool _isReplay = false;
  bool _isUserDragging = false;
  late NoteAudio _noteAudio = widget.noteAudio;

  late AnimationController _controller;

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
      return await originalFile.copySync(copiedFilePath);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _audioPlayer = widget.masterAudioPlayer ?? AudioPlayer();
  }

  @override
  void dispose() {
    if (widget.masterAudioPlayer == null) {
      // Only dispose the audio player if it's not provided by the parent
      _audioPlayer.dispose();
    }
    super.dispose();
  }

  void _togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
    } else {
      if (_audioPlayer.audioSource == null) {
        pickAndCopyAudioFile().then((file) {
          if (file != null) {
            _audioPlayer.setAudioSource(AudioSource.file(file.path));
            _audioPlayer.play();
          }
          // Set the source of the audio player to the picked file
          // and then play
        });
      } else {
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
          Text(widget.noteAudio.content),
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
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Logic for options button
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
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
            child: Container(
              height: 50,
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                controller: _noteController,
                decoration: null,
            
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  print(value);
                  // onChanged(note.id!);
                },
                maxLines: 99999,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
