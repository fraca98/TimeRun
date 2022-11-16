// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends DataClass implements Insertable<User> {
  final int id;
  final bool sex;
  final int birthYear;
  final int completed;
  const User(
      {required this.id,
      required this.sex,
      required this.birthYear,
      required this.completed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sex'] = Variable<bool>(sex);
    map['birth_year'] = Variable<int>(birthYear);
    map['completed'] = Variable<int>(completed);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      sex: Value(sex),
      birthYear: Value(birthYear),
      completed: Value(completed),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      sex: serializer.fromJson<bool>(json['sex']),
      birthYear: serializer.fromJson<int>(json['birthYear']),
      completed: serializer.fromJson<int>(json['completed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sex': serializer.toJson<bool>(sex),
      'birthYear': serializer.toJson<int>(birthYear),
      'completed': serializer.toJson<int>(completed),
    };
  }

  User copyWith({int? id, bool? sex, int? birthYear, int? completed}) => User(
        id: id ?? this.id,
        sex: sex ?? this.sex,
        birthYear: birthYear ?? this.birthYear,
        completed: completed ?? this.completed,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sex, birthYear, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.sex == this.sex &&
          other.birthYear == this.birthYear &&
          other.completed == this.completed);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<bool> sex;
  final Value<int> birthYear;
  final Value<int> completed;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.sex = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.completed = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required bool sex,
    required int birthYear,
    this.completed = const Value.absent(),
  })  : sex = Value(sex),
        birthYear = Value(birthYear);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<bool>? sex,
    Expression<int>? birthYear,
    Expression<int>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sex != null) 'sex': sex,
      if (birthYear != null) 'birth_year': birthYear,
      if (completed != null) 'completed': completed,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<bool>? sex,
      Value<int>? birthYear,
      Value<int>? completed}) {
    return UsersCompanion(
      id: id ?? this.id,
      sex: sex ?? this.sex,
      birthYear: birthYear ?? this.birthYear,
      completed: completed ?? this.completed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sex.present) {
      map['sex'] = Variable<bool>(sex.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (completed.present) {
      map['completed'] = Variable<int>(completed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('sex: $sex, ')
          ..write('birthYear: $birthYear, ')
          ..write('completed: $completed')
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
  final VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<bool> sex = GeneratedColumn<bool>(
      'sex', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: 'CHECK ("sex" IN (0, 1))');
  final VerificationMeta _birthYearMeta = const VerificationMeta('birthYear');
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
      'birth_year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  @override
  late final GeneratedColumn<int> completed = GeneratedColumn<int>(
      'completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, sex, birthYear, completed];
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
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('birth_year')) {
      context.handle(_birthYearMeta,
          birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta));
    } else if (isInserting) {
      context.missing(_birthYearMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
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
      sex: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}sex'])!,
      birthYear: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}birth_year'])!,
      completed: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}completed'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int iduser;
  final int numsession;
  final DateTime start;
  final DateTime end;
  final String device1;
  final String device2;
  final bool download;
  const Session(
      {required this.id,
      required this.iduser,
      required this.numsession,
      required this.start,
      required this.end,
      required this.device1,
      required this.device2,
      required this.download});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['iduser'] = Variable<int>(iduser);
    map['numsession'] = Variable<int>(numsession);
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    map['device1'] = Variable<String>(device1);
    map['device2'] = Variable<String>(device2);
    map['download'] = Variable<bool>(download);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      iduser: Value(iduser),
      numsession: Value(numsession),
      start: Value(start),
      end: Value(end),
      device1: Value(device1),
      device2: Value(device2),
      download: Value(download),
    );
  }

  factory Session.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      iduser: serializer.fromJson<int>(json['iduser']),
      numsession: serializer.fromJson<int>(json['numsession']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      device1: serializer.fromJson<String>(json['device1']),
      device2: serializer.fromJson<String>(json['device2']),
      download: serializer.fromJson<bool>(json['download']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'iduser': serializer.toJson<int>(iduser),
      'numsession': serializer.toJson<int>(numsession),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'device1': serializer.toJson<String>(device1),
      'device2': serializer.toJson<String>(device2),
      'download': serializer.toJson<bool>(download),
    };
  }

  Session copyWith(
          {int? id,
          int? iduser,
          int? numsession,
          DateTime? start,
          DateTime? end,
          String? device1,
          String? device2,
          bool? download}) =>
      Session(
        id: id ?? this.id,
        iduser: iduser ?? this.iduser,
        numsession: numsession ?? this.numsession,
        start: start ?? this.start,
        end: end ?? this.end,
        device1: device1 ?? this.device1,
        device2: device2 ?? this.device2,
        download: download ?? this.download,
      );
  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('iduser: $iduser, ')
          ..write('numsession: $numsession, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('device1: $device1, ')
          ..write('device2: $device2, ')
          ..write('download: $download')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, iduser, numsession, start, end, device1, device2, download);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.iduser == this.iduser &&
          other.numsession == this.numsession &&
          other.start == this.start &&
          other.end == this.end &&
          other.device1 == this.device1 &&
          other.device2 == this.device2 &&
          other.download == this.download);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> iduser;
  final Value<int> numsession;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<String> device1;
  final Value<String> device2;
  final Value<bool> download;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.iduser = const Value.absent(),
    this.numsession = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.device1 = const Value.absent(),
    this.device2 = const Value.absent(),
    this.download = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int iduser,
    required int numsession,
    required DateTime start,
    required DateTime end,
    required String device1,
    required String device2,
    this.download = const Value.absent(),
  })  : iduser = Value(iduser),
        numsession = Value(numsession),
        start = Value(start),
        end = Value(end),
        device1 = Value(device1),
        device2 = Value(device2);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? iduser,
    Expression<int>? numsession,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<String>? device1,
    Expression<String>? device2,
    Expression<bool>? download,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (iduser != null) 'iduser': iduser,
      if (numsession != null) 'numsession': numsession,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (device1 != null) 'device1': device1,
      if (device2 != null) 'device2': device2,
      if (download != null) 'download': download,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? iduser,
      Value<int>? numsession,
      Value<DateTime>? start,
      Value<DateTime>? end,
      Value<String>? device1,
      Value<String>? device2,
      Value<bool>? download}) {
    return SessionsCompanion(
      id: id ?? this.id,
      iduser: iduser ?? this.iduser,
      numsession: numsession ?? this.numsession,
      start: start ?? this.start,
      end: end ?? this.end,
      device1: device1 ?? this.device1,
      device2: device2 ?? this.device2,
      download: download ?? this.download,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (iduser.present) {
      map['iduser'] = Variable<int>(iduser.value);
    }
    if (numsession.present) {
      map['numsession'] = Variable<int>(numsession.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (device1.present) {
      map['device1'] = Variable<String>(device1.value);
    }
    if (device2.present) {
      map['device2'] = Variable<String>(device2.value);
    }
    if (download.present) {
      map['download'] = Variable<bool>(download.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('iduser: $iduser, ')
          ..write('numsession: $numsession, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('device1: $device1, ')
          ..write('device2: $device2, ')
          ..write('download: $download')
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
  final VerificationMeta _iduserMeta = const VerificationMeta('iduser');
  @override
  late final GeneratedColumn<int> iduser = GeneratedColumn<int>(
      'iduser', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES "users" ("id") ON DELETE CASCADE');
  final VerificationMeta _numsessionMeta = const VerificationMeta('numsession');
  @override
  late final GeneratedColumn<int> numsession = GeneratedColumn<int>(
      'numsession', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
      'start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
      'end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _device1Meta = const VerificationMeta('device1');
  @override
  late final GeneratedColumn<String> device1 = GeneratedColumn<String>(
      'device1', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _device2Meta = const VerificationMeta('device2');
  @override
  late final GeneratedColumn<String> device2 = GeneratedColumn<String>(
      'device2', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  final VerificationMeta _downloadMeta = const VerificationMeta('download');
  @override
  late final GeneratedColumn<bool> download = GeneratedColumn<bool>(
      'download', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK ("download" IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, iduser, numsession, start, end, device1, device2, download];
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
    if (data.containsKey('iduser')) {
      context.handle(_iduserMeta,
          iduser.isAcceptableOrUnknown(data['iduser']!, _iduserMeta));
    } else if (isInserting) {
      context.missing(_iduserMeta);
    }
    if (data.containsKey('numsession')) {
      context.handle(
          _numsessionMeta,
          numsession.isAcceptableOrUnknown(
              data['numsession']!, _numsessionMeta));
    } else if (isInserting) {
      context.missing(_numsessionMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end']!, _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('device1')) {
      context.handle(_device1Meta,
          device1.isAcceptableOrUnknown(data['device1']!, _device1Meta));
    } else if (isInserting) {
      context.missing(_device1Meta);
    }
    if (data.containsKey('device2')) {
      context.handle(_device2Meta,
          device2.isAcceptableOrUnknown(data['device2']!, _device2Meta));
    } else if (isInserting) {
      context.missing(_device2Meta);
    }
    if (data.containsKey('download')) {
      context.handle(_downloadMeta,
          download.isAcceptableOrUnknown(data['download']!, _downloadMeta));
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
      iduser: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}iduser'])!,
      numsession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}numsession'])!,
      start: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start'])!,
      end: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end'])!,
      device1: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}device1'])!,
      device2: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}device2'])!,
      download: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}download'])!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Interval extends DataClass implements Insertable<Interval> {
  final int id;
  final int idSession;
  final int runstatus;
  final DateTime start;
  final DateTime end;
  final int deltatime;
  const Interval(
      {required this.id,
      required this.idSession,
      required this.runstatus,
      required this.start,
      required this.end,
      required this.deltatime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_session'] = Variable<int>(idSession);
    map['runstatus'] = Variable<int>(runstatus);
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    map['deltatime'] = Variable<int>(deltatime);
    return map;
  }

  IntervalsCompanion toCompanion(bool nullToAbsent) {
    return IntervalsCompanion(
      id: Value(id),
      idSession: Value(idSession),
      runstatus: Value(runstatus),
      start: Value(start),
      end: Value(end),
      deltatime: Value(deltatime),
    );
  }

  factory Interval.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Interval(
      id: serializer.fromJson<int>(json['id']),
      idSession: serializer.fromJson<int>(json['idSession']),
      runstatus: serializer.fromJson<int>(json['runstatus']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      deltatime: serializer.fromJson<int>(json['deltatime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idSession': serializer.toJson<int>(idSession),
      'runstatus': serializer.toJson<int>(runstatus),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'deltatime': serializer.toJson<int>(deltatime),
    };
  }

  Interval copyWith(
          {int? id,
          int? idSession,
          int? runstatus,
          DateTime? start,
          DateTime? end,
          int? deltatime}) =>
      Interval(
        id: id ?? this.id,
        idSession: idSession ?? this.idSession,
        runstatus: runstatus ?? this.runstatus,
        start: start ?? this.start,
        end: end ?? this.end,
        deltatime: deltatime ?? this.deltatime,
      );
  @override
  String toString() {
    return (StringBuffer('Interval(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('runstatus: $runstatus, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('deltatime: $deltatime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, idSession, runstatus, start, end, deltatime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Interval &&
          other.id == this.id &&
          other.idSession == this.idSession &&
          other.runstatus == this.runstatus &&
          other.start == this.start &&
          other.end == this.end &&
          other.deltatime == this.deltatime);
}

class IntervalsCompanion extends UpdateCompanion<Interval> {
  final Value<int> id;
  final Value<int> idSession;
  final Value<int> runstatus;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<int> deltatime;
  const IntervalsCompanion({
    this.id = const Value.absent(),
    this.idSession = const Value.absent(),
    this.runstatus = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.deltatime = const Value.absent(),
  });
  IntervalsCompanion.insert({
    this.id = const Value.absent(),
    required int idSession,
    required int runstatus,
    required DateTime start,
    required DateTime end,
    required int deltatime,
  })  : idSession = Value(idSession),
        runstatus = Value(runstatus),
        start = Value(start),
        end = Value(end),
        deltatime = Value(deltatime);
  static Insertable<Interval> custom({
    Expression<int>? id,
    Expression<int>? idSession,
    Expression<int>? runstatus,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<int>? deltatime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSession != null) 'id_session': idSession,
      if (runstatus != null) 'runstatus': runstatus,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (deltatime != null) 'deltatime': deltatime,
    });
  }

  IntervalsCompanion copyWith(
      {Value<int>? id,
      Value<int>? idSession,
      Value<int>? runstatus,
      Value<DateTime>? start,
      Value<DateTime>? end,
      Value<int>? deltatime}) {
    return IntervalsCompanion(
      id: id ?? this.id,
      idSession: idSession ?? this.idSession,
      runstatus: runstatus ?? this.runstatus,
      start: start ?? this.start,
      end: end ?? this.end,
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
    if (runstatus.present) {
      map['runstatus'] = Variable<int>(runstatus.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
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
          ..write('runstatus: $runstatus, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES "sessions" ("id") ON DELETE CASCADE');
  final VerificationMeta _runstatusMeta = const VerificationMeta('runstatus');
  @override
  late final GeneratedColumn<int> runstatus = GeneratedColumn<int>(
      'runstatus', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
      'start', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
      'end', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _deltatimeMeta = const VerificationMeta('deltatime');
  @override
  late final GeneratedColumn<int> deltatime = GeneratedColumn<int>(
      'deltatime', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, idSession, runstatus, start, end, deltatime];
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
    if (data.containsKey('runstatus')) {
      context.handle(_runstatusMeta,
          runstatus.isAcceptableOrUnknown(data['runstatus']!, _runstatusMeta));
    } else if (isInserting) {
      context.missing(_runstatusMeta);
    }
    if (data.containsKey('start')) {
      context.handle(
          _startMeta, start.isAcceptableOrUnknown(data['start']!, _startMeta));
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
          _endMeta, end.isAcceptableOrUnknown(data['end']!, _endMeta));
    } else if (isInserting) {
      context.missing(_endMeta);
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
      runstatus: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}runstatus'])!,
      start: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start'])!,
      end: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end'])!,
      deltatime: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}deltatime'])!,
    );
  }

  @override
  $IntervalsTable createAlias(String alias) {
    return $IntervalsTable(attachedDatabase, alias);
  }
}

class PolarRate extends DataClass implements Insertable<PolarRate> {
  final int id;
  final int idSession;
  final DateTime time;
  final int rate;
  const PolarRate(
      {required this.id,
      required this.idSession,
      required this.time,
      required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_session'] = Variable<int>(idSession);
    map['time'] = Variable<DateTime>(time);
    map['rate'] = Variable<int>(rate);
    return map;
  }

  PolarRatesCompanion toCompanion(bool nullToAbsent) {
    return PolarRatesCompanion(
      id: Value(id),
      idSession: Value(idSession),
      time: Value(time),
      rate: Value(rate),
    );
  }

  factory PolarRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PolarRate(
      id: serializer.fromJson<int>(json['id']),
      idSession: serializer.fromJson<int>(json['idSession']),
      time: serializer.fromJson<DateTime>(json['time']),
      rate: serializer.fromJson<int>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idSession': serializer.toJson<int>(idSession),
      'time': serializer.toJson<DateTime>(time),
      'rate': serializer.toJson<int>(rate),
    };
  }

  PolarRate copyWith({int? id, int? idSession, DateTime? time, int? rate}) =>
      PolarRate(
        id: id ?? this.id,
        idSession: idSession ?? this.idSession,
        time: time ?? this.time,
        rate: rate ?? this.rate,
      );
  @override
  String toString() {
    return (StringBuffer('PolarRate(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idSession, time, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PolarRate &&
          other.id == this.id &&
          other.idSession == this.idSession &&
          other.time == this.time &&
          other.rate == this.rate);
}

class PolarRatesCompanion extends UpdateCompanion<PolarRate> {
  final Value<int> id;
  final Value<int> idSession;
  final Value<DateTime> time;
  final Value<int> rate;
  const PolarRatesCompanion({
    this.id = const Value.absent(),
    this.idSession = const Value.absent(),
    this.time = const Value.absent(),
    this.rate = const Value.absent(),
  });
  PolarRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idSession,
    required DateTime time,
    required int rate,
  })  : idSession = Value(idSession),
        time = Value(time),
        rate = Value(rate);
  static Insertable<PolarRate> custom({
    Expression<int>? id,
    Expression<int>? idSession,
    Expression<DateTime>? time,
    Expression<int>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSession != null) 'id_session': idSession,
      if (time != null) 'time': time,
      if (rate != null) 'rate': rate,
    });
  }

  PolarRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idSession,
      Value<DateTime>? time,
      Value<int>? rate}) {
    return PolarRatesCompanion(
      id: id ?? this.id,
      idSession: idSession ?? this.idSession,
      time: time ?? this.time,
      rate: rate ?? this.rate,
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
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PolarRatesCompanion(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $PolarRatesTable extends PolarRates
    with TableInfo<$PolarRatesTable, PolarRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PolarRatesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES "sessions" ("id") ON DELETE CASCADE');
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
      'rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idSession, time, rate];
  @override
  String get aliasedName => _alias ?? 'polar_rates';
  @override
  String get actualTableName => 'polar_rates';
  @override
  VerificationContext validateIntegrity(Insertable<PolarRate> instance,
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
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PolarRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PolarRate(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idSession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_session'])!,
      time: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time'])!,
      rate: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $PolarRatesTable createAlias(String alias) {
    return $PolarRatesTable(attachedDatabase, alias);
  }
}

class FitbitRate extends DataClass implements Insertable<FitbitRate> {
  final int id;
  final int idSession;
  final DateTime time;
  final int rate;
  const FitbitRate(
      {required this.id,
      required this.idSession,
      required this.time,
      required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_session'] = Variable<int>(idSession);
    map['time'] = Variable<DateTime>(time);
    map['rate'] = Variable<int>(rate);
    return map;
  }

  FitbitRatesCompanion toCompanion(bool nullToAbsent) {
    return FitbitRatesCompanion(
      id: Value(id),
      idSession: Value(idSession),
      time: Value(time),
      rate: Value(rate),
    );
  }

  factory FitbitRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FitbitRate(
      id: serializer.fromJson<int>(json['id']),
      idSession: serializer.fromJson<int>(json['idSession']),
      time: serializer.fromJson<DateTime>(json['time']),
      rate: serializer.fromJson<int>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idSession': serializer.toJson<int>(idSession),
      'time': serializer.toJson<DateTime>(time),
      'rate': serializer.toJson<int>(rate),
    };
  }

  FitbitRate copyWith({int? id, int? idSession, DateTime? time, int? rate}) =>
      FitbitRate(
        id: id ?? this.id,
        idSession: idSession ?? this.idSession,
        time: time ?? this.time,
        rate: rate ?? this.rate,
      );
  @override
  String toString() {
    return (StringBuffer('FitbitRate(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idSession, time, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FitbitRate &&
          other.id == this.id &&
          other.idSession == this.idSession &&
          other.time == this.time &&
          other.rate == this.rate);
}

class FitbitRatesCompanion extends UpdateCompanion<FitbitRate> {
  final Value<int> id;
  final Value<int> idSession;
  final Value<DateTime> time;
  final Value<int> rate;
  const FitbitRatesCompanion({
    this.id = const Value.absent(),
    this.idSession = const Value.absent(),
    this.time = const Value.absent(),
    this.rate = const Value.absent(),
  });
  FitbitRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idSession,
    required DateTime time,
    required int rate,
  })  : idSession = Value(idSession),
        time = Value(time),
        rate = Value(rate);
  static Insertable<FitbitRate> custom({
    Expression<int>? id,
    Expression<int>? idSession,
    Expression<DateTime>? time,
    Expression<int>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSession != null) 'id_session': idSession,
      if (time != null) 'time': time,
      if (rate != null) 'rate': rate,
    });
  }

  FitbitRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idSession,
      Value<DateTime>? time,
      Value<int>? rate}) {
    return FitbitRatesCompanion(
      id: id ?? this.id,
      idSession: idSession ?? this.idSession,
      time: time ?? this.time,
      rate: rate ?? this.rate,
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
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FitbitRatesCompanion(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $FitbitRatesTable extends FitbitRates
    with TableInfo<$FitbitRatesTable, FitbitRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FitbitRatesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES "sessions" ("id") ON DELETE CASCADE');
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
      'rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idSession, time, rate];
  @override
  String get aliasedName => _alias ?? 'fitbit_rates';
  @override
  String get actualTableName => 'fitbit_rates';
  @override
  VerificationContext validateIntegrity(Insertable<FitbitRate> instance,
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
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FitbitRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FitbitRate(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idSession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_session'])!,
      time: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time'])!,
      rate: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $FitbitRatesTable createAlias(String alias) {
    return $FitbitRatesTable(attachedDatabase, alias);
  }
}

class WithingsRate extends DataClass implements Insertable<WithingsRate> {
  final int id;
  final int idSession;
  final DateTime time;
  final int rate;
  const WithingsRate(
      {required this.id,
      required this.idSession,
      required this.time,
      required this.rate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_session'] = Variable<int>(idSession);
    map['time'] = Variable<DateTime>(time);
    map['rate'] = Variable<int>(rate);
    return map;
  }

  WithingsRatesCompanion toCompanion(bool nullToAbsent) {
    return WithingsRatesCompanion(
      id: Value(id),
      idSession: Value(idSession),
      time: Value(time),
      rate: Value(rate),
    );
  }

  factory WithingsRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WithingsRate(
      id: serializer.fromJson<int>(json['id']),
      idSession: serializer.fromJson<int>(json['idSession']),
      time: serializer.fromJson<DateTime>(json['time']),
      rate: serializer.fromJson<int>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idSession': serializer.toJson<int>(idSession),
      'time': serializer.toJson<DateTime>(time),
      'rate': serializer.toJson<int>(rate),
    };
  }

  WithingsRate copyWith({int? id, int? idSession, DateTime? time, int? rate}) =>
      WithingsRate(
        id: id ?? this.id,
        idSession: idSession ?? this.idSession,
        time: time ?? this.time,
        rate: rate ?? this.rate,
      );
  @override
  String toString() {
    return (StringBuffer('WithingsRate(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idSession, time, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithingsRate &&
          other.id == this.id &&
          other.idSession == this.idSession &&
          other.time == this.time &&
          other.rate == this.rate);
}

class WithingsRatesCompanion extends UpdateCompanion<WithingsRate> {
  final Value<int> id;
  final Value<int> idSession;
  final Value<DateTime> time;
  final Value<int> rate;
  const WithingsRatesCompanion({
    this.id = const Value.absent(),
    this.idSession = const Value.absent(),
    this.time = const Value.absent(),
    this.rate = const Value.absent(),
  });
  WithingsRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idSession,
    required DateTime time,
    required int rate,
  })  : idSession = Value(idSession),
        time = Value(time),
        rate = Value(rate);
  static Insertable<WithingsRate> custom({
    Expression<int>? id,
    Expression<int>? idSession,
    Expression<DateTime>? time,
    Expression<int>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idSession != null) 'id_session': idSession,
      if (time != null) 'time': time,
      if (rate != null) 'rate': rate,
    });
  }

  WithingsRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idSession,
      Value<DateTime>? time,
      Value<int>? rate}) {
    return WithingsRatesCompanion(
      id: id ?? this.id,
      idSession: idSession ?? this.idSession,
      time: time ?? this.time,
      rate: rate ?? this.rate,
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
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (rate.present) {
      map['rate'] = Variable<int>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WithingsRatesCompanion(')
          ..write('id: $id, ')
          ..write('idSession: $idSession, ')
          ..write('time: $time, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $WithingsRatesTable extends WithingsRates
    with TableInfo<$WithingsRatesTable, WithingsRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WithingsRatesTable(this.attachedDatabase, [this._alias]);
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES "sessions" ("id") ON DELETE CASCADE');
  final VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
      'time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  final VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<int> rate = GeneratedColumn<int>(
      'rate', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idSession, time, rate];
  @override
  String get aliasedName => _alias ?? 'withings_rates';
  @override
  String get actualTableName => 'withings_rates';
  @override
  VerificationContext validateIntegrity(Insertable<WithingsRate> instance,
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
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WithingsRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WithingsRate(
      id: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      idSession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_session'])!,
      time: attachedDatabase.options.types
          .read(DriftSqlType.dateTime, data['${effectivePrefix}time'])!,
      rate: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}rate'])!,
    );
  }

  @override
  $WithingsRatesTable createAlias(String alias) {
    return $WithingsRatesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $IntervalsTable intervals = $IntervalsTable(this);
  late final $PolarRatesTable polarRates = $PolarRatesTable(this);
  late final $FitbitRatesTable fitbitRates = $FitbitRatesTable(this);
  late final $WithingsRatesTable withingsRates = $WithingsRatesTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final SessionsDao sessionsDao = SessionsDao(this as AppDatabase);
  late final IntervalsDao intervalsDao = IntervalsDao(this as AppDatabase);
  late final PolarRatesDao polarRatesDao = PolarRatesDao(this as AppDatabase);
  late final FitbitRatesDao fitbitRatesDao =
      FitbitRatesDao(this as AppDatabase);
  late final WithingsRatesDao withingsRatesDao =
      WithingsRatesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, dynamic>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, sessions, intervals, polarRates, fitbitRates, withingsRates];
}
