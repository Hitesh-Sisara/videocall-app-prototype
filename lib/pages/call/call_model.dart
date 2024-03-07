import 'package:call_prototype/pages/call/call_page.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class CallModel extends FlutterFlowModel<CallPage> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
