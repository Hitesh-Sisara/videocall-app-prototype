import 'dart:convert';

import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_theme.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './playRecording.dart';

class Recording {
  final String id;
  final String roomName;
  final DateTime createdAt;
  final int duration; // Duration in seconds
  final int size; // Size in bytes

  Recording({
    required this.id,
    required this.roomName,
    required this.createdAt,
    required this.duration,
    required this.size,
  });
}

class RecordingsList extends StatefulWidget {
  RecordingsList({Key? key, required this.username}) : super(key: key);

  final String username;
  @override
  _RecordingsListState createState() => _RecordingsListState();
}

class _RecordingsListState extends State<RecordingsList> {
  List<Recording> recordings = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRecordings();
  }

  Future<void> fetchRecordings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.100ms.live/v2/recording-assets?limit=50&type=room-composite'),
        headers: {'Authorization': 'Bearer $managementToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recordingsData =
            (data['data'] as List<dynamic>).where((recording) {
          final metadata = recording['metadata'] as Map<String, dynamic>?;
          final path = recording['path'] as String?;
          // Check if metadata does not contain 'layer' and path is not empty or null
          return (metadata == null || !metadata.containsKey('layer')) &&
              path != null &&
              path.isNotEmpty;
        }).toList();

        final recordings = await Future.wait(
          recordingsData.map((recordingData) async {
            final roomId = recordingData['room_id'] as String;
            final roomResponse = await http.get(
              Uri.parse('https://api.100ms.live/v2/rooms/$roomId'),
              headers: {'Authorization': 'Bearer $managementToken'},
            );

            if (roomResponse.statusCode == 200) {
              final roomData = jsonDecode(roomResponse.body);
              final roomName = roomData['name'] as String;
              final createdAt = DateTime.parse(recordingData['created_at']);

              return Recording(
                id: recordingData['id'],
                roomName: roomName,
                createdAt: createdAt,
                duration: recordingData['duration'] as int,
                size: recordingData['size'] as int,
              );
            } else {
              return Recording(
                id: recordingData['id'],
                roomName: 'Unknown',
                duration: recordingData['duration'] as int,
                size: recordingData['size'] as int,
                createdAt: DateTime.parse(recordingData['created_at']),
              );
            }
          }),
        );

        setState(() {
          this.recordings = recordings;
          isLoading = false;
        });
      } else {
        // Show SnackBar for unsuccessful response
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Failed to fetch recordings. Please try again later.')));
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Show SnackBar for exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while fetching recordings: $e')));
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? recordings.isNotEmpty
            ? Container(
                height: MediaQuery.sizeOf(context).height * 0.62,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.62,
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: recordings.length,
                        itemBuilder: (context, index) {
                          final recording = recordings[index];
                          final formattedDateTime =
                              DateFormat('yyyy-MM-dd HH:mm')
                                  .format(recording.createdAt);

                          final hours = recording.duration ~/ 3600;
                          final minutes = (recording.duration % 3600) ~/ 60;
                          final seconds = recording.duration % 60;

                          final formattedDuration =
                              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

                          // Convert size from bytes to MB and format to 2 decimal places
                          final formattedSize =
                              (recording.size / 1024 / 1024).toStringAsFixed(2);

                          return ListTile(
                            title: Text(
                              "${recording.roomName}'s recording",
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time : $formattedDateTime ",
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Duration : $formattedDuration",
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "Size : $formattedSize MB",
                                  style: TextStyle(
                                    fontFamily: 'Readex Pro',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(Icons.arrow_forward,
                                size: 30,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PlayRecordingScreen(
                                  recordingId: recording.id,
                                ),
                              ));
                            },
                          );
                        },
                      ),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        setState(() {
                          fetchRecordings();
                        });
                      },
                      text: 'Refresh',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Currently there are no recordings available please create a recording",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        setState(() {
                          fetchRecordings();
                        });
                      },
                      text: 'Refresh',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        height: 40,
                        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white,
                                ),
                        elevation: 3,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              )
        : Center(child: CircularProgressIndicator());
  }
}
