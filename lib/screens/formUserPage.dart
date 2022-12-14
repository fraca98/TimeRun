import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/userform_bloc/userform_bloc.dart';

class FormUserPage extends StatelessWidget {
  const FormUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertBack(context);
            });
        return false;
      },
      child: BlocProvider(
        create: (context) => RegFormBloc(),
        child: Builder(builder: (context) {
          final formBloc = context.read<RegFormBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'User Form',
              ),
              centerTitle: true,
            ),
            body: FormBlocListener<RegFormBloc, dynamic, dynamic>(
              onSubmissionFailed: (context, state) =>
                  LoadingDialog.hide(context),
              onSubmitting: (context, state) => LoadingDialog.show(context),
              onSuccess: (context, state) async {
                LoadingDialog.hide(context);
                if (state.stepCompleted == state.lastStep) {
                  Navigator.pop(context);
                }
              },
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      RadioButtonGroupFieldBlocBuilder<String>(
                        selectFieldBloc: formBloc.sex,
                        itemBuilder: (context, value) => FieldItem(
                          child: Text(value),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Sex',
                          prefixIcon: SizedBox(),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      YearPickerFieldBlocBuilder(
                        yearPickerFieldBloc: formBloc.birthDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().subtract(
                            Duration(days: 18 * 365)), //at least 18 years
                        decoration: const InputDecoration(
                          labelText: 'Year of birth',
                          prefixIcon: Icon(Icons.cake),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: formBloc.submit,
              child: const Icon(Icons.send),
            ),
          );
        }),
      ),
    );
  }

  // set up the AlertDialog when go back
  Widget alertBack(BuildContext context) {
    return AlertDialog(
      icon: Icon(MdiIcons.alert),
      title: Text("Warning"),
      content: Text(
        "Are you sure? Data are not saved",
      ),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Go back'))
      ],
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
