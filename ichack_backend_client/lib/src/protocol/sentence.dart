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

abstract class Sentence implements _i1.SerializableModel {
  Sentence._({
    this.id,
    required this.convoId,
    required this.timestamp,
    required this.sentence,
    required this.emotion,
  });

  factory Sentence({
    int? id,
    required int convoId,
    required DateTime timestamp,
    required String sentence,
    required String emotion,
  }) = _SentenceImpl;

  factory Sentence.fromJson(Map<String, dynamic> jsonSerialization) {
    return Sentence(
      id: jsonSerialization['id'] as int?,
      convoId: jsonSerialization['convoId'] as int,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      sentence: jsonSerialization['sentence'] as String,
      emotion: jsonSerialization['emotion'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int convoId;

  DateTime timestamp;

  String sentence;

  String emotion;

  Sentence copyWith({
    int? id,
    int? convoId,
    DateTime? timestamp,
    String? sentence,
    String? emotion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'convoId': convoId,
      'timestamp': timestamp.toJson(),
      'sentence': sentence,
      'emotion': emotion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SentenceImpl extends Sentence {
  _SentenceImpl({
    int? id,
    required int convoId,
    required DateTime timestamp,
    required String sentence,
    required String emotion,
  }) : super._(
          id: id,
          convoId: convoId,
          timestamp: timestamp,
          sentence: sentence,
          emotion: emotion,
        );

  @override
  Sentence copyWith({
    Object? id = _Undefined,
    int? convoId,
    DateTime? timestamp,
    String? sentence,
    String? emotion,
  }) {
    return Sentence(
      id: id is int? ? id : this.id,
      convoId: convoId ?? this.convoId,
      timestamp: timestamp ?? this.timestamp,
      sentence: sentence ?? this.sentence,
      emotion: emotion ?? this.emotion,
    );
  }
}
