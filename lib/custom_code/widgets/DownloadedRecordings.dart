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

    debugPrint('Directory: ${directory.path}');

    final downloadedFiles = directory.listSync();
    debugPrint('Downloaded Files: $downloadedFiles');

    final recordings = downloadedFiles
        .where((file) => file.path.endsWith('.mp4'))
        .map((file) => file.path)
        .toList();
    setState(() {
      downloadedRecordings = recordings;
    });

    debugPrint('Recordings: $recordings');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Recordings'),
      ),
      body: downloadedRecordings.isEmpty
          ? Center(child: Text('No recordings found'))
          : ListView(
              children: List.generate(
                downloadedRecordings.length,
                (index) {
                  final recordingPath = downloadedRecordings[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: ListTile(
                      title: Text(
                        'Recording ${index + 1}',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward,
                          size: 30, color: Colors.blue),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlayRecordingScreen(
                            recordingId: recordingPath,
                            isLocalFile: true,
                          ),
                        ));
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}
