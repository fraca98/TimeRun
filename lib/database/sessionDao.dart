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

  Future<int> inserNewSession(SessionsCompanion session) {
    //insert a new session and return the id (use SessionsCompanion cause id is autoincremental)
    return into(sessions).insert(session);
  }

  Future<
      Session> retrieveSpecificSession(int idUser, int numsession) => (select(
          sessions)
        ..where(
            (t) => t.iduser.equals(idUser) & t.numsession.equals(numsession)))
      .getSingle(); // return Single specific session given idUser and the number (1/2) of the session

  Future updateSession(int idSession, int endsession) =>
      (update(sessions)..where((tbl) => tbl.id.equals(idSession)))
          .write(SessionsCompanion(endsession: Value(endsession)));

  Future<int> deleteSession(int id) {
    //delete session given the id of the session
    return (delete(sessions)..where((t) => t.id.equals(id))).go();
  }
}