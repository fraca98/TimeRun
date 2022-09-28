import 'package:flutter/material.dart';
import 'package:timerun/screens/homePage.dart';
import 'package:date_time_picker/date_time_picker.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  int currentStep = 0;
  int selectedvalue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form di registrazione'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => showDialog(
            context: context,
            builder: (context) => _alertDialogue(),
          ),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          setState(() {
            final isLastStep = currentStep == getSteps().length - 1;
            if (isLastStep) {
              print('add user');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
            } else {
              currentStep++;
            }
          });
        },
        onStepCancel: () {
          setState(() {
            currentStep == 0 ? null : currentStep--;
          });
        },
        onStepTapped: (step) => setState(() {
          currentStep = step;
        }),
        controlsBuilder: (context, details) {
          final isLastStep = currentStep == getSteps().length - 1;
          return Container(
            margin: EdgeInsets.only(top: 50),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(
                    isLastStep ? "Aggiungi l'utente" : 'Continua',
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                )),
                SizedBox(
                  width: 20,
                ),
                if (currentStep != 0)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text('Indietro'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Step> getSteps() {
    return [
      step1(),
      step2(),
      step3(),
    ];
  }

  Widget _alertDialogue() {
    //quando cancello la procedura tornando indietro
    return AlertDialog(
      title: Text('Attenzione'),
      content: Text(
          'Sei sicuro di tornare indietro e perdere tutte le informazioni inserite ?'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('Vai indietro')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annulla'))
          ],
        )
      ],
    );
  }

  Step step1() {
    return Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: Text('Account'),
      content: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Nome'),
            validator: ((value) {
              if (value!.isEmpty) {
                return 'Inserisci il tuo nome';
              }
            }),
          ),
          TextFormField(
              decoration: InputDecoration(labelText: 'Cognome'),
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Inserisci il tuo Cognome';
                }
              })),
          SizedBox(
            height: 50,
          ),
          RadioListTile(
            value: 1,
            title: Text('Uomo'),
            groupValue: selectedvalue,
            onChanged: ((value) => setState(() {
                  selectedvalue = 1;
                })),
          ),
          RadioListTile(
              value: 2,
              title: Text('Donna'),
              groupValue: selectedvalue,
              onChanged: (value) {
                setState(() {
                  selectedvalue = 2;
                });
              })
        ],
      ),
    );
  }

  Step step2() {
    return Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: Text('Altre'),
      content: DateTimePicker(
        type: DateTimePickerType.date,
        initialValue: '',
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        dateLabelText: 'Data di nascita',
        onChanged: (val) => print(val),
        validator: (val) {},
        onSaved: (val) => print(val),
      ),
    );
  }

  Step step3() {
    return Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: Text('Sommario'),
      content: Container(),
    );
  }
}
