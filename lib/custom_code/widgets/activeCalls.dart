import 'dart:convert';

import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/custom_code/widgets/joinRoom.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_theme.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActiveSession {
  final String id;
  final String roomId;
  final Map<String, dynamic> peers;
  final DateTime createdAt;

  ActiveSession({
    required this.id,
    required this.roomId,
    required this.peers,
    required this.createdAt,
  });

  factory ActiveSession.fromJson(Map<String, dynamic> json) {
    return ActiveSession(
      id: json['id'],
      roomId: json['room_id'],
      peers: json['peers'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class ActiveSessionsList extends StatefulWidget {
  ActiveSessionsList({Key? key, required this.username}) : super(key: key);

  final String username;
  @override
  _ActiveSessionsListState createState() => _ActiveSessionsListState();
}

class _ActiveSessionsListState extends State<ActiveSessionsList> {
  List<ActiveSession> activeSessions = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchActiveSessions();
  }

  Future<void> _fetchActiveSessions() async {
    print("fetching active sessions");
    try {
      setState(() {
        isLoading = true;
      });
      final url =
          Uri.parse('https://api.100ms.live/v2/sessions?active=true&limit=100');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $managementToken'},
      );

      print("response : ${response.body.toString()}");

      if (response.statusCode == 200) {
        final sessionData = jsonDecode(response.body);

        if (sessionData['data'] != null && sessionData['data'].length > 0) {
          final List<dynamic> sessionsData = sessionData['data'];

          setState(() {
            activeSessions = sessionsData
                .map((data) => ActiveSession.fromJson(data))
                .toList();

            setState(() {
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });
          return;
        }
      } else {
        setState(() {
          isLoading = false;
        });
        return;
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("error $error");
      showSnackbar(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? activeSessions.isNotEmpty
            ? Container(
                height: MediaQuery.sizeOf(context).height * 0.5,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      padding: EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: activeSessions.length,
                        itemBuilder: (context, index) {
                          final session = activeSessions[index];
                          final hostPeer = session.peers.values.firstWhere(
                              (peer) => peer['role'] == 'host',
                              orElse: () => null);
                          final hostName =
                              hostPeer != null ? hostPeer['name'] : 'Anonymous';
                          final liveDuration =
                              DateTime.now().difference(session.createdAt);

                          return ListTile(
                            title: Text(
                              "Join $hostName's room",
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor),
                            ),
                            subtitle: Text(
                              "Live since ${_formatDuration(liveDuration)}",
                              style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: Icon(Icons.arrow_forward,
                                size: 30,
                                color: Theme.of(context).primaryColor),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => JoinRoom(
                                  roomID: session.roomId,
                                  username: widget.username,
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
                          _fetchActiveSessions();
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
                      "Currently there are no live calls available. Please create a new call.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        setState(() {
                          _fetchActiveSessions();
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

  String _formatDuration(Duration duration) {
    if (duration.inMilliseconds < 0) {
      return 'recently';
    } else if (duration.inHours.abs() > 0) {
      return '${duration.inHours.abs()} hours';
    } else if (duration.inMinutes.abs() > 0) {
      return '${duration.inMinutes.abs()} minutes';
    } else {
      return '${duration.inSeconds.abs()} seconds';
    }
  }
}
