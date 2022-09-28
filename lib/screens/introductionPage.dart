import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/screens/homePage.dart';
import '../bloc/intro_bloc/intro_bloc.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPages(),
      showDoneButton: false,
      showNextButton: false,
      showBackButton: false,
      showSkipButton: false,
      isProgressTap: false,
    );
  }

  List<PageViewModel> listPages() {
    return [
      PageViewModel(
          title: "Benvenuto",
          body: "Questa applicazione consente di ...",
          image: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(child: Image.asset('assets/apple.png'))))),
      PageViewModel(
        title: 'Connetti il tuo account',
        body:
            "Prima di continuare, connetti il tuo account di Withings affinchè l'applicazione possa scaricare i tuoi dati",
        image: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Image.asset('assets/withings.png')))),
        footer: BlocBuilder<IntroBloc, IntroState>(
          builder: ((context, state) {
            if (state is IntroInitial) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                  onPressed: () =>
                      context.read<IntroBloc>().add(LoadIntroEvent()),
                  child: Text('Connetti !'));
            }
            if (state is IntroLoading) {
              return CircularProgressIndicator();
            }
            if (state is IntroLoaded) {
              return Icon(
                MdiIcons.cloudCheck,
                color: Colors.greenAccent,
                size: 40,
              );
            }
            if (state is IntroError) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), backgroundColor: Colors.redAccent),
                onPressed: () =>
                    context.read<IntroBloc>().add(LoadIntroEvent()),
                child: Text('Riprova'),
              );
            } else {
              return Text('Error IntroBloc');
            }
          }),
        ),
      ),
      PageViewModel(
        titleWidget: BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoading ||
                state is IntroError ||
                state is IntroInitial) {
              return Text(
                'Siamo quasi pronti per iniziare',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              );
            }
            if (state is IntroLoaded) {
              return Text(
                'Siamo pronti per iniziare',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              );
            } else {
              return Text('Error IntroBloc');
            }
          },
        ),
        bodyWidget: BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoading ||
                state is IntroError ||
                state is IntroInitial) {
              return Text(
                'Completa i passaggi precedenti, prima di iniziare',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              );
            }
            if (state is IntroLoaded) {
              return Text(
                "Premi sul pulsante sottostante per iniziare a usare l'applicazione",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              );
            } else {
              return Text('Error IntroBloc');
            }
          },
        ),
        image: Center(
          child: Icon(
            MdiIcons.run,
            size: 250,
            color: Colors.black,
          ),
        ),
        footer: BlocBuilder<IntroBloc, IntroState>(
          builder: (context, state) {
            if (state is IntroLoaded) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                child: Text("Iniziamo !"),
                onPressed: () {
                  context.read<IntroBloc>().add(FinishIntroEvent());
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    ];
  }
}
