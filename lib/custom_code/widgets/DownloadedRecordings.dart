import 'dart:io';
import 'package:call_prototype/custom_code/widgets/playRecording.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadedRecordingsScreen extends StatefulWidget {
  @override
  _DownloadedRecordingsScreenState createState() =>
      _DownloadedRecordingsScreenState();
}

class _DownloadedRecordingsScreenState
    extends State<DownloadedRecordingsScreen> {
  List<String> downloadedRecordings = [];

  @override
  void initState() {
    super.initState();
    _loadDownloadedRecordings();
  }

  Future<void> _loadDownloadedRecordings() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadedFiles = directory.listSync();
    final recordings = downloadedFiles
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) => file.path)
        .toList();
    setState(() {
      downloadedRecordings = recordings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Recordings'),
      ),
      body: ListView.builder(
        itemCount: downloadedRecordings.length,
        itemBuilder: (context, index) {
          final recordingPath = downloadedRecordings[index];
          return ListTile(
            title: Text('Recording ${index + 1}'),
            onTap: () {
              print(
                  'Navigating to PlayRecordingScreen with path: $recordingPath');

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PlayRecordingScreen(
                    recordingId: recordingPath, isLocalFile: true),
              ));
            },
          );
        },
      ),
    );
  }
}
