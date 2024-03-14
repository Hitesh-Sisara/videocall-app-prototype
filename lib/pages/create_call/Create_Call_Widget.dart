import 'package:call_prototype/custom_code/widgets/activeCalls.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';

import 'create_call_model.dart';
export 'create_call_model.dart';

class CreateCallWidget extends StatefulWidget {
  const CreateCallWidget({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<CreateCallWidget> createState() => _CreateCallWidgetState();
}

class _CreateCallWidgetState extends State<CreateCallWidget> {
  late CreateCallModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateCallModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Create or join call',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22,
                ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 428,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 10, 5, 10),
                      child: Text(
                        'Welcome,',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 22,
                            ),
                      ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        widget.username,
                        'user',
                      ),
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            fontSize: 20,
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                'Active calls',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      fontSize: 20,
                    ),
              ),
              Container(
                  height: MediaQuery.sizeOf(context).height * 0.6,
                  child: ActiveSessionsList(
                    username: widget.username,
                    height: 0,
                    width: 0,
                  )),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: 40,
                child: custom_widgets.CreateCall(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 40,
                  username: widget.username!,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: 40,
                child: custom_widgets.Recordings(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 40,
                  username: widget.username!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
