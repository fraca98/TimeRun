import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'fitbitratesDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [FitbitRates])
class FitbitRatesDao extends DatabaseAccessor<AppDatabase>
    with _$FitbitRatesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  FitbitRatesDao(AppDatabase db) : super(db);

  Future<int> insert(FitbitRatesCompanion data) async {
    //insert data
    return into(fitbitRates).insert(data);
  }

  Future<List<FitbitRate>> fitbitBySession(int idSession) {
    return (select(fitbitRates)
          ..where((tbl) => tbl.idSession.equals(idSession)))
        .get();
  }

  Future<void> insertMultipleEntries(List<FitbitRatesCompanion> entries) async {
    //insert multiple entries with a batch
    await batch((batch) {
      batch.insertAll(fitbitRates, entries);
    });
  }
}
