// import 'package:call_prototype/custom_code/widgets/room.dart';
// import 'package:call_prototype/flutter_flow/flutter_flow_widgets.dart';

// import '/flutter_flow/flutter_flow_theme.dart';
// import 'package:flutter/material.dart';

// class JoinCall extends StatefulWidget {
//   const JoinCall({
//     super.key,
//     this.width,
//     this.height,
//     required this.username,
//   });

//   final double? width;
//   final double? height;
//   final String username;

//   @override
//   _JoinCallState createState() => _JoinCallState();
// }

// class _JoinCallState extends State<JoinCall> {
//   @override
//   Widget build(BuildContext context) {
//     return FFButtonWidget(
//       onPressed: () async {
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => Room(username: widget.username)));
//       },
//       text: 'Join Call',
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
