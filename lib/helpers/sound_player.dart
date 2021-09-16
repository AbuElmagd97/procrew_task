// import 'package:flutter/material.dart';
//
// class SoundPlayer {
//   FlutterSoundPlayer? _audioPlayer;
//
//   bool get isPlaying => _audioPlayer!.isPlaying;
//
//   final pathToReadAudio = 'audio.mp3';
//
//   Future init() async {
//     _audioPlayer = FlutterSoundPlayer();
//     await _audioPlayer!.openAudioSession();
//   }
//
//   void dispose() {
//     _audioPlayer!.closeAudioSession();
//     _audioPlayer = null;
//   }
//
//   Future<void> _play(VoidCallback whenFinished) async {
//     await _audioPlayer!.startPlayer(
//       fromURI: pathToReadAudio,
//       whenFinished: whenFinished,
//     );
//   }
//
//   Future<void> _stop() async {
//     await _audioPlayer!.stopPlayer();
//   }
//
//   Future<void> togglePlaying({required VoidCallback whenFinished}) async {
//     if (_audioPlayer!.isStopped) {
//       await _play(whenFinished);
//     } else {
//       await _stop();
//     }
//   }
// }
