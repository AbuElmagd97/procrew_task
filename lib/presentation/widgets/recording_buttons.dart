import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:procrew_task/constants/my_colors.dart';
import 'package:procrew_task/presentation/widgets/animation_button.dart';

class RecodingButtonsWidget extends StatefulWidget {
  final Function onUploadComplete;

  const RecodingButtonsWidget({Key? key, required this.onUploadComplete})
      : super(key: key);

  @override
  _RecodingButtonsWidgetState createState() => _RecodingButtonsWidgetState();
}

class _RecodingButtonsWidgetState extends State<RecodingButtonsWidget> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;

  late AudioPlayer _audioPlayer;
  late String _filePath;

  late FlutterAudioRecorder2 _audioRecorder;

  late Timer timer;

  bool startStop = true;

  Stopwatch watch = Stopwatch();
  String elapsedTime = '';

  void updateTime(Timer timer) {
    if (watch.isRunning) {
      setState(() {
        print("startstop Inside=$startStop");
        elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      });
    }
  }

  startOrStop() {
    if (startStop) {
      startWatch();
    } else {
      stopWatch();
    }
  }

  startWatch() {
    setState(() {
      startStop = false;
      watch.start();
      timer = Timer.periodic(Duration(milliseconds: 100), updateTime);
    });
  }

  stopWatch() {
    setState(() {
      startStop = true;
      watch.stop();
      setTime();
    });
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
    });
  }

  transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          radius: 100,
          backgroundColor: MyColors.myBlue,
          child: CircleAvatar(
            radius: 92,
            backgroundColor: MyColors.myNavyBlue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.microphone,
                  size: 32,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  elapsedTime,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
        Center(
          child: _isRecorded
              ? _isUploading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: LinearProgressIndicator()),
                        Text('Uploading to Firebase'),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.redoAlt,
                            size: 25,
                          ),
                          onPressed: _onRecordAgainButtonPressed,
                        ),
                        IconButton(
                          icon: FaIcon(
                            _isPlaying
                                ? FontAwesomeIcons.pauseCircle
                                : FontAwesomeIcons.playCircle,
                            size: 30,
                          ),
                          onPressed: _onPlayButtonPressed,
                        ),
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.cloudUploadAlt),
                          onPressed: _onFileUploadButtonPressed,
                        ),
                      ],
                    )
              : SizedBox(
                  width: 100,
                  height: 100,
                  child: AnimationButton(
                    playIcon: _isRecording
                        ? Icon(Icons.pause)
                        : Icon(
                            Icons.fiber_manual_record,
                            color: Colors.white,
                          ),
                    onPressed: _onRecordButtonPressed,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await firebaseStorage
          .ref('recordings')
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath));
      widget.onUploadComplete();
    } catch (error) {
      print('Error occurred while uploading to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred while uploading'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _onRecordButtonPressed() async {
    startOrStop();
    if (_isRecording) {
      _audioRecorder.stop();
      _isRecording = false;
      _isRecorded = true;
    } else {
      _isRecorded = false;
      _isRecording = true;

      await _startRecording();
    }
    setState(() {});
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      watch.reset();
      _isRecorded = false;
    });
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;

      _audioPlayer.play(_filePath, isLocal: true);
      _audioPlayer.onPlayerCompletion.listen((duration) {
        setState(() {
          _isPlaying = false;
        });
      });
    } else {
      _audioPlayer.pause();
      _isPlaying = false;
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    final bool? hasRecordingPermission =
        await FlutterAudioRecorder2.hasPermissions;

    if (hasRecordingPermission ?? false) {
      Directory directory = await getApplicationDocumentsDirectory();
      String filepath = directory.path +
          '/' +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.aac';
      _audioRecorder =
          FlutterAudioRecorder2(filepath, audioFormat: AudioFormat.AAC);
      await _audioRecorder.initialized;
      _audioRecorder.start();
      _filePath = filepath;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text('Please enable recording permission'))));
    }
  }
}
