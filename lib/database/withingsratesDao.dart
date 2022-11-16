import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'withingsratesDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [WithingsRates])
class WithingsRatesDao extends DatabaseAccessor<AppDatabase>
    with _$WithingsRatesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  WithingsRatesDao(AppDatabase db) : super(db);

  Future<int> insert(WithingsRatesCompanion data) async {
    //insert data
    return into(withingsRates).insert(data);
  }

  Future<List<WithingsRate>> withingsBySession(int idSession) {
    return (select(withingsRates)
          ..where((tbl) => tbl.idSession.equals(idSession)))
        .get();
  }
}
