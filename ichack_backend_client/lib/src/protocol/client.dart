/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'protocol.dart' as _i3;

/// {@category Endpoint}
class EndpointExample extends _i1.EndpointRef {
  EndpointExample(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'example';

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'example',
        'hello',
        {'name': name},
      );
}

/// {@category Endpoint}
class EndpointProcessVid extends _i1.EndpointRef {
  EndpointProcessVid(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'processVid';

  _i2.Future<String> processVideo(List<String> faceResults) =>
      caller.callServerEndpoint<String>(
        'processVid',
        'processVideo',
        {'faceResults': faceResults},
      );
}

/// {@category Endpoint}
class EndpointText extends _i1.EndpointRef {
  EndpointText(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'text';

  _i2.Future<bool> record(
    int conversationId,
    String speechRecorded,
    DateTime timestamp,
  ) =>
      caller.callServerEndpoint<bool>(
        'text',
        'record',
        {
          'conversationId': conversationId,
          'speechRecorded': speechRecorded,
          'timestamp': timestamp,
        },
      );

  _i2.Future<String> generateReply({
    required bool encouraging,
    required bool constructive,
    required bool wellRounded,
  }) =>
      caller.callServerEndpoint<String>(
        'text',
        'generateReply',
        {
          'encouraging': encouraging,
          'constructive': constructive,
          'wellRounded': wellRounded,
        },
      );
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i3.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    example = EndpointExample(this);
    processVid = EndpointProcessVid(this);
    text = EndpointText(this);
  }

  late final EndpointExample example;

  late final EndpointProcessVid processVid;

  late final EndpointText text;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'example': example,
        'processVid': processVid,
        'text': text,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {};
}
