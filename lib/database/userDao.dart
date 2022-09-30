import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'userDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  UsersDao(AppDatabase db) : super(db);

  Future<List<User>> get allEntries => select(users).get(); //get all the Users

  Future<int> insertNewUser(UsersCompanion user) {
    //insert a new user and return the id (use UsersCompanion cause id is autoincremental)
    return into(users).insert(user);
  }

  Future<int> deleteUser(int id) {
    return (delete(users)..where((t) => t.id.equals(id))).go();
  }

  Future<User> retrieveSpecificUser(int id) =>
      (select(users)..where((t) => t.id.equals(id)))
          .getSingle(); // return user given id (primary key)

  Future updateComplete(int iduser, int newcomplete) =>
      (update(users)..where((tbl) => tbl.id.equals(iduser))).write(
          UsersCompanion(
              completed: Value(newcomplete))); //update completed user value

}
