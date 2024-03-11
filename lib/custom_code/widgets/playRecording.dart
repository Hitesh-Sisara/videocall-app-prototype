import 'dart:convert';
import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';

class PlayRecordingScreen extends StatefulWidget {
  final String recordingId;

  PlayRecordingScreen({required this.recordingId});

  @override
  _PlayRecordingScreenState createState() => _PlayRecordingScreenState();
}

class _PlayRecordingScreenState extends State<PlayRecordingScreen> {
  VideoPlayerController? _controller; // Made nullable
  bool isLoading = true;
  String? videoUrl;
  String? errorMessage; // Added to display error messages

  @override
  void initState() {
    super.initState();
    fetchVideoUrl();
  }

  Future<void> fetchVideoUrl() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.100ms.live/v2/recording-assets/${widget.recordingId}/presigned-url'),
        headers: {'Authorization': 'Bearer $managementToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        videoUrl = data['url'];
        debugPrint('Video URL: $videoUrl');
        initializeVideoPlayer(); // Moved initialization to a separate method
      } else {
        handleError('Failed to fetch video URL');
      }
    } catch (e) {
      handleError('Failed to fetch video URL: $e');
    }
  }

  Future<void> initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(videoUrl!)
        ..initialize().then((_) {
          setState(() {
            isLoading = false;
          });
        }).catchError((error) {
          handleError('Failed to initialize video player: $error');
        });
    } catch (e) {
      handleError('Error initializing video player: $e');
    }
  }

  void handleError(String message) {
    debugPrint(message);
    showSnackbar(context, message);
    setState(() {
      isLoading = false;
      errorMessage = message; // Set the error message
    });
  }

  @override
  void dispose() {
    _controller?.dispose(); // Use null-aware call
    super.dispose();
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
              ? Center(
                  child: Text(errorMessage!)) // Display error message if any
              : Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
    );
  }
}

Future<void> shareVideoLink(String url) async {
  await Share.share(url);
}
