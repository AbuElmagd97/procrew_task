import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RecordingsList extends StatefulWidget {
  final List<Reference> references;

  const RecordingsList({Key? key, required this.references}) : super(key: key);

  @override
  _RecordingsListState createState() => _RecordingsListState();
}

class _RecordingsListState extends State<RecordingsList> {
  bool? isPlaying;
  late AudioPlayer audioPlayer;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    isPlaying = false;
    audioPlayer = AudioPlayer();
    selectedIndex = -1;
  }

  Widget slideLeftBackground() {
    return Card(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.references.length,
      reverse: true,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          direction: DismissDirection.endToStart,
          background: slideLeftBackground(),
          onDismissed: (direction) {
            setState(() {
              _deleteVoice(widget.references.elementAt(index).name);
              widget.references.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black,
                  content: Text("Voice has been deleted successfully"),
                ),
              );
            });
          },
          key: Key(widget.references.elementAt(index).name),
          child: Card(
            child: ListTile(
              title: Text(widget.references.elementAt(index).name),
              trailing: IconButton(
                icon: selectedIndex == index
                    ? FaIcon(FontAwesomeIcons.pauseCircle)
                    : FaIcon(FontAwesomeIcons.playCircle),
                onPressed: () => _onListTileButtonPressed(index),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onListTileButtonPressed(int index) async {
    setState(() {
      selectedIndex = index;
    });
    audioPlayer
        .play(await widget.references.elementAt(index).getDownloadURL(),
            isLocal: false)
        .then((value) => audioPlayer.stop());

    audioPlayer.onPlayerCompletion.listen((duration) {
      setState(() {
        selectedIndex = -1;
      });
    });
  }

  Future<void> _deleteVoice(String url) async {
    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      String path = 'gs://pro-crew-task.appspot.com/recordings/';
      var fileUrl = '$path$url';
      firebaseStorage.refFromURL(fileUrl).delete();
    } catch (e) {
      print("Error while delete voice :${e.toString()}");
    }
  }
}
