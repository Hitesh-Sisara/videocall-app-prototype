import 'dart:convert';
import 'dart:io';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:call_prototype/custom_code/widgets/api.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_theme.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_util.dart';
import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayRecordingScreen extends StatefulWidget {
  final String recordingId;
  final bool isLocalFile;

  PlayRecordingScreen({required this.recordingId, this.isLocalFile = false});

  @override
  _PlayRecordingScreenState createState() => _PlayRecordingScreenState();
}

class _PlayRecordingScreenState extends State<PlayRecordingScreen> {
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  bool isLoading = true;
  String? videoUrl;
  String? errorMessage;

  bool isDownloading = false;
  double downloadProgress = 0.0;
  String? localFilePath;
  bool permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _getStoragePermission();
    if (widget.isLocalFile) {
      initializeLocalVideoPlayer();
    } else {
      fetchVideoUrl();
    }
  }

  Future<void> checkForLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${widget.recordingId}.mp4';
    final fileExists = await File(filePath).exists();
    if (fileExists) {
      setState(() {
        localFilePath = filePath;
      });
    }
  }

  Future<void> initializeLocalVideoPlayer() async {
    if (widget.isLocalFile) {
      // Directly use the recordingId as it is already an absolute path
      initializeVideoPlayer(widget.recordingId);
    } else {
      // Fetch the video URL and then initialize the player
      fetchVideoUrl();
    }
  }

  Future<void> initializeVideoPlayer(String url) async {
    print("Initializing video player with file path: $url");
    final file = File(url);
    final exists = await file.exists();
    print("File exists: $exists");
    if (!exists) {
      handleError("File does not exist at path: $url");
      return;
    }

    _videoPlayerController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        if (!mounted) return; // Check if the widget is still in the widget tree
        setState(() {
          isLoading = false;
        });
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoPlayerController,
        );
      }).catchError((error) {
        if (!mounted) return; // Check if the widget is still in the widget tree
        handleError('Failed to initialize video player: $error');
      });
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
        initializeOnlineVideoPlayer();
      } else {
        handleError('Failed to fetch video URL');
      }
    } catch (e) {
      handleError('Failed to fetch video URL: $e');
    }
  }

  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }

  Future<void> downloadFile(String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.recordingId}.mp4';
      final file = File(filePath);
      try {
        setState(() {
          isDownloading = true;
          downloadProgress = 0.0;
        });
        final client = http.Client();
        final request = http.Request('GET', Uri.parse(url));
        final streamedResponse = await client.send(request);
        final contentLength = streamedResponse.contentLength;
        List<int> bytes = [];
        streamedResponse.stream.listen(
          (List<int> newBytes) {
            bytes.addAll(newBytes);
            setState(() {
              downloadProgress = bytes.length / (contentLength ?? 1);
            });
          },
          onDone: () async {
            await file.writeAsBytes(bytes);
            setState(() {
              isDownloading = false;
              localFilePath = filePath;
            });
            client.close();
          },
          onError: (e) {
            setState(() {
              isDownloading = false;
            });
            handleError('Failed to download video: $e');
            client.close();
          },
          cancelOnError: true,
        );
      } catch (e) {
        setState(() {
          isDownloading = false;
        });
        handleError('Failed to download video: $e');
      }
    } else {
      handleError('Storage permission denied');
    }
  }

  Future<void> initializeOnlineVideoPlayer() async {
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
    _videoPlayerController.dispose();

    if (_customVideoPlayerController != null) {
      _customVideoPlayerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isLocalFile
            ? 'Playing from Downloaded File'
            : 'Play Recording'),
        actions: widget.isLocalFile
            ? []
            : [
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
                      if (!widget.isLocalFile) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: FFButtonWidget(
                            onPressed: videoUrl == null
                                ? null
                                : () => shareVideoLink(videoUrl!),
                            text: 'Share Recording',
                            options: FFButtonOptions(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primaryColor,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .copyWith(
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: FFButtonWidget(
                            onPressed: videoUrl == null
                                ? null
                                : () => downloadFile(videoUrl!),
                            text: localFilePath == null
                                ? 'Download Recording'
                                : 'Downloaded',
                            value: isDownloading ? downloadProgress : null,
                            options: FFButtonOptions(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: 40,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                              iconPadding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                              color: FlutterFlowTheme.of(context).primaryColor,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .copyWith(
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
                        ),
                      ]
                    ],
                  ),
                ),
    );
  }
}

Future<void> shareVideoLink(String url) async {
  await Share.share(url);
}
