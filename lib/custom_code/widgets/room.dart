import 'dart:convert';
import 'dart:math';

import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hms_room_kit/hms_room_kit.dart';

class Room extends StatefulWidget {
  const Room({
    Key? key,
    this.width,
    this.height,
    required this.username,
    required this.roomcode,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String username;
  final String roomcode;

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
//   String? roomCode;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchRoomCode();
//   }

//   void _fetchRoomCode() async {
//     try {
//       final code = await createRoom(widget.username);
//       setState(() {
//         roomCode = code;
//       });
//     } catch (error) {
//       // Handle error appropriately
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<String?> createRoom(String username) async {
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
//                     isLoading = false;
//                   });
//                   return code['code']; // Return host room code
//                 }
//               }
//             } else {
//               print(
//                   "Error fetching host room code: ${roomCodeResponse.statusCode}");
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
//                     isLoading = false;
//                   });
//                   return code['code']; // Return host room code
//                 }
//               }
//             } else {
//               print("Error creating room code: ${roomCodeResponse.body}");
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

  @override
  Widget build(BuildContext context) {
    if (widget.roomcode == null) {
      return Center(child: Text('Failed to generate room id on 100ms portal'));
    }

    // Use the fetched room code for joining
    return HMSPrebuilt(
      roomCode: widget.roomcode,
      options: HMSPrebuiltOptions(userName: widget.username),
      onLeave: () {
        print("room left");
        Navigator.pop(context);
      },
    );
  }
}
