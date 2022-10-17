import 'package:drift/drift.dart';
import 'package:timerun/database/AppDatabase.dart';
part 'polarratesDao.g.dart';

// the _TodosDaoMixin will be created by drift. It contains all the necessary
// fields for the tables. The <MyDatabase> type annotation is the database class
// that should use this dao.
@DriftAccessor(tables: [PolarRates])
class PolarRatesDao extends DatabaseAccessor<AppDatabase>
    with _$PolarRatesDaoMixin {
  // this constructor is required so that the main database can create an instance
  // of this object.
  PolarRatesDao(AppDatabase db) : super(db);

  Future<int> insert(PolarRatesCompanion data) async { //insert data
    return into(polarRates).insert(data);
  }
}
