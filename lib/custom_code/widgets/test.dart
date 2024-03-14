// // Automatic FlutterFlow imports
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:flutter/foundation.dart';

// import 'package:video_calling_app/flutter_flow/flutter_flow_widgets.dart';

// import 'package:http/http.dart' as http;
// import 'dart:html' as html;

// // Set your widget name, define your parameter, and then add the
// // boilerplate code using the green button on the right!

// class ActiveSessionsList extends StatefulWidget {
//   ActiveSessionsList(
//       {Key? key,
//       required this.username,
//       required this.height,
//       required this.width})
//       : super(key: key);

//   final String username;
//   final double height;
//   final double width;
//   @override
//   _ActiveSessionsListState createState() => _ActiveSessionsListState();
// }

// class _ActiveSessionsListState extends State<ActiveSessionsList> {
//   List<ActiveSession> activeSessions = [];

//   var managementToken =
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3Nfa2V5IjoiNjU5YzNiMWVjZDk5M2RmYjQ0YWE0ZGYzIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJpYXQiOjE3MDk4MTk5MDIsIm5iZiI6MTcwOTgxOTkwMiwiZXhwIjoxNzUzMDE5OTAyLCJqdGkiOiI4MzA1MmUxYS00Y2RiLTQ1M2QtYWJjYi03NDQxMDE4YWY5NGYifQ.4C12dNChAqbq05xdzzic-z6ZiF6l92hn1YFeK1Cqeqc";

//   bool isLoading = false;

//   String? roomCode;
//   bool isgoLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchActiveSessions();
//   }

//   String generateRoomLink(String? code) {
//     return 'https://hit-livestream-1315.app.100ms.live/streaming/meeting/$code';
//   }

//   Future<void> fetchRoomCode(String roomID) async {
//     try {
//       print("fetching room code");
//       setState(() {
//         isgoLoading = true;
//       });

//       final String roomid = roomID;

//       // final roomCodeResponse = await http.post(
//       //   Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomid'),
//       //   headers: {
//       //     'Authorization': 'Bearer $managementToken',
//       //     'Content-Type': 'application/json',
//       //   },
//       // );

//       final roomCodeResponse = await http.get(
//         Uri.parse(
//             'https://my-proxy-server-6onm.onrender.com/api/proxy?url=https://api.100ms.live/v2/room-codes/room/${roomid}/presigned-url&token=$managementToken'),
//       );

//       print("Room code creation response: ${roomCodeResponse.body}");

//       if (roomCodeResponse.statusCode == 200) {
//         final roomCodeData = jsonDecode(roomCodeResponse.body);
//         for (final data in roomCodeData['data']) {
//           if (data['role'] == 'guest') {
//             setState(() {
//               isLoading = false;
//               roomCode = data['code'];
//             });
//           }
//         }
//       } else {
//         showSnackbar(context, 'Failed to fetch room, room may be clsoed ',
//             duration: 3);
//       }

//       setState(() {
//         isLoading = false;
//       });

//       // Check for existing room
//     } catch (error) {
//       print(error);
//       showSnackbar(context, 'Failed to join room $error', duration: 3);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _fetchActiveSessions() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       final url =
//           Uri.parse('https://api.100ms.live/v2/sessions?active=true&limit=100');
//       // final response = await http.get(
//       //   url,
//       //   headers: {'Authorization': 'Bearer $managementToken'},
//       // );

//       final response = await http.get(
//         Uri.parse(
//             'https://my-proxy-server-6onm.onrender.com/api/proxy?url=https://api.100ms.live/v2/sessions?active=true&limit=100&token=$managementToken'),
//       );

//       if (response.statusCode == 200) {
//         final sessionData = jsonDecode(response.body);

//         if (sessionData['data'] != null && sessionData['data'].length > 0) {
//           final List<dynamic> sessionsData = sessionData['data'];

//           setState(() {
//             activeSessions = sessionsData
//                 .map((data) => ActiveSession.fromJson(data))
//                 .toList();

