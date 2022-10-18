// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppDatabase.dart';

// **************************************************************************
// DriftDatabaseGenerator
// **************************************************************************

// ignore_for_file: type=lint
class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final String surname;
  final bool sex;
  final int completed;
  const User(
      {required this.id,
      required this.name,
      required this.surname,
      required this.sex,
      required this.completed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['surname'] = Variable<String>(surname);
    map['sex'] = Variable<bool>(sex);
    map['completed'] = Variable<int>(completed);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      surname: Value(surname),
      sex: Value(sex),
      completed: Value(completed),
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
      completed: serializer.fromJson<int>(json['completed']),
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
      'completed': serializer.toJson<int>(completed),
    };
  }

  User copyWith(
          {int? id,
          String? name,
          String? surname,
          bool? sex,
          int? completed}) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        surname: surname ?? this.surname,
        sex: sex ?? this.sex,
        completed: completed ?? this.completed,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('surname: $surname, ')
          ..write('sex: $sex, ')
          ..write('completed: $completed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, surname, sex, completed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.surname == this.surname &&
          other.sex == this.sex &&
          other.completed == this.completed);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> surname;
  final Value<bool> sex;
  final Value<int> completed;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.surname = const Value.absent(),
    this.sex = const Value.absent(),
    this.completed = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String surname,
    required bool sex,
    this.completed = const Value.absent(),
  })  : name = Value(name),
        surname = Value(surname),
        sex = Value(sex);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? surname,
    Expression<bool>? sex,
    Expression<int>? completed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (surname != null) 'surname': surname,
      if (sex != null) 'sex': sex,
      if (completed != null) 'completed': completed,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? surname,
      Value<bool>? sex,
      Value<int>? completed}) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      sex: sex ?? this.sex,
      completed: completed ?? this.completed,
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
    if (completed.present) {
      map['completed'] = Variable<int>(completed.value);
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
  final VerificationMeta _completedMeta = const VerificationMeta('completed');
  @override
  late final GeneratedColumn<int> completed = GeneratedColumn<int>(
      'completed', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, surname, sex, completed];
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
      name: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      surname: attachedDatabase.options.types
          .read(DriftSqlType.string, data['${effectivePrefix}surname'])!,
      sex: attachedDatabase.options.types
          .read(DriftSqlType.bool, data['${effectivePrefix}sex'])!,
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
  final int startsession;
  final int? endsession;
  final String device1;
  final String device2;
  final bool download;
  const Session(
      {required this.id,
      required this.iduser,
      required this.numsession,
      required this.startsession,
      this.endsession,
      required this.device1,
      required this.device2,
      required this.download});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['iduser'] = Variable<int>(iduser);
    map['numsession'] = Variable<int>(numsession);
    map['startsession'] = Variable<int>(startsession);
    if (!nullToAbsent || endsession != null) {
      map['endsession'] = Variable<int>(endsession);
    }
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
      startsession: Value(startsession),
      endsession: endsession == null && nullToAbsent
          ? const Value.absent()
          : Value(endsession),
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
      startsession: serializer.fromJson<int>(json['startsession']),
      endsession: serializer.fromJson<int?>(json['endsession']),
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
      'startsession': serializer.toJson<int>(startsession),
      'endsession': serializer.toJson<int?>(endsession),
      'device1': serializer.toJson<String>(device1),
      'device2': serializer.toJson<String>(device2),
      'download': serializer.toJson<bool>(download),
    };
  }

  Session copyWith(
          {int? id,
          int? iduser,
          int? numsession,
          int? startsession,
          Value<int?> endsession = const Value.absent(),
          String? device1,
          String? device2,
          bool? download}) =>
      Session(
        id: id ?? this.id,
        iduser: iduser ?? this.iduser,
        numsession: numsession ?? this.numsession,
        startsession: startsession ?? this.startsession,
        endsession: endsession.present ? endsession.value : this.endsession,
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
          ..write('startsession: $startsession, ')
          ..write('endsession: $endsession, ')
          ..write('device1: $device1, ')
          ..write('device2: $device2, ')
          ..write('download: $download')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, iduser, numsession, startsession,
      endsession, device1, device2, download);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.iduser == this.iduser &&
          other.numsession == this.numsession &&
          other.startsession == this.startsession &&
          other.endsession == this.endsession &&
          other.device1 == this.device1 &&
          other.device2 == this.device2 &&
          other.download == this.download);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> iduser;
  final Value<int> numsession;
  final Value<int> startsession;
  final Value<int?> endsession;
  final Value<String> device1;
  final Value<String> device2;
  final Value<bool> download;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.iduser = const Value.absent(),
    this.numsession = const Value.absent(),
    this.startsession = const Value.absent(),
    this.endsession = const Value.absent(),
    this.device1 = const Value.absent(),
    this.device2 = const Value.absent(),
    this.download = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int iduser,
    required int numsession,
    required int startsession,
    this.endsession = const Value.absent(),
    required String device1,
    required String device2,
    this.download = const Value.absent(),
  })  : iduser = Value(iduser),
        numsession = Value(numsession),
        startsession = Value(startsession),
        device1 = Value(device1),
        device2 = Value(device2);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? iduser,
    Expression<int>? numsession,
    Expression<int>? startsession,
    Expression<int>? endsession,
    Expression<String>? device1,
    Expression<String>? device2,
    Expression<bool>? download,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (iduser != null) 'iduser': iduser,
      if (numsession != null) 'numsession': numsession,
      if (startsession != null) 'startsession': startsession,
      if (endsession != null) 'endsession': endsession,
      if (device1 != null) 'device1': device1,
      if (device2 != null) 'device2': device2,
      if (download != null) 'download': download,
    });
  }

  SessionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? iduser,
      Value<int>? numsession,
      Value<int>? startsession,
      Value<int?>? endsession,
      Value<String>? device1,
      Value<String>? device2,
      Value<bool>? download}) {
    return SessionsCompanion(
      id: id ?? this.id,
      iduser: iduser ?? this.iduser,
      numsession: numsession ?? this.numsession,
      startsession: startsession ?? this.startsession,
      endsession: endsession ?? this.endsession,
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
          ..write('startsession: $startsession, ')
          ..write('endsession: $endsession, ')
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
      defaultConstraints: 'REFERENCES users (id) ON DELETE CASCADE');
  final VerificationMeta _numsessionMeta = const VerificationMeta('numsession');
  @override
  late final GeneratedColumn<int> numsession = GeneratedColumn<int>(
      'numsession', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _startsessionMeta =
      const VerificationMeta('startsession');
  @override
  late final GeneratedColumn<int> startsession = GeneratedColumn<int>(
      'startsession', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _endsessionMeta = const VerificationMeta('endsession');
  @override
  late final GeneratedColumn<int> endsession = GeneratedColumn<int>(
      'endsession', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
      defaultConstraints: 'CHECK (download IN (0, 1))',
      defaultValue: Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        iduser,
        numsession,
        startsession,
        endsession,
        device1,
        device2,
        download
      ];
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
    if (data.containsKey('startsession')) {
      context.handle(
          _startsessionMeta,
          startsession.isAcceptableOrUnknown(
              data['startsession']!, _startsessionMeta));
    } else if (isInserting) {
      context.missing(_startsessionMeta);
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
      startsession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}startsession'])!,
      endsession: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}endsession']),
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
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES sessions (id) ON DELETE CASCADE');
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

class PolarRate extends DataClass implements Insertable<PolarRate> {
  final int id;
  final int idInterval;
  final int timestamp;
  final int value;
  const PolarRate(
      {required this.id,
      required this.idInterval,
      required this.timestamp,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_interval'] = Variable<int>(idInterval);
    map['timestamp'] = Variable<int>(timestamp);
    map['value'] = Variable<int>(value);
    return map;
  }

  PolarRatesCompanion toCompanion(bool nullToAbsent) {
    return PolarRatesCompanion(
      id: Value(id),
      idInterval: Value(idInterval),
      timestamp: Value(timestamp),
      value: Value(value),
    );
  }

  factory PolarRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PolarRate(
      id: serializer.fromJson<int>(json['id']),
      idInterval: serializer.fromJson<int>(json['idInterval']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idInterval': serializer.toJson<int>(idInterval),
      'timestamp': serializer.toJson<int>(timestamp),
      'value': serializer.toJson<int>(value),
    };
  }

  PolarRate copyWith({int? id, int? idInterval, int? timestamp, int? value}) =>
      PolarRate(
        id: id ?? this.id,
        idInterval: idInterval ?? this.idInterval,
        timestamp: timestamp ?? this.timestamp,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('PolarRate(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idInterval, timestamp, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PolarRate &&
          other.id == this.id &&
          other.idInterval == this.idInterval &&
          other.timestamp == this.timestamp &&
          other.value == this.value);
}

class PolarRatesCompanion extends UpdateCompanion<PolarRate> {
  final Value<int> id;
  final Value<int> idInterval;
  final Value<int> timestamp;
  final Value<int> value;
  const PolarRatesCompanion({
    this.id = const Value.absent(),
    this.idInterval = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.value = const Value.absent(),
  });
  PolarRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idInterval,
    required int timestamp,
    required int value,
  })  : idInterval = Value(idInterval),
        timestamp = Value(timestamp),
        value = Value(value);
  static Insertable<PolarRate> custom({
    Expression<int>? id,
    Expression<int>? idInterval,
    Expression<int>? timestamp,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idInterval != null) 'id_interval': idInterval,
      if (timestamp != null) 'timestamp': timestamp,
      if (value != null) 'value': value,
    });
  }

  PolarRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idInterval,
      Value<int>? timestamp,
      Value<int>? value}) {
    return PolarRatesCompanion(
      id: id ?? this.id,
      idInterval: idInterval ?? this.idInterval,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idInterval.present) {
      map['id_interval'] = Variable<int>(idInterval.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PolarRatesCompanion(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
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
  final VerificationMeta _idIntervalMeta = const VerificationMeta('idInterval');
  @override
  late final GeneratedColumn<int> idInterval = GeneratedColumn<int>(
      'id_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES intervals (id) ON DELETE CASCADE');
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idInterval, timestamp, value];
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
    if (data.containsKey('id_interval')) {
      context.handle(
          _idIntervalMeta,
          idInterval.isAcceptableOrUnknown(
              data['id_interval']!, _idIntervalMeta));
    } else if (isInserting) {
      context.missing(_idIntervalMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
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
      idInterval: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_interval'])!,
      timestamp: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      value: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $PolarRatesTable createAlias(String alias) {
    return $PolarRatesTable(attachedDatabase, alias);
  }
}

class FitbitRate extends DataClass implements Insertable<FitbitRate> {
  final int id;
  final int idInterval;
  final int timestamp;
  final int value;
  const FitbitRate(
      {required this.id,
      required this.idInterval,
      required this.timestamp,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_interval'] = Variable<int>(idInterval);
    map['timestamp'] = Variable<int>(timestamp);
    map['value'] = Variable<int>(value);
    return map;
  }

  FitbitRatesCompanion toCompanion(bool nullToAbsent) {
    return FitbitRatesCompanion(
      id: Value(id),
      idInterval: Value(idInterval),
      timestamp: Value(timestamp),
      value: Value(value),
    );
  }

  factory FitbitRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FitbitRate(
      id: serializer.fromJson<int>(json['id']),
      idInterval: serializer.fromJson<int>(json['idInterval']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idInterval': serializer.toJson<int>(idInterval),
      'timestamp': serializer.toJson<int>(timestamp),
      'value': serializer.toJson<int>(value),
    };
  }

  FitbitRate copyWith({int? id, int? idInterval, int? timestamp, int? value}) =>
      FitbitRate(
        id: id ?? this.id,
        idInterval: idInterval ?? this.idInterval,
        timestamp: timestamp ?? this.timestamp,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('FitbitRate(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idInterval, timestamp, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FitbitRate &&
          other.id == this.id &&
          other.idInterval == this.idInterval &&
          other.timestamp == this.timestamp &&
          other.value == this.value);
}

class FitbitRatesCompanion extends UpdateCompanion<FitbitRate> {
  final Value<int> id;
  final Value<int> idInterval;
  final Value<int> timestamp;
  final Value<int> value;
  const FitbitRatesCompanion({
    this.id = const Value.absent(),
    this.idInterval = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.value = const Value.absent(),
  });
  FitbitRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idInterval,
    required int timestamp,
    required int value,
  })  : idInterval = Value(idInterval),
        timestamp = Value(timestamp),
        value = Value(value);
  static Insertable<FitbitRate> custom({
    Expression<int>? id,
    Expression<int>? idInterval,
    Expression<int>? timestamp,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idInterval != null) 'id_interval': idInterval,
      if (timestamp != null) 'timestamp': timestamp,
      if (value != null) 'value': value,
    });
  }

  FitbitRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idInterval,
      Value<int>? timestamp,
      Value<int>? value}) {
    return FitbitRatesCompanion(
      id: id ?? this.id,
      idInterval: idInterval ?? this.idInterval,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idInterval.present) {
      map['id_interval'] = Variable<int>(idInterval.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FitbitRatesCompanion(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
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
  final VerificationMeta _idIntervalMeta = const VerificationMeta('idInterval');
  @override
  late final GeneratedColumn<int> idInterval = GeneratedColumn<int>(
      'id_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES intervals (id) ON DELETE CASCADE');
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idInterval, timestamp, value];
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
    if (data.containsKey('id_interval')) {
      context.handle(
          _idIntervalMeta,
          idInterval.isAcceptableOrUnknown(
              data['id_interval']!, _idIntervalMeta));
    } else if (isInserting) {
      context.missing(_idIntervalMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
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
      idInterval: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_interval'])!,
      timestamp: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      value: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $FitbitRatesTable createAlias(String alias) {
    return $FitbitRatesTable(attachedDatabase, alias);
  }
}

class WithingsRate extends DataClass implements Insertable<WithingsRate> {
  final int id;
  final int idInterval;
  final int timestamp;
  final int value;
  const WithingsRate(
      {required this.id,
      required this.idInterval,
      required this.timestamp,
      required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['id_interval'] = Variable<int>(idInterval);
    map['timestamp'] = Variable<int>(timestamp);
    map['value'] = Variable<int>(value);
    return map;
  }

  WithingsRatesCompanion toCompanion(bool nullToAbsent) {
    return WithingsRatesCompanion(
      id: Value(id),
      idInterval: Value(idInterval),
      timestamp: Value(timestamp),
      value: Value(value),
    );
  }

  factory WithingsRate.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WithingsRate(
      id: serializer.fromJson<int>(json['id']),
      idInterval: serializer.fromJson<int>(json['idInterval']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      value: serializer.fromJson<int>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'idInterval': serializer.toJson<int>(idInterval),
      'timestamp': serializer.toJson<int>(timestamp),
      'value': serializer.toJson<int>(value),
    };
  }

  WithingsRate copyWith(
          {int? id, int? idInterval, int? timestamp, int? value}) =>
      WithingsRate(
        id: id ?? this.id,
        idInterval: idInterval ?? this.idInterval,
        timestamp: timestamp ?? this.timestamp,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('WithingsRate(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, idInterval, timestamp, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WithingsRate &&
          other.id == this.id &&
          other.idInterval == this.idInterval &&
          other.timestamp == this.timestamp &&
          other.value == this.value);
}

class WithingsRatesCompanion extends UpdateCompanion<WithingsRate> {
  final Value<int> id;
  final Value<int> idInterval;
  final Value<int> timestamp;
  final Value<int> value;
  const WithingsRatesCompanion({
    this.id = const Value.absent(),
    this.idInterval = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.value = const Value.absent(),
  });
  WithingsRatesCompanion.insert({
    this.id = const Value.absent(),
    required int idInterval,
    required int timestamp,
    required int value,
  })  : idInterval = Value(idInterval),
        timestamp = Value(timestamp),
        value = Value(value);
  static Insertable<WithingsRate> custom({
    Expression<int>? id,
    Expression<int>? idInterval,
    Expression<int>? timestamp,
    Expression<int>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (idInterval != null) 'id_interval': idInterval,
      if (timestamp != null) 'timestamp': timestamp,
      if (value != null) 'value': value,
    });
  }

  WithingsRatesCompanion copyWith(
      {Value<int>? id,
      Value<int>? idInterval,
      Value<int>? timestamp,
      Value<int>? value}) {
    return WithingsRatesCompanion(
      id: id ?? this.id,
      idInterval: idInterval ?? this.idInterval,
      timestamp: timestamp ?? this.timestamp,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (idInterval.present) {
      map['id_interval'] = Variable<int>(idInterval.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WithingsRatesCompanion(')
          ..write('id: $id, ')
          ..write('idInterval: $idInterval, ')
          ..write('timestamp: $timestamp, ')
          ..write('value: $value')
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
  final VerificationMeta _idIntervalMeta = const VerificationMeta('idInterval');
  @override
  late final GeneratedColumn<int> idInterval = GeneratedColumn<int>(
      'id_interval', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES intervals (id) ON DELETE CASCADE');
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, idInterval, timestamp, value];
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
    if (data.containsKey('id_interval')) {
      context.handle(
          _idIntervalMeta,
          idInterval.isAcceptableOrUnknown(
              data['id_interval']!, _idIntervalMeta));
    } else if (isInserting) {
      context.missing(_idIntervalMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
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
      idInterval: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}id_interval'])!,
      timestamp: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      value: attachedDatabase.options.types
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
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
