// import 'package:permission_handler/permission_handler.dart';
//
// class SoundRecorder {
//   FlutterSoundRecorder? _audioRecorder;
//   bool _isRecordingInitialised = false;
//
//   bool get isRecording => _audioRecorder!.isRecording;
//
//   final savedPath = 'audio.mp3';
//
//   Future<void> init() async {
//     _audioRecorder = FlutterSoundRecorder();
//
//     final status = await Permission.microphone.request();
//     if (status != PermissionStatus.granted) {
//       throw RecordingPermissionException('Microphone Permission not granted');
//     }
//
//     await _audioRecorder!.openAudioSession();
//     _isRecordingInitialised = true;
//   }
//
//   void dispose() {
//     _audioRecorder!.closeAudioSession();
//     _audioRecorder = null;
//     _isRecordingInitialised = false;
//   }
//
//   Future<void> _record() async {
//     if (!_isRecordingInitialised) return;
//     await _audioRecorder!.startRecorder(toFile: savedPath);
//   }
//
//   Future<void> _stop() async {
//     await _audioRecorder!.stopRecorder();
//   }
//
//   Future<void> toggleRecording() async {
//     if (_audioRecorder!.isStopped) {
//       await _record();
//     } else {
//       await _stop();
//     }
//   }
// }
