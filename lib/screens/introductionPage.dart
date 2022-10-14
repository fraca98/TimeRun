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
          title: "Welcome",
          body: "This application allows to ...",
          image: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Container(child: Image.asset('assets/apple.png'))))),
      PageViewModel(
        title: 'Connect your account',
        body:
            "Before continuing, connect your Withings account so the app can download your data",
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
                  child: Text('Connect !'));
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
                child: Text('Retry'),
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
                'We are almost ready to start',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              );
            }
            if (state is IntroLoaded) {
              return Text(
                'We are ready to start',
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
                'Complete the previous steps',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              );
            }
            if (state is IntroLoaded) {
              return Text(
                "Press the button below to start using the application",
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
                child: Text("Let's start !"),
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