//             setState(() {
//               isLoading = false;
//             });
//           });
//         } else {
//           setState(() {
//             isLoading = false;
//           });
//           return;
//         }
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false;
//       });
//       showSnackbar(context, error.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return !isLoading
//         ? activeSessions.isNotEmpty
//             ? Container(
//                 height: MediaQuery.sizeOf(context).height * 0.45,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: MediaQuery.sizeOf(context).height * 0.45,
//                       padding: EdgeInsets.all(16),
//                       child: ListView.builder(
//                         itemCount: activeSessions.length,
//                         itemBuilder: (context, index) {
//                           final session = activeSessions[index];
//                           final hostPeer = session.peers.values.firstWhere(
//                               (peer) => peer['role'] == 'host',
//                               orElse: () => null);
//                           final hostName =
//                               hostPeer != null ? hostPeer['name'] : 'Anonymous';
//                           final liveDuration =
//                               DateTime.now().difference(session.createdAt);

//                           return ListTile(
//                             title: Text(
//                               "Join $hostName's room",
//                               style: TextStyle(
//                                   fontFamily: 'Readex Pro',
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.blue),
//                             ),
//                             subtitle: Text(
//                               "live since ${_formatDuration(liveDuration)}",
//                               style: TextStyle(
//                                   fontFamily: 'Readex Pro',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.normal),
//                             ),
//                             trailing: Icon(Icons.arrow_forward,
//                                 size: 30, color: Colors.blue),
//                             onTap: () async {
//                               await fetchRoomCode(session.roomId);

//                               if (roomCode != null) {
//                                 var roomlink = generateRoomLink(roomCode);

//                                 if (kIsWeb) {
//                                   html.window.open(roomlink, 'new tab');
//                                 }
//                               }

//                               // Navigator.of(context).push(MaterialPageRoute(
//                               //   builder: (context) => JoinRoom(
//                               //     roomID: session.roomId,
//                               //     username: widget.username,
//                               //   ),
//                               // ));
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                     FFButtonWidget(
//                       onPressed: () {
//                         setState(() {
//                           _fetchActiveSessions();
//                         });
//                       },
//                       text: 'Refresh',
//                       options: FFButtonOptions(
//                         width: MediaQuery.sizeOf(context).width * 0.5,
//                         height: 40,
//                         padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                         color: FlutterFlowTheme.of(context).primary,
//                         textStyle:
//                             FlutterFlowTheme.of(context).titleSmall.override(
//                                   fontFamily: 'Readex Pro',
//                                   color: Colors.white,
//                                 ),
//                         elevation: 3,
//                         borderSide: BorderSide(
//                           color: Colors.transparent,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       "Currently there are no live calls available. Please create a new call.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontFamily: 'Readex Pro',
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     FFButtonWidget(
//                       onPressed: () {
//                         setState(() {
//                           _fetchActiveSessions();
//                         });
//                       },
//                       text: 'Refresh',
//                       options: FFButtonOptions(
//                         width: MediaQuery.sizeOf(context).width * 0.5,
//                         height: 40,
//                         padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                         color: FlutterFlowTheme.of(context).primary,
//                         textStyle:
//                             FlutterFlowTheme.of(context).titleSmall.override(
//                                   fontFamily: 'Readex Pro',
//                                   color: Colors.white,
//                                 ),
//                         elevation: 3,
//                         borderSide: BorderSide(
//                           color: Colors.transparent,
//                           width: 1,
//                         ),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//         : Center(child: CircularProgressIndicator());
//   }

//   String _formatDuration(Duration duration) {
//     if (duration.inMilliseconds < 0) {
//       return 'recently';
//     } else if (duration.inHours.abs() > 0) {
//       return '${duration.inHours.abs()} hours';
//     } else if (duration.inMinutes.abs() > 0) {
//       return '${duration.inMinutes.abs()} minutes';
//     } else {
//       return '${duration.inSeconds.abs()} seconds';
//     }
//   }
// }

// class ActiveSession {
//   final String id;
//   final String roomId;
//   final Map<String, dynamic> peers;
//   final DateTime createdAt;

//   ActiveSession({
//     required this.id,
//     required this.roomId,
//     required this.peers,
//     required this.createdAt,
//   });

//   factory ActiveSession.fromJson(Map<String, dynamic> json) {
//     return ActiveSession(
//       id: json['id'],
//       roomId: json['room_id'],
//       peers: json['peers'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }
// }
