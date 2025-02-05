/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/example_endpoint.dart' as _i2;
import '../endpoints/processVideo_endpoint.dart' as _i3;
import '../endpoints/text_endpoint.dart' as _i4;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'example': _i2.ExampleEndpoint()
        ..initialize(
          server,
          'example',
          null,
        ),
      'processVid': _i3.ProcessVid()
        ..initialize(
          server,
          'processVid',
          null,
        ),
      'text': _i4.TextEndpoint()
        ..initialize(
          server,
          'text',
          null,
        ),
    };
    connectors['example'] = _i1.EndpointConnector(
      name: 'example',
      endpoint: endpoints['example']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['example'] as _i2.ExampleEndpoint).hello(
            session,
            params['name'],
          ),
        )
      },
    );
    connectors['processVid'] = _i1.EndpointConnector(
      name: 'processVid',
      endpoint: endpoints['processVid']!,
      methodConnectors: {
        'processVideo': _i1.MethodConnector(
          name: 'processVideo',
          params: {
            'faceResults': _i1.ParameterDescription(
              name: 'faceResults',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['processVid'] as _i3.ProcessVid).processVideo(
            session,
            params['faceResults'],
          ),
        )
      },
    );
    connectors['text'] = _i1.EndpointConnector(
      name: 'text',
      endpoint: endpoints['text']!,
      methodConnectors: {
        'record': _i1.MethodConnector(
          name: 'record',
          params: {
            'conversationId': _i1.ParameterDescription(
              name: 'conversationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'speechRecorded': _i1.ParameterDescription(
              name: 'speechRecorded',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'timestamp': _i1.ParameterDescription(
              name: 'timestamp',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['text'] as _i4.TextEndpoint).record(
            session,
            params['conversationId'],
            params['speechRecorded'],
            params['timestamp'],
          ),
        ),
        'generateReply': _i1.MethodConnector(
          name: 'generateReply',
          params: {
            'encouraging': _i1.ParameterDescription(
              name: 'encouraging',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'constructive': _i1.ParameterDescription(
              name: 'constructive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'wellRounded': _i1.ParameterDescription(
              name: 'wellRounded',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['text'] as _i4.TextEndpoint).generateReply(
            session,
            encouraging: params['encouraging'],
            constructive: params['constructive'],
            wellRounded: params['wellRounded'],
          ),
        ),
      },
    );
  }
}
