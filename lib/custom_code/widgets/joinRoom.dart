import 'dart:convert';
import 'dart:math';

import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hms_room_kit/hms_room_kit.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({
    Key? key,
    this.width,
    this.height,
    required this.roomID,
    required this.username,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String roomID;
  final String username;

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  String? roomCode;
  bool isLoading = false;

  final managementToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3Nfa2V5IjoiNjVkZGU0ZTgxZDVmZDc0OWNkMWYxZjc4IiwidHlwZSI6Im1hbmFnZW1lbnQiLCJ2ZXJzaW9uIjoyLCJpYXQiOjE3MDk0Mzk1ODEsIm5iZiI6MTcwOTQzOTU4MSwiZXhwIjoxNzUyNjM5NTgxLCJqdGkiOiI1YjkwMjM1YS1kMDVmLTQwYjctYTAyNC0wYTFjMDY3OTUxMDYifQ.QuIPLguktiTejI0yt9TzlGtE_Led755jM2OzQ1jDkKE";
  @override
  void initState() {
    super.initState();
    fetchRoomCode(widget.username);
  }

  // }

  Future<void> fetchRoomCode(String username) async {
    try {
      print("fetching room code");
      setState(() {
        isLoading = true;
      });

      final String roomid = widget.roomID;

      print(widget.roomID);
      final roomCodeResponse = await http.post(
        Uri.parse('https://api.100ms.live/v2/room-codes/room/$roomid'),
        headers: {
          'Authorization': 'Bearer $managementToken',
          'Content-Type': 'application/json',
        },
      );

      print("Room code creation response: ${roomCodeResponse.body}");

      if (roomCodeResponse.statusCode == 200) {
        final roomCodeData = jsonDecode(roomCodeResponse.body);
        for (final data in roomCodeData['data']) {
          if (data['role'] == 'guest') {
            setState(() {
              isLoading = false;
              roomCode = data['code'];
            });
          }
        }
      } else {
        showSnackbar(context, 'Failed to fetch room, room may be clsoed ',
            duration: 3);
      }

      setState(() {
        isLoading = false;
      });

      // Check for existing room
    } catch (error) {
      print(error);
      showSnackbar(context, 'Failed to join room $error', duration: 3);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (roomCode == null) {
      return Scaffold(
          body: Center(
              child: Text(
        'Failed to generate room id on 100ms portal',
      )));
    }

    // Use the fetched room code for joining
    return HMSPrebuilt(
      roomCode: roomCode!,
      options: HMSPrebuiltOptions(userName: widget.username),
    );
  }
}
