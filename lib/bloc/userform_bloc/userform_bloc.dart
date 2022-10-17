import 'package:drift/drift.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:timerun/database/AppDatabase.dart';

class WizardFormBloc extends FormBloc<dynamic, dynamic> {
  final AppDatabase db = GetIt.I<AppDatabase>();

  final username = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  //field blocs
  final name = TextFieldBloc(validators: [
    FieldBlocValidators.required,
  ]);
  final surname = TextFieldBloc(validators: [FieldBlocValidators.required]);

  final height = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final weight = TextFieldBloc(validators: [FieldBlocValidators.required]);
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

  WizardFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [name, surname, sex, birthDate],
    );
    addFieldBlocs(
      step: 1,
      fieldBlocs: [height, weight],
    );
  }

  @override
  void onSubmitting() async {
    if (state.currentStep == 0) {
      emitSuccess();
    } else if (state.currentStep == 1) {
      await db.usersDao.insertNewUser(UsersCompanion(
        name: Value(name.value),
        surname: Value(surname.value),
        sex: Value(sex.value == "Man"),
      ));
      emitSuccess();
    }
  }
}
