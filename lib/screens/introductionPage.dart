import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/introfitbit_bloc/introfitbit_bloc.dart';
import '../bloc/introwithings_bloc/introwithings_bloc.dart';
import 'homePage.dart';

class IntroductionPage extends StatelessWidget {
  SharedPreferences? prefs;

  IntroductionPage({required this.prefs, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IntroFitbitBloc>(
          create: (BuildContext context) => IntroFitbitBloc(prefs),
        ),
        BlocProvider<IntroWithingsBloc>(
          create: (BuildContext context) => IntroWithingsBloc(prefs),
        ),
      ],
      child: IntroductionScreen(
        pages: listPages(context),
        showDoneButton: false,
        showNextButton: false,
        showBackButton: false,
        showSkipButton: false,
        isProgressTap: false,
      ),
    );
  }

  List<PageViewModel> listPages(context) {
    return [
      PageViewModel(
          title: "Welcome",
          body: "This application allows to ...",
          image: Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child:
                      Container(width: MediaQuery.of(context).size.width*0.7, child: Image.asset('assets/timerunlogo.png'))))),
      // Fitbit Page
      PageViewModel(
        title: 'Connect your Fitbit account',
        body:
            "Before continuing, connect your Fitbit account so the app can download your data",
        image: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Image.asset('assets/fitbit.png')))),
        footer: BlocBuilder<IntroFitbitBloc, IntroFitbitState>(
          builder: ((context, state) {
            if (state is IntroFitbitInitial) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                  onPressed: () => context
                      .read<IntroFitbitBloc>()
                      .add(LoadIntroFitbitEvent()),
                  child: Text('Connect !'));
            }
            if (state is IntroFitbitLoading) {
              return CircularProgressIndicator();
            }
            if (state is IntroFitbitLoaded) {
              return Icon(
                MdiIcons.cloudCheck,
                color: Colors.greenAccent,
                size: 40,
              );
            }
            if (state is IntroFitbitError) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), backgroundColor: Colors.redAccent),
                onPressed: () =>
                    context.read<IntroFitbitBloc>().add(LoadIntroFitbitEvent()),
                child: Text('Retry'),
              );
            } else {
              return Text('Error IntroFitbitBloc');
            }
          }),
        ),
      ),
      // Withings Page
      PageViewModel(
        title: 'Connect your Withings account',
        body:
            "Before continuing, connect your Withings account so the app can download your data",
        image: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Image.asset('assets/withings.png')))),
        footer: BlocBuilder<IntroWithingsBloc, IntroWithingsState>(
          builder: ((context, state) {
            if (state is IntroWithingsInitial) {
              return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                  ),
                  onPressed: () => context
                      .read<IntroWithingsBloc>()
                      .add(LoadIntroWithingsEvent()),
                  child: Text('Connect !'));
            }
            if (state is IntroWithingsLoading) {
              return CircularProgressIndicator();
            }
            if (state is IntroWithingsLoaded) {
              return Icon(
                MdiIcons.cloudCheck,
                color: Colors.greenAccent,
                size: 40,
              );
            }
            if (state is IntroWithingsError) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(), backgroundColor: Colors.redAccent),
                onPressed: () => context
                    .read<IntroWithingsBloc>()
                    .add(LoadIntroWithingsEvent()),
                child: Text('Retry'),
              );
            } else {
              return Text('Error IntroWithingsBloc');
            }
          }),
        ),
      ),
      //
      PageViewModel(
        titleWidget: BlocBuilder<IntroFitbitBloc, IntroFitbitState>(
          builder: (context, fitbitstate) {
            return BlocBuilder<IntroWithingsBloc, IntroWithingsState>(
                builder: (context, withingsstate) {
              if (fitbitstate is IntroFitbitLoaded &&
                  withingsstate is IntroWithingsLoaded) {
                return Text(
                  "We are ready to start",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              } else {
                return Text(
                  "We are almost ready to start",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                );
              }
            });
          },
        ),
        bodyWidget: BlocBuilder<IntroFitbitBloc, IntroFitbitState>(
          builder: (context, fitbitstate) {
            return BlocBuilder<IntroWithingsBloc, IntroWithingsState>(
                builder: (context, withingsstate) {
              if (fitbitstate is IntroFitbitLoaded &&
                  withingsstate is IntroWithingsLoaded) {
                return Text(
                  "Press the button below to start using the application",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                );
              } else {
                return Text(
                  "Complete the previous steps to continue",
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                );
              }
            });
          },
        ),
        image: Center(
          child: LottieBuilder.asset('assets/run.json',frameRate: FrameRate.max,),
        ),
        footer: BlocBuilder<IntroFitbitBloc, IntroFitbitState>(
            builder: (context, fitbitstate) {
          return BlocBuilder<IntroWithingsBloc, IntroWithingsState>(
              builder: (context, withingsstate) {
            if (fitbitstate is IntroFitbitLoaded &&
                withingsstate is IntroWithingsLoaded) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                child: Text("Let's start !"),
                onPressed: () async {
                  await prefs?.setBool('isIntroEnded', true);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              );
            } else {
              return Container();
            }
          });
        }),
      ),
    ];
  }
}
