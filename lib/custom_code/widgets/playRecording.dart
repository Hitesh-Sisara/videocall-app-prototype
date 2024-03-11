import 'dart:convert';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_theme.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class PlayRecordingScreen extends StatefulWidget {
  final String recordingId;

  PlayRecordingScreen({required this.recordingId});

  @override
  _PlayRecordingScreenState createState() => _PlayRecordingScreenState();
}

class _PlayRecordingScreenState extends State<PlayRecordingScreen> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool isLoading = true;
  String? videoUrl;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchVideoUrl();
  }

  Future<void> fetchVideoUrl() async {
    try {
      debugPrint('recordingId: ${widget.recordingId}');
      final response = await http.get(
        Uri.parse(
            'https://api.100ms.live/v2/recording-assets/${widget.recordingId}/presigned-url'),
        headers: {'Authorization': 'Bearer $managementToken'},
      );

      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        videoUrl = data['url'];
        debugPrint('Video URL: $videoUrl');
        initializeVideoPlayer();
      } else {
        handleError('Failed to fetch video URL');
      }
    } catch (e) {
      handleError('Failed to fetch video URL: $e');
    }
  }

  Future<void> initializeVideoPlayer() async {
    if (videoUrl != null) {
      _videoPlayerController = VideoPlayerController.network(videoUrl!)
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
          _customVideoPlayerController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: _videoPlayerController,
          );
        }).catchError((error) {
          handleError('Failed to initialize video player: $error');
        });
    }
  }

  void handleError(String message) {
    debugPrint(message);
    showSnackbar(context, message);
    setState(() {
      isLoading = false;
      errorMessage = message;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _customVideoPlayerController.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Recording'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed:
                videoUrl == null ? null : () => shareVideoLink(videoUrl!),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: FFButtonWidget(
                          onPressed: videoUrl == null
                              ? null
                              : () => shareVideoLink(videoUrl!),
                          text: 'Share Recording',
                          options: FFButtonOptions(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            height: 40,
                            padding:
                                EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                            iconPadding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                      )
                    ],
                  ),
                ),
    );
  }
}

Future<void> shareVideoLink(String url) async {
  await Share.share(url);
}
