import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/userform_bloc/userform_bloc.dart';
import 'package:timerun/screens/homePage.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Form utente',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          centerTitle: true,
        ),
        body: BlocProvider(
          create: (context) => WizardFormBloc(),
          child: FormBlocListener<WizardFormBloc, dynamic, dynamic>(
            onSubmissionFailed: (context, state) => LoadingDialog.hide(context),
            onSubmitting: (context, state) => LoadingDialog.show(context),
            onSuccess: (context, state) async {
              LoadingDialog.hide(context);
              if (state.stepCompleted == state.lastStep) {
                Navigator.pop(context, true); //pass true to pop cause i want to reload
              }
            },
            child: StepperFormBlocBuilder<WizardFormBloc>(
                physics: ClampingScrollPhysics(),
                type: StepperType.vertical,
                stepsBuilder: ((formBloc) {
                  return [_anagraficaStep(formBloc!), _bioStep(formBloc)];
                })),
          ),
        ),
      ),
    );
  }

  FormBlocStep _anagraficaStep(WizardFormBloc formBloc) {
    return FormBlocStep(
      title: const Text('Anagrafica'),
      content: Column(
        children: <Widget>[
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.name,
            keyboardType: TextInputType.name,
            enableOnlyWhenFormBlocCanSubmit: true,
            decoration: const InputDecoration(
              labelText: 'Nome',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          TextFieldBlocBuilder(
            textFieldBloc: formBloc.surname,
            keyboardType: TextInputType.name,
            enableOnlyWhenFormBlocCanSubmit: true,
            decoration: const InputDecoration(
              labelText: 'Cognome',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          RadioButtonGroupFieldBlocBuilder<String>(
            selectFieldBloc: formBloc.sex,
            itemBuilder: (context, value) => FieldItem(
              child: Text(value),
            ),
            decoration: const InputDecoration(
              labelText: 'Genere',
              prefixIcon: SizedBox(),
            ),
          ),
          DateTimeFieldBlocBuilder(
            dateTimeFieldBloc: formBloc.birthDate,
            firstDate: DateTime(1900),
            initialDate: DateTime.now(),
            lastDate: DateTime.now(),
            format: DateFormat('yyyy-MM-dd'),
            decoration: const InputDecoration(
              labelText: 'Data di nascita',
              prefixIcon: Icon(Icons.cake),
            ),
          ),
        ],
      ),
    );
  }

  FormBlocStep _bioStep(WizardFormBloc formBloc) {
    return FormBlocStep(
        title: Text('Bio'),
        content: Column(
          children: <Widget>[
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.height,
              keyboardType: TextInputType.number,
              enableOnlyWhenFormBlocCanSubmit: true,
              decoration: const InputDecoration(
                  labelText: 'Altezza',
                  prefixIcon: Icon(Icons.height),
                  suffix: Text('cm')),
            ),
            TextFieldBlocBuilder(
              textFieldBloc: formBloc.weight,
              keyboardType: TextInputType.number,
              enableOnlyWhenFormBlocCanSubmit: true,
              decoration: const InputDecoration(
                labelText: 'Peso',
                prefixIcon: Icon(MdiIcons.weight),
                suffix: Text('Kg'),
              ),
            ),
          ],
        ));
  }

  // set up the AlertDialog when go back
  Widget alertBack(BuildContext context) {
    return AlertDialog(
      icon: Icon(MdiIcons.alert),
      title: Text("Attenzione", style: TextStyle(fontFamily: 'Poppins')),
      content: Text(
          "Sei sicuro di voler tornare indietro ? Tutti i dati verranno persi",
          style: TextStyle(fontFamily: 'Poppins')),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annulla', style: TextStyle(fontFamily: 'Poppins')),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Elimina', style: TextStyle(fontFamily: 'Poppins')))
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
        child: Card(
          child: Container(
            width: 120,
            height: 120,
            padding: const EdgeInsets.all(12.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
