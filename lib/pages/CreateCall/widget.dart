// // Automatic FlutterFlow imports
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import 'index.dart'; // Imports other custom widgets
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'package:video_calling_app/flutter_flow/flutter_flow_widgets.dart';

// // Set your widget name, define your parameter, and then add the
// // boilerplate code using the green button on the right!

// import 'package:flutter/foundation.dart';
// import 'package:share_plus/share_plus.dart';

// // Imports custom functions
// import 'package:http/http.dart' as http;
// import 'dart:html' as html;
// import 'dart:js' as js;

// // Imports other custom widgets

// class CreateCall extends StatefulWidget {
//   CreateCall(
//       {Key? key,
//       required this.username,
//       required this.height,
//       required this.width})
//       : super(key: key);

//   final String username;
//   final double height;
//   final double width;

//   @override
//   _CreateCallState createState() => _CreateCallState();
// }

// class _CreateCallState extends State<CreateCall> {
//   String? hostroomCode;
//   String? guestRoomCode;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRoomCode();
//   }

//   void _fetchRoomCode() async {
//     try {
//       await createRoom(widget.username);
//     } catch (error) {
//       // Handle error appropriately
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   String generateRoomLink(String? code) {
//     return 'https://hit-livestream-1315.app.100ms.live/streaming/meeting/$code';
//   }

//   String generateHostRoomLink(String? code) {
//     return 'https://hit-livestream-1315.app.100ms.live/streaming/meeting/$code?username=${widget.username}';
//   }

//   Future<void> createRoom(String username) async {
//     var managementToken =
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3Nfa2V5IjoiNjU5YzNiMWVjZDk5M2RmYjQ0YWE0ZGYzIiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJpYXQiOjE3MDk4MTk5MDIsIm5iZiI6MTcwOTgxOTkwMiwiZXhwIjoxNzUzMDE5OTAyLCJqdGkiOiI4MzA1MmUxYS00Y2RiLTQ1M2QtYWJjYi03NDQxMDE4YWY5NGYifQ.4C12dNChAqbq05xdzzic-z6ZiF6l92hn1YFeK1Cqeqc";
//     final url = Uri.parse('https://api.100ms.live/v2/rooms');

//     try {
//       isLoading = true;

//       // Check for existing room
//       final existingRoomResponse = await http.get(
//         Uri.parse('$url?name=$username'),
//         headers: {'Authorization': 'Bearer $managementToken'},
//       );
//       final existingRoomData = jsonDecode(existingRoomResponse.body);

//       print("existingRoomData: $existingRoomData");

//       if (existingRoomResponse.statusCode == 200) {
//         if (existingRoomData['data'] != null &&
//             existingRoomData['data'].length > 0) {
//           print("room exits already");

//           final roomId = existingRoomData["data"][0]['id'];
//           print("roomId: $roomId");

//           final roomEnabled = existingRoomData["data"][0]['enabled'];

//           if (roomEnabled) {
//             print(
//                 "Room already exists and is enabled. Fetching host room code...");

//             // Fetch host room code
//             final roomCodeResponse = await http.get(
//               Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomId'),
//               headers: {'Authorization': 'Bearer $managementToken'},
//             );

//             print("Host room code response: ${roomCodeResponse.body}");

//             if (roomCodeResponse.statusCode == 200) {
//               final roomCodeData = jsonDecode(roomCodeResponse.body);

//               for (final code in roomCodeData['data']) {
//                 if (code['role'] == 'host') {
//                   setState(() {
//                     hostroomCode = code['code']; // Set host room code
//                   });
//                 } else if (code['role'] == 'guest') {
//                   setState(() {
//                     guestRoomCode = code['code']; // Set guest room code
//                   });
//                 }
//               }

//               setState(() {
//                 isLoading = false;
//               });
//             } else {
//               print(
//                   "Error fetching room codes: ${roomCodeResponse.statusCode}");
//               // Handle error appropriately (e.g., show a snackbar to the user)
//               setState(() {
//                 isLoading = false;
//               });
//             }
//             // Return ID if room is already enabled
//           } else {
//             print("Room already exists but is disabled. Activating...");
//             // Enable the room
//             final enableResponse = await http.post(
//               Uri.parse('$url/$roomId'),
//               headers: {
//                 'Authorization': 'Bearer $managementToken',
//                 'Content-Type': 'application/json',
//               },
//               body: jsonEncode({
//                 'enabled': true, // Enable the room
//               }),
//             );

//             if (enableResponse.statusCode == 200) {
//               print("Room enabled successfully. Returning ID...");
//               setState(() {
//                 isLoading = false;
//               });
//               return roomId; // Return ID after enabling
//             } else {
//               print("Error enabling room: ${enableResponse.statusCode}");
//               setState(() {
//                 isLoading = false;
//               });
//             }
//           }
//         } else {
//           // Room doesn't exist, create it
//           print("Room doesn't exist. Creating...");
//           final roomResponse = await http.post(
//             url,
//             headers: {
//               'Authorization': 'Bearer $managementToken',
//               'Content-Type': 'application/json',
//             },
//             body: jsonEncode({
//               "name": username,
//               "recording_info": {"enabled": false},
//             }),
//           );

//           print("Room creation response: ${roomResponse.body}");

//           if (roomResponse.statusCode == 200) {
//             final roomData = jsonDecode(roomResponse.body);
//             final roomId = roomData['id'];

//             // Create room code
//             final roomCodeResponse = await http.post(
//               Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomId'),
//               headers: {
//                 'Authorization': 'Bearer $managementToken',
//                 'Content-Type': 'application/json',
//               },
//             );

//             print("Room code creation response: ${roomCodeResponse.body}");

//             if (roomCodeResponse.statusCode == 200) {
//               final roomCodeData = jsonDecode(roomCodeResponse.body);

//               for (final code in roomCodeData['data']) {
//                 if (code['role'] == 'host') {
//                   setState(() {
//                     hostroomCode = code['code']; // Set host room code
//                   });
//                 } else if (code['role'] == 'guest') {
//                   setState(() {
//                     guestRoomCode = code['code']; // Set guest room code
//                   });
//                 }
//               }

//               setState(() {
//                 isLoading = false;
//               });
//             } else {
//               print(
//                   "Error fetching room codes: ${roomCodeResponse.statusCode}");
//               // Handle error appropriately (e.g., show a snackbar to the user)
//               setState(() {
//                 isLoading = false;
//               });
//             }
//           } else {
//             print("Error creating room: ${roomResponse.body}");

//             setState(() {
//               isLoading = false;
//             });
//           }
//         }
//       } else {
//         print("Error checking existing room: ${existingRoomResponse.body}");
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (error) {
//       showSnackbar(context, 'Failed to create room $error', duration: 3);
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FFButtonWidget(
//       showLoadingIndicator: isLoading,
//       // onPressed: () async {
//       //   Navigator.of(context).push(MaterialPageRoute(
//       //       builder: (context) => Room(username: widget.username)));
//       // },
//       onPressed: () async {
//         showModalBottomSheet(
//           context: context,
//           builder: (BuildContext context) {
//             return Container(
//               height: MediaQuery.sizeOf(context).height * 0.35,
//               width: MediaQuery.sizeOf(context).width,
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 40),
//                   Text(
//                     'Share link for non app user to join the call',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 40),
//                   FFButtonWidget(
//                     onPressed: () async {
//                       if (guestRoomCode != null) {
//                         final link = generateRoomLink(guestRoomCode);
//                         shareVideoLink(link);
//                       }
//                     },
//                     text: 'Share link',
//                     options: FFButtonOptions(
//                       width: MediaQuery.sizeOf(context).width * 0.5,
//                       height: 40,
//                       padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Readex Pro',
//                                 color: Colors.white,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   FFButtonWidget(
//                     onPressed: () async {
//                       if (hostroomCode != null) {
//                         if (kIsWeb) {
//                           var link = generateHostRoomLink(hostroomCode);
//                           html.window.open(link, 'new tab');
//                         }
//                         // Navigator.of(context).push(MaterialPageRoute(
//                         //     builder: (context) => Room(
//                         //           username: widget.username,
//                         //           roomcode: hostroomCode!,
//                         //         )));
//                       } else {
//                         showSnackbar(context, 'Error creating room. Try again.',
//                             duration: 3);
//                       }
//                     },
//                     text: 'Continue',
//                     options: FFButtonOptions(
//                       width: MediaQuery.sizeOf(context).width * 0.5,
//                       height: 40,
//                       padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                       iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                       color: FlutterFlowTheme.of(context).primary,
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleSmall.override(
//                                 fontFamily: 'Readex Pro',
//                                 color: Colors.white,
//                               ),
//                       elevation: 3,
//                       borderSide: BorderSide(
//                         color: Colors.transparent,
//                         width: 1,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//       text: 'Create Call',
//       options: FFButtonOptions(
//         width: MediaQuery.sizeOf(context).width * 0.5,
//         height: 40,
//         padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//         iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//         color: FlutterFlowTheme.of(context).primary,
//         textStyle: FlutterFlowTheme.of(context).titleSmall.override(
//               fontFamily: 'Readex Pro',
//               color: Colors.white,
//             ),
//         elevation: 3,
//         borderSide: BorderSide(
//           color: Colors.transparent,
//           width: 1,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//     );
//   }
// }

// Future<void> shareVideoLink(String url) async {
//   if (kIsWeb) {
//     try {
//       var navigator = js.context['navigator'];
//       if (navigator != null && js.context.hasProperty('navigator')) {
//         navigator.callMethod('share', [
//           js.JsObject.jsify({'url': url})
//         ]);
//       } else {
//         await Share.share(url);
//       }
//     } catch (e) {
//       await Share.share(url);
//     }
//   } else {
//     await Share.share(url);
//   }
// }
