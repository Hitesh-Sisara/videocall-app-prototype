// Automatic FlutterFlow imports

import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/custom_code/widgets/room.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '/flutter_flow/flutter_flow_theme.dart';
// Imports custom functions
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Imports other custom widgets

class CreateCall extends StatefulWidget {
  const CreateCall({
    super.key,
    this.width,
    this.height,
    required this.username,
  });

  final double? width;
  final double? height;
  final String username;

  @override
  _CreateCallState createState() => _CreateCallState();
}

class _CreateCallState extends State<CreateCall> {
  String? hostroomCode;
  String? guestRoomCode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRoomCode();
  }

  void _fetchRoomCode() async {
    try {
      await createRoom(widget.username);
    } catch (error) {
      // Handle error appropriately
      setState(() {
        isLoading = false;
      });
    }
  }

  String generateRoomLink(String? code) {
    return 'https://hit-livestream-1315.app.100ms.live/streaming/meeting/$code';
  }

  String generateHostRoomLink(String? code) {
    return 'https://hit-livestream-1315.app.100ms.live/streaming/meeting/$code?username=${widget.username}';
  }

  Future<void> createRoom(String username) async {
    final url = Uri.parse('https://api.100ms.live/v2/rooms');

    try {
      isLoading = true;

      // Check for existing room
      final existingRoomResponse = await http.get(
        Uri.parse('$url?name=$username'),
        headers: {'Authorization': 'Bearer $managementToken'},
      );
      final existingRoomData = jsonDecode(existingRoomResponse.body);

      print("existingRoomData: $existingRoomData");

      if (existingRoomResponse.statusCode == 200) {
        if (existingRoomData['data'] != null &&
            existingRoomData['data'].length > 0) {
          print("room exits already");

          final roomId = existingRoomData["data"][0]['id'];
          print("roomId: $roomId");

          final roomEnabled = existingRoomData["data"][0]['enabled'];

          if (roomEnabled) {
            print(
                "Room already exists and is enabled. Fetching host room code...");

            // Fetch host room code
            final roomCodeResponse = await http.get(
              Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomId'),
              headers: {'Authorization': 'Bearer $managementToken'},
            );

            print("Host room code response: ${roomCodeResponse.body}");

            if (roomCodeResponse.statusCode == 200) {
              final roomCodeData = jsonDecode(roomCodeResponse.body);

              for (final code in roomCodeData['data']) {
                if (code['role'] == 'host') {
                  setState(() {
                    hostroomCode = code['code']; // Set host room code
                  });
                } else if (code['role'] == 'guest') {
                  setState(() {
                    guestRoomCode = code['code']; // Set guest room code
                  });
                }
              }

              setState(() {
                isLoading = false;
              });
            } else {
              print(
                  "Error fetching room codes: ${roomCodeResponse.statusCode}");
              // Handle error appropriately (e.g., show a snackbar to the user)
              setState(() {
                isLoading = false;
              });
            }
            // Return ID if room is already enabled
          } else {
            print("Room already exists but is disabled. Activating...");
            // Enable the room
            final enableResponse = await http.post(
              Uri.parse('$url/$roomId'),
              headers: {
                'Authorization': 'Bearer $managementToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({
                'enabled': true, // Enable the room
              }),
            );

            if (enableResponse.statusCode == 200) {
              print("Room enabled successfully. Returning ID...");
              setState(() {
                isLoading = false;
              });
              return roomId; // Return ID after enabling
            } else {
              print("Error enabling room: ${enableResponse.statusCode}");
              setState(() {
                isLoading = false;
              });
            }
          }
        } else {
          // Room doesn't exist, create it
          print("Room doesn't exist. Creating...");
          final roomResponse = await http.post(
            url,
            headers: {
              'Authorization': 'Bearer $managementToken',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "name": username,
              "recording_info": {"enabled": false},
            }),
          );

          print("Room creation response: ${roomResponse.body}");

          if (roomResponse.statusCode == 200) {
            final roomData = jsonDecode(roomResponse.body);
            final roomId = roomData['id'];

            // Create room code
            final roomCodeResponse = await http.post(
              Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomId'),
              headers: {
                'Authorization': 'Bearer $managementToken',
                'Content-Type': 'application/json',
              },
            );

            print("Room code creation response: ${roomCodeResponse.body}");

            if (roomCodeResponse.statusCode == 200) {
              final roomCodeData = jsonDecode(roomCodeResponse.body);

              for (final code in roomCodeData['data']) {
                if (code['role'] == 'host') {
                  setState(() {
                    hostroomCode = code['code']; // Set host room code
                  });
                } else if (code['role'] == 'guest') {
                  setState(() {
                    guestRoomCode = code['code']; // Set guest room code
                  });
                }
              }

              setState(() {
                isLoading = false;
              });
            } else {
              print(
                  "Error fetching room codes: ${roomCodeResponse.statusCode}");
              // Handle error appropriately (e.g., show a snackbar to the user)
              setState(() {
                isLoading = false;
              });
            }
          } else {
            print("Error creating room: ${roomResponse.body}");

            setState(() {
              isLoading = false;
            });
          }
        }
      } else {
        print("Error checking existing room: ${existingRoomResponse.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      showSnackbar(context, 'Failed to create room $error', duration: 3);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FFButtonWidget(
      showLoadingIndicator: isLoading,
      // onPressed: () async {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => Room(username: widget.username)));
      // },
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: MediaQuery.sizeOf(context).height * 0.35,
              width: MediaQuery.sizeOf(context).width,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Share link for non app user to join the call',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  FFButtonWidget(
                    onPressed: () async {
                      if (guestRoomCode != null) {
                        final link = generateRoomLink(guestRoomCode);
                        shareVideoLink(link);
                      }
                    },
                    text: 'Share link',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                  SizedBox(height: 40),
                  FFButtonWidget(
                    onPressed: () async {
                      if (hostroomCode != null) {
                        if (kIsWeb) {
                          var link = generateHostRoomLink(hostroomCode);
                          var roomlink = Uri.parse(link);

                          await launchUrl(roomlink);

                          // html.window.open(link, 'new tab');
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Room(
                                  username: widget.username,
                                  roomcode: hostroomCode!,
                                )));
                      } else {
                        showSnackbar(context, 'Error creating room. Try again.',
                            duration: 3);
                      }
                    },
                    text: 'Continue',
                    options: FFButtonOptions(
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: 40,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
            );
          },
        );
      },
      text: 'Create Call',
      options: FFButtonOptions(
        width: MediaQuery.sizeOf(context).width * 0.5,
        height: 40,
        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
        color: FlutterFlowTheme.of(context).primary,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
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
    );
  }
}

Future<void> shareVideoLink(String url) async {
  await Share.share(url);
}
