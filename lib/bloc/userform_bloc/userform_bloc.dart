import 'package:drift/drift.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

class RegFormBloc extends FormBloc<dynamic, dynamic> {
  final AppDatabase db = GetIt.I<AppDatabase>();

  //field blocs
  final sex = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['Man', 'Woman'],
  );
  final birthDate = InputFieldBloc<DateTime?, Object>(
    validators: [
      FieldBlocValidators.required,
    ],
    initialValue: null,
  );

  RegFormBloc() {
    addFieldBlocs(
      fieldBlocs: [sex, birthDate],
    );
  }

  @override
  void onSubmitting() async {
    print(sex.value);
    await db.usersDao.insertNewUser(
      UsersCompanion(
          sex: Value(sex.value == 'Man' ? 1 : 0),
          birthYear: Value(birthDate.value!.year)),
    );
    emitSuccess();
  }
}
