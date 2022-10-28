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
  final activity = SelectFieldBloc(
    validators: [FieldBlocValidators.required],
    items: ['Low', 'Medium', 'High'],
  );

  RegFormBloc() {
    addFieldBlocs(
      fieldBlocs: [sex, birthDate, activity],
    );
  }

  @override
  void onSubmitting() async {
    late int act;
    switch (activity.value) {
      case 'Low':
        act = 0;
        break;
      case 'Medium':
        act = 1;
        break;
      case 'High':
        act = 2;
        break;
      default:
    }
    await db.usersDao.insertNewUser(
      UsersCompanion(
          sex: Value(sex.value == "Man"),
          activity: Value(act),
          birthDate: Value(birthDate.value!.year)),
    );
    emitSuccess();
  }
}
