// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_video_player.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'player_model.dart';
// export 'player_model.dart';

// class PlayerWidget extends StatefulWidget {
//   const PlayerWidget({
//     super.key,
//     this.videourl,
//     required this.url,
//   });

//   final String? videourl;
//   final String? url;

//   @override
//   State<PlayerWidget> createState() => _PlayerWidgetState();
// }

// class _PlayerWidgetState extends State<PlayerWidget> {
//   late PlayerModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => PlayerModel());

//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//   }

//   @override
//   void dispose() {
//     _model.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _model.unfocusNode.canRequestFocus
//           ? FocusScope.of(context).requestFocus(_model.unfocusNode)
//           : FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         key: scaffoldKey,
//         backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//         appBar: AppBar(
//           backgroundColor: FlutterFlowTheme.of(context).primary,
//           automaticallyImplyLeading: true,
//           title: Text(
//             'PlayRecording',
//             style: FlutterFlowTheme.of(context).headlineMedium.override(
//                   fontFamily: 'Outfit',
//                   color: Colors.white,
//                   fontSize: 22,
//                 ),
//           ),
//           actions: [],
//           centerTitle: true,
//           elevation: 2,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
//                 child: Container(
//                   width: MediaQuery.sizeOf(context).width * 0.5,
//                   height: 60,
//                   child: custom_widgets.PlayRecordingScreen(
//                     width: MediaQuery.sizeOf(context).width * 0.5,
//                     height: 60,
//                     url: widget.url!,
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
//                 child: FFButtonWidget(
//                   onPressed: () async {
//                     await launchURL(widget.url!);
//                   },
//                   text: 'Download',
//                   options: FFButtonOptions(
//                     width: MediaQuery.sizeOf(context).width * 0.5,
//                     height: 40,
//                     padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
//                     iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
//                     color: FlutterFlowTheme.of(context).primary,
//                     textStyle: FlutterFlowTheme.of(context).titleSmall.override(
//                           fontFamily: 'Readex Pro',
//                           color: Colors.white,
//                         ),
//                     elevation: 3,
//                     borderSide: BorderSide(
//                       color: Colors.transparent,
//                       width: 1,
//                     ),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
//                 child: FlutterFlowVideoPlayer(
//                   path: widget.videourl!,
//                   videoType: VideoType.network,
//                   autoPlay: false,
//                   looping: true,
//                   showControls: true,
//                   allowFullScreen: true,
//                   allowPlaybackSpeedMenu: false,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
