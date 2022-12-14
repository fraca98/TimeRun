import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'sessionDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  SessionsDao(AppDatabase db) : super(db);

  Future<List<Session>> get allEntries =>
      select(sessions).get(); //get all the sessions

  Future<int> insertNewSession(SessionsCompanion session) {
    //insert a new session and return the id (use SessionsCompanion cause id is autoincremental)
    return into(sessions).insert(session);
  }

  Future updateDown(int idSession, bool value) => //update download of session
      (update(sessions)..where((t) => t.id.equals(idSession)))
          .write(SessionsCompanion(download: Value(value)));

  Stream<List<Session>> watchSessionUser(int idUser) {
    //watches changes of list of Sessions given idUser
    return (select(sessions)..where((tbl) => tbl.idUser.equals(idUser)))
        .watch();
  }

  Stream<Session> watchSession(int idSession) {
    //watch changes in a single Session given idSession
    return (select(sessions)..where((tbl) => tbl.id.equals(idSession)))
        .watchSingle();
  }
}
