// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import '/custom_code/widgets/index.dart' as custom_widgets;
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// import 'recordings_model.dart';
// export 'recordings_model.dart';

// class RecordingsWidget extends StatefulWidget {
//   const RecordingsWidget({
//     super.key,
//     required this.username,
//   });

//   final String? username;

//   @override
//   State<RecordingsWidget> createState() => _RecordingsWidgetState();
// }

// class _RecordingsWidgetState extends State<RecordingsWidget> {
//   late RecordingsModel _model;

//   final scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => RecordingsModel());

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
//             'Recordings',
//             style: FlutterFlowTheme.of(context).bodyMedium.override(
//                   fontFamily: 'Readex Pro',
//                   color: FlutterFlowTheme.of(context).alternate,
//                   fontSize: 22,
//                 ),
//           ),
//           actions: [],
//           centerTitle: true,
//           elevation: 4,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Container(
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height * 0.9,
//                 child: custom_widgets.RecordingsList(
//                   width: MediaQuery.sizeOf(context).width,
//                   height: MediaQuery.sizeOf(context).height * 0.9,
//                   username: widget.username!,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
