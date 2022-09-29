import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:timerun/database/intervalsDao.dart';
import 'package:timerun/database/sessionDao.dart';
import 'package:timerun/database/userDao.dart';
part 'AppDatabase.g.dart';

// To open the database, add these imports to the existing file defining the
// database class. They are used to open the database.

// this will generate a table called "Users"
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get surname => text()();
  BoolColumn get sex => boolean()();
  IntColumn get session1 => integer().nullable().references(Sessions, #id)();
  IntColumn get session2 => integer().nullable().references(Sessions, #id)();
}

// this will generate the table called "Sessions"
class Sessions extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get startsession => integer().nullable()();
  IntColumn get endsession => integer().nullable()();
  TextColumn get device1 => text().nullable()();
  TextColumn get device2 => text().nullable()();
}

class Intervals extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idSession => integer()();
  TextColumn get status => text()();
  IntColumn get startstimestamp => integer()();
  IntColumn get endtimestamp => integer()();
  IntColumn get deltatime => integer()();
}


// this annotation tells drift to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@DriftDatabase(tables: [Users, Sessions, Intervals], daos: [UsersDao, SessionsDao, IntervalsDao])
class AppDatabase extends _$AppDatabase {
  // we tell the database where to store the data with this constructor
  AppDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;
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
