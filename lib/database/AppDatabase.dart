import 'dart:ffi';

import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:timerun/database/fitbitratesDao.dart';
import 'package:timerun/database/intervalsDao.dart';
import 'package:timerun/database/polarratesDao.dart';
import 'package:timerun/database/sessionDao.dart';
import 'package:timerun/database/userDao.dart';
import 'package:timerun/database/withingsratesDao.dart';
part 'AppDatabase.g.dart';

// To open the database, add these imports to the existing file defining the
// database class. They are used to open the database.

// this will generate a table called "Users"
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get sex => boolean()(); // true : Man, false : Woman
  IntColumn get activity => integer()(); //low = 0, medium = 1, high = 2
  IntColumn get birthDate => integer()();
  IntColumn get completed => integer().withDefault(Constant(0))();
  /*
  0: no session
  1: 1/2 session
  2: 2/2 session
  */
}

// this will generate the table called "Sessions"
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get iduser =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get numsession => integer()();
  IntColumn get startsession => integer()();
  IntColumn get endsession => integer().nullable()();
  TextColumn get device1 => text()();
  TextColumn get device2 => text()();
  BoolColumn get download => boolean().withDefault(Constant(false))();
}

// this will generate the table called "Intervals"
class Intervals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idSession =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();
  IntColumn get runstatus => integer()();
  IntColumn get startstimestamp => integer()();
  IntColumn get endtimestamp => integer()();
  IntColumn get deltatime => integer()();
}

// this will generate the table called "PolarRates" to store HR of Polar during intervals
class PolarRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idInterval => integer().references(Intervals, #id, onDelete: KeyAction.cascade)();
  IntColumn get timestamp => integer()();
  IntColumn get value => integer()();
}

// this will generate the table called "FitbitRates" to store HR of Fitbit during intervals
class FitbitRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idInterval => integer().references(Intervals, #id, onDelete: KeyAction.cascade)();
  IntColumn get timestamp => integer()();
  IntColumn get value => integer()();
}

// this will generate the table called "WithingsRates" to store HR of WithingsRates during intervals
class WithingsRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idInterval => integer().references(Intervals, #id, onDelete: KeyAction.cascade)();
  IntColumn get timestamp => integer()();
  IntColumn get value => integer()();
}

// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(
    tables: [Users, Sessions, Intervals, PolarRates, FitbitRates, WithingsRates],
    daos: [UsersDao, SessionsDao, IntervalsDao, PolarRatesDao, FitbitRatesDao, WithingsRatesDao])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON'); //enable foreign keys
      },
    );
  }

  Future<void> exportInto(File file) async {
    // Make sure the directory of the target file exists
    await file.parent.create(recursive: true);

    // Override an existing backup, sqlite expects the target file to be empty
    if (file.existsSync()) {
      file.deleteSync();
    }

    await customStatement('VACUUM INTO ?', [file.path]);
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
