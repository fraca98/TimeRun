// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int? startsession;
  final int? endsession;
  final String? device1;
  final String? device2;
  const Session(
      {required this.id,
      this.startsession,
      this.endsession,
      this.device1,
      this.device2});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || startsession != null) {
      map['startsession'] = Variable<int>(startsession);
    }
    if (!nullToAbsent || endsession != null) {
      map['endsession'] = Variable<int>(endsession);
    }
    if (!nullToAbsent || device1 != null) {
      map['device1'] = Variable<String>(device1);
    }
    if (!nullToAbsent || device2 != null) {
      map['device2'] = Variable<String>(device2);
    }
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      startsession: startsession == null && nullToAbsent
          ? const Value.absent()
          : Value(startsession),
      endsession: endsession == null && nullToAbsent
          ? const Value.absent()
          : Value(endsession),
      device1: device1 == null && nullToAbsent
          ? const Value.absent()
          : Value(device1),
      device2: device2 == null && nullToAbsent
          ? const Value.absent()
          : Value(device2),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      startsession: serializer.fromJson<int?>(json['startsession']),
      endsession: serializer.fromJson<int?>(json['endsession']),
      device1: serializer.fromJson<String?>(json['device1']),
      device2: serializer.fromJson<String?>(json['device2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startsession': serializer.toJson<int?>(startsession),
      'endsession': serializer.toJson<int?>(endsession),
      'device1': serializer.toJson<String?>(device1),
      'device2': serializer.toJson<String?>(device2),
    };
  }

  Session copyWith(
          {int? id,
          Value<int?> startsession = const Value.absent(),
          Value<int?> endsession = const Value.absent(),
          Value<String?> device1 = const Value.absent(),
          Value<String?> device2 = const Value.absent()}) =>
      Session(
        id: id ?? this.id,
        startsession:
            startsession.present ? startsession.value : this.startsession,
        endsession: endsession.present ? endsession.value : this.endsession,
        device1: device1.present ? device1.value : this.device1,
        device2: device2.present ? device2.value : this.device2,
      );
  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('startsession: $startsession, ')
          ..write('endsession: $endsession, ')
          ..write('device1: $device1, ')
          ..write('device2: $device2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startsession, endsession, device1, device2);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.startsession == this.startsession &&
          other.endsession == this.endsession &&
          other.device1 == this.device1 &&
          other.device2 == this.device2);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int?> startsession;
  final Value<int?> endsession;
  final Value<String?> device1;
  final Value<String?> device2;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.startsession = const Value.absent(),
    this.endsession = const Value.absent(),
    this.device1 = const Value.absent(),
    this.device2 = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    this.startsession = const Value.absent(),
    this.endsession = const Value.absent(),
    this.device1 = const Value.absent(),
    this.device2 = const Value.absent(),
  });
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? startsession,
    Expression<int>? endsession,
    Expression<String>? device1,
    Expression<String>? device2,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startsession != null) 'startsession': startsession,
      if (endsession != null) 'endsession': endsession,
      if (device1 != null) 'device1': device1,
      if (device2 != null) 'device2': device2,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? startsession,
      Value<int?>? endsession,
      Value<String?>? device1,
      Value<String?>? device2}) {
    return SessionsCompanion(
      id: id ?? this.id,
      startsession: startsession ?? this.startsession,
      endsession: endsession ?? this.endsession,
      device1: device1 ?? this.device1,
      device2: device2 ?? this.device2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startsession.present) {
      map['startsession'] = Variable<int>(startsession.value);
    }
    if (endsession.present) {
      map['endsession'] = Variable<int>(endsession.value);
    }
    if (device1.present) {
      map['device1'] = Variable<String>(device1.value);
    }
    if (device2.present) {
      map['device2'] = Variable<String>(device2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('startsession: $startsession, ')
          ..write('endsession: $endsession, ')
          ..write('device1: $device1, ')
          ..write('device2: $device2')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _startsessionMeta =
      const VerificationMeta('startsession');
  @override
  late final GeneratedColumn<int> startsession = GeneratedColumn<int>(
      'startsession', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _endsessionMeta = const VerificationMeta('endsession');
  @override
  late final GeneratedColumn<int> endsession = GeneratedColumn<int>(
      'endsession', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  final VerificationMeta _device1Meta = const VerificationMeta('device1');
  @override
  late final GeneratedColumn<String> device1 = GeneratedColumn<String>(
      'device1', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  final VerificationMeta _device2Meta = const VerificationMeta('device2');
  @override
  late final GeneratedColumn<String> device2 = GeneratedColumn<String>(
      'device2', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, startsession, endsession, device1, device2];
  @override
  String get aliasedName => _alias ?? 'sessions';
  @override
  String get actualTableName => 'sessions';
  @override
  VerificationContext validateIntegrity(Insertable<Session> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('startsession')) {
      context.handle(
          _startsessionMeta,
          startsession.isAcceptableOrUnknown(
              data['startsession']!, _startsessionMeta));
    }
    if (data.containsKey('endsession')) {
      context.handle(
          _endsessionMeta,
          endsession.isAcceptableOrUnknown(
              data['endsession']!, _endsessionMeta));
    }
    if (data.containsKey('device1')) {
      context.handle(_device1Meta,
          device1.isAcceptableOrUnknown(data['device1']!, _device1Meta));
    }
    if (data.containsKey('device2')) {
      context.handle(_device2Meta,
          device2.isAcceptableOrUnknown(data['device2']!, _device2Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      startsession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}startsession']),
      endsession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}endsession']),
      device1: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}device1']),
      device2: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}device2']),
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String surname;
  final bool sex;
  final int? session1;
  final int? session2;
  const User(
      {required this.id,
      required this.name,
      required this.surname,
      required this.sex,
      this.session1,
      this.session2});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['surname'] = Variable<String>(surname);
    map['sex'] = Variable<bool>(sex);
    if (!nullToAbsent || session1 != null) {
      map['session1'] = Variable<int>(session1);
    }
    if (!nullToAbsent || session2 != null) {
      map['session2'] = Variable<int>(session2);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      surname: Value(surname),
      sex: Value(sex),
      session1: session1 == null && nullToAbsent
          ? const Value.absent()
          : Value(session1),
      session2: session2 == null && nullToAbsent
          ? const Value.absent()
          : Value(session2),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      surname: serializer.fromJson<String>(json['surname']),
      sex: serializer.fromJson<bool>(json['sex']),
      session1: serializer.fromJson<int?>(json['session1']),
      session2: serializer.fromJson<int?>(json['session2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'surname': serializer.toJson<String>(surname),
      'sex': serializer.toJson<bool>(sex),
      'session1': serializer.toJson<int?>(session1),
      'session2': serializer.toJson<int?>(session2),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? surname,
          bool? sex,
          Value<int?> session1 = const Value.absent(),
          Value<int?> session2 = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        sex: sex ?? this.sex,
        session1: session1.present ? session1.value : this.session1,
        session2: session2.present ? session2.value : this.session2,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surname: $surname, ')
          ..write('sex: $sex, ')
          ..write('session1: $session1, ')
          ..write('session2: $session2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, surname, sex, session1, session2);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.surname == this.surname &&
          other.sex == this.sex &&
          other.session1 == this.session1 &&
          other.session2 == this.session2);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> surname;
  final Value<bool> sex;
  final Value<int?> session1;
  final Value<int?> session2;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.surname = const Value.absent(),
    this.sex = const Value.absent(),
    this.session1 = const Value.absent(),
    this.session2 = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String surname,
    required bool sex,
    this.session1 = const Value.absent(),
    this.session2 = const Value.absent(),
  })  : name = Value(name),
        surname = Value(surname),
        sex = Value(sex);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? surname,
    Expression<bool>? sex,
    Expression<int>? session1,
    Expression<int>? session2,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (sex != null) 'sex': sex,
      if (session1 != null) 'session1': session1,
      if (session2 != null) 'session2': session2,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? surname,
      Value<bool>? sex,
      Value<int?>? session1,
      Value<int?>? session2}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      sex: sex ?? this.sex,
      session1: session1 ?? this.session1,
      session2: session2 ?? this.session2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (surname.present) {
      map['surname'] = Variable<String>(surname.value);
    }
    if (sex.present) {
      map['sex'] = Variable<bool>(sex.value);
    }
    if (session1.present) {
      map['session1'] = Variable<int>(session1.value);
    }
    if (session2.present) {
      map['session2'] = Variable<int>(session2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surname: $surname, ')
          ..write('sex: $sex, ')
          ..write('session1: $session1, ')
          ..write('session2: $session2')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _surnameMeta = const VerificationMeta('surname');
  @override
  late final GeneratedColumn<String> surname = GeneratedColumn<String>(
      'surname', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<bool> sex = GeneratedColumn<bool>(
      'sex', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK (sex IN (0, 1))');
  final VerificationMeta _session1Meta = const VerificationMeta('session1');
  @override
  late final GeneratedColumn<int> session1 = GeneratedColumn<int>(
      'session1', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES sessions (id)');
  final VerificationMeta _session2Meta = const VerificationMeta('session2');
  @override
  late final GeneratedColumn<int> session2 = GeneratedColumn<int>(
      'session2', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'REFERENCES sessions (id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, surname, sex, session1, session2];
  @override
  String get aliasedName => _alias ?? 'users';
  @override
  String get actualTableName => 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('surname')) {
      context.handle(_surnameMeta,
          surname.isAcceptableOrUnknown(data['surname']!, _surnameMeta));
    } else if (isInserting) {
      context.missing(_surnameMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('session1')) {
      context.handle(_session1Meta,
          session1.isAcceptableOrUnknown(data['session1']!, _session1Meta));
    }
    if (data.containsKey('session2')) {
      context.handle(_session2Meta,
          session2.isAcceptableOrUnknown(data['session2']!, _session2Meta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      surname: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}surname'])!,
      sex: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}sex'])!,
      session1: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}session1']),
      session2: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}session2']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class Interval extends DataClass implements Insertable<Interval> {
  final int id;
  final int idSession;
  final String status;
  final int startstimestamp;
  final int endtimestamp;
  final int deltatime;
  const Interval(
      {required this.id,
      required this.idSession,
      required this.status,
      required this.startstimestamp,
      required this.endtimestamp,
      required this.deltatime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_session'] = Variable<int>(idSession);
    map['status'] = Variable<String>(status);
    map['startstimestamp'] = Variable<int>(startstimestamp);
    map['endtimestamp'] = Variable<int>(endtimestamp);
    map['deltatime'] = Variable<int>(deltatime);
    return map;
  }

  IntervalsCompanion toCompanion(bool nullToAbsent) {
    return IntervalsCompanion(
      id: Value(id),
      idSession: Value(idSession),
      status: Value(status),
      startstimestamp: Value(startstimestamp),
      endtimestamp: Value(endtimestamp),
      deltatime: Value(deltatime),
    );
  }

  factory Interval.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Interval(
      id: serializer.fromJson<int>(json['id']),
      idSession: serializer.fromJson<int>(json['idSession']),
      status: serializer.fromJson<String>(json['status']),
      startstimestamp: serializer.fromJson<int>(json['startstimestamp']),
      endtimestamp: serializer.fromJson<int>(json['endtimestamp']),
      deltatime: serializer.fromJson<int>(json['deltatime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idSession': serializer.toJson<int>(idSession),
      'status': serializer.toJson<String>(status),
      'startstimestamp': serializer.toJson<int>(startstimestamp),
      'endtimestamp': serializer.toJson<int>(endtimestamp),
      'deltatime': serializer.toJson<int>(deltatime),
    };
  }

  Interval copyWith(
          {int? id,
          int? idSession,
          String? status,
          int? startstimestamp,
          int? endtimestamp,
          int? deltatime}) =>
      Interval(
        id: id ?? this.id,
        idSession: idSession ?? this.idSession,
        status: status ?? this.status,
        startstimestamp: startstimestamp ?? this.startstimestamp,
        endtimestamp: endtimestamp ?? this.endtimestamp,
        deltatime: deltatime ?? this.deltatime,
      );
  @override
  String toString() {
    return (StringBuffer('Interval(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('status: $status, ')
          ..write('startstimestamp: $startstimestamp, ')
          ..write('endtimestamp: $endtimestamp, ')
          ..write('deltatime: $deltatime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, idSession, status, startstimestamp, endtimestamp, deltatime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Interval &&
          other.id == this.id &&
          other.idSession == this.idSession &&
          other.status == this.status &&
          other.startstimestamp == this.startstimestamp &&
          other.endtimestamp == this.endtimestamp &&
          other.deltatime == this.deltatime);
}

class IntervalsCompanion extends UpdateCompanion<Interval> {
  final Value<int> id;
  final Value<int> idSession;
  final Value<String> status;
  final Value<int> startstimestamp;
  final Value<int> endtimestamp;
  final Value<int> deltatime;
  const IntervalsCompanion({
    this.id = const Value.absent(),
    this.idSession = const Value.absent(),
    this.status = const Value.absent(),
    this.startstimestamp = const Value.absent(),
    this.endtimestamp = const Value.absent(),
    this.deltatime = const Value.absent(),
  });
  IntervalsCompanion.insert({
    this.id = const Value.absent(),
    required int idSession,
    required String status,
    required int startstimestamp,
    required int endtimestamp,
    required int deltatime,
  })  : idSession = Value(idSession),
        status = Value(status),
        startstimestamp = Value(startstimestamp),
        endtimestamp = Value(endtimestamp),
        deltatime = Value(deltatime);
  static Insertable<Interval> custom({
    Expression<int>? id,
    Expression<int>? idSession,
    Expression<String>? status,
    Expression<int>? startstimestamp,
    Expression<int>? endtimestamp,
    Expression<int>? deltatime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSession != null) 'id_session': idSession,
      if (status != null) 'status': status,
      if (startstimestamp != null) 'startstimestamp': startstimestamp,
      if (endtimestamp != null) 'endtimestamp': endtimestamp,
      if (deltatime != null) 'deltatime': deltatime,
    });
  }

  IntervalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? idSession,
      Value<String>? status,
      Value<int>? startstimestamp,
      Value<int>? endtimestamp,
      Value<int>? deltatime}) {
    return IntervalsCompanion(
      id: id ?? this.id,
      idSession: idSession ?? this.idSession,
      status: status ?? this.status,
      startstimestamp: startstimestamp ?? this.startstimestamp,
      endtimestamp: endtimestamp ?? this.endtimestamp,
      deltatime: deltatime ?? this.deltatime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idSession.present) {
      map['id_session'] = Variable<int>(idSession.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startstimestamp.present) {
      map['startstimestamp'] = Variable<int>(startstimestamp.value);
    }
    if (endtimestamp.present) {
      map['endtimestamp'] = Variable<int>(endtimestamp.value);
    }
    if (deltatime.present) {
      map['deltatime'] = Variable<int>(deltatime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalsCompanion(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('status: $status, ')
          ..write('startstimestamp: $startstimestamp, ')
          ..write('endtimestamp: $endtimestamp, ')
          ..write('deltatime: $deltatime')
          ..write(')'))
        .toString();
  }
}

class $IntervalsTable extends Intervals
    with TableInfo<$IntervalsTable, Interval> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntervalsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _idSessionMeta = const VerificationMeta('idSession');
  @override
  late final GeneratedColumn<int> idSession = GeneratedColumn<int>(
      'id_session', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _startstimestampMeta =
      const VerificationMeta('startstimestamp');
  @override
  late final GeneratedColumn<int> startstimestamp = GeneratedColumn<int>(
      'startstimestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _endtimestampMeta =
      const VerificationMeta('endtimestamp');
  @override
  late final GeneratedColumn<int> endtimestamp = GeneratedColumn<int>(
      'endtimestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _deltatimeMeta = const VerificationMeta('deltatime');
  @override
  late final GeneratedColumn<int> deltatime = GeneratedColumn<int>(
      'deltatime', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idSession, status, startstimestamp, endtimestamp, deltatime];
  @override
  String get aliasedName => _alias ?? 'intervals';
  @override
  String get actualTableName => 'intervals';
  @override
  VerificationContext validateIntegrity(Insertable<Interval> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('id_session')) {
      context.handle(_idSessionMeta,
          idSession.isAcceptableOrUnknown(data['id_session']!, _idSessionMeta));
    } else if (isInserting) {
      context.missing(_idSessionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('startstimestamp')) {
      context.handle(
          _startstimestampMeta,
          startstimestamp.isAcceptableOrUnknown(
              data['startstimestamp']!, _startstimestampMeta));
    } else if (isInserting) {
      context.missing(_startstimestampMeta);
    }
    if (data.containsKey('endtimestamp')) {
      context.handle(
          _endtimestampMeta,
          endtimestamp.isAcceptableOrUnknown(
              data['endtimestamp']!, _endtimestampMeta));
    } else if (isInserting) {
      context.missing(_endtimestampMeta);
    }
    if (data.containsKey('deltatime')) {
      context.handle(_deltatimeMeta,
          deltatime.isAcceptableOrUnknown(data['deltatime']!, _deltatimeMeta));
    } else if (isInserting) {
      context.missing(_deltatimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Interval map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Interval(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idSession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_session'])!,
      status: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      startstimestamp: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}startstimestamp'])!,
      endtimestamp: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}endtimestamp'])!,
      deltatime: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}deltatime'])!,
    );
  }

  @override
  $IntervalsTable createAlias(String alias) {
    return $IntervalsTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $IntervalsTable intervals = $IntervalsTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  late final IntervalsDao intervalsDao = IntervalsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sessions, users, intervals];
}
