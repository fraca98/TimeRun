import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'intervalsDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [Intervals])
class IntervalsDao extends DatabaseAccessor<AppDatabase>
    with _$IntervalsDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  IntervalsDao(AppDatabase db) : super(db);

  Future<int> inserNewInterval(IntervalsCompanion interval) {
    //insert a new interval and return the id (use IntervalsCompanion cause id is autoincremental)
    return into(intervals).insert(interval);
  }

  Future<List<Interval>> getIntervalBySession(int idSession) {
    //get intervals list by idSession
    return (select(intervals)..where((tbl) => tbl.idSession.equals(idSession)))
        .get();
  }
}
