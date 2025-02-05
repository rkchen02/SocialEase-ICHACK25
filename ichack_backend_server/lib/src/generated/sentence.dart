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

abstract class Sentence implements _i1.TableRow, _i1.ProtocolSerialization {
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

  static final t = SentenceTable();

  static const db = SentenceRepository._();

  @override
  int? id;

  int convoId;

  DateTime timestamp;

  String sentence;

  String emotion;

  @override
  _i1.Table get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'convoId': convoId,
      'timestamp': timestamp.toJson(),
      'sentence': sentence,
      'emotion': emotion,
    };
  }

  static SentenceInclude include() {
    return SentenceInclude._();
  }

  static SentenceIncludeList includeList({
    _i1.WhereExpressionBuilder<SentenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SentenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SentenceTable>? orderByList,
    SentenceInclude? include,
  }) {
    return SentenceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Sentence.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Sentence.t),
      include: include,
    );
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

class SentenceTable extends _i1.Table {
  SentenceTable({super.tableRelation}) : super(tableName: 'sentence') {
    convoId = _i1.ColumnInt(
      'convoId',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    sentence = _i1.ColumnString(
      'sentence',
      this,
    );
    emotion = _i1.ColumnString(
      'emotion',
      this,
    );
  }

  late final _i1.ColumnInt convoId;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnString sentence;

  late final _i1.ColumnString emotion;

  @override
  List<_i1.Column> get columns => [
        id,
        convoId,
        timestamp,
        sentence,
        emotion,
      ];
}

class SentenceInclude extends _i1.IncludeObject {
  SentenceInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => Sentence.t;
}

class SentenceIncludeList extends _i1.IncludeList {
  SentenceIncludeList._({
    _i1.WhereExpressionBuilder<SentenceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Sentence.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Sentence.t;
}

class SentenceRepository {
  const SentenceRepository._();

  Future<List<Sentence>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SentenceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SentenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SentenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Sentence>(
      where: where?.call(Sentence.t),
      orderBy: orderBy?.call(Sentence.t),
      orderByList: orderByList?.call(Sentence.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<Sentence?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SentenceTable>? where,
    int? offset,
    _i1.OrderByBuilder<SentenceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SentenceTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Sentence>(
      where: where?.call(Sentence.t),
      orderBy: orderBy?.call(Sentence.t),
      orderByList: orderByList?.call(Sentence.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<Sentence?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Sentence>(
      id,
      transaction: transaction,
    );
  }

  Future<List<Sentence>> insert(
    _i1.Session session,
    List<Sentence> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Sentence>(
      rows,
      transaction: transaction,
    );
  }

  Future<Sentence> insertRow(
    _i1.Session session,
    Sentence row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Sentence>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Sentence>> update(
    _i1.Session session,
    List<Sentence> rows, {
    _i1.ColumnSelections<SentenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Sentence>(
      rows,
      columns: columns?.call(Sentence.t),
      transaction: transaction,
    );
  }

  Future<Sentence> updateRow(
    _i1.Session session,
    Sentence row, {
    _i1.ColumnSelections<SentenceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Sentence>(
      row,
      columns: columns?.call(Sentence.t),
      transaction: transaction,
    );
  }

  Future<List<Sentence>> delete(
    _i1.Session session,
    List<Sentence> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Sentence>(
      rows,
      transaction: transaction,
    );
  }

  Future<Sentence> deleteRow(
    _i1.Session session,
    Sentence row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Sentence>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Sentence>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SentenceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Sentence>(
      where: where(Sentence.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SentenceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Sentence>(
      where: where?.call(Sentence.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
