import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timerun/providers/introprovider.dart';
import 'package:timerun/screens/homePage.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  static const route = '/introduction/';
  static const routename = 'IntroductionPage';

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<IntroProvider>(
      builder: (context, value, child) => IntroductionScreen(
        pages: listPages(),
        showDoneButton: false,
        showNextButton: false,
        showBackButton: false,
        showSkipButton: false,
        isProgressTap: false,
      ),
    );
  }

  List<PageViewModel> listPages() {
    return [
      PageViewModel(
          title: "Benvenuto",
          body: "Questa applicazione consente di ...",
          image: Center(child: Padding(padding: EdgeInsets.only(top: 30), child: Container(child: Image.asset('assets/apple.png'))))),
      PageViewModel(
        title: "Connetti il tuo account",
        body:
            "Prima di continuare, connetti il tuo account di Withings affinchè l'applicazione possa scaricare i tuoi dati",
        image: Container(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Center(child: Image.asset('assets/withings.png')))),
        footer: Provider.of<IntroProvider>(context, listen: false).isLoading
            ? CircularProgressIndicator(
                color: Colors.blue,
              )
            : Container(
                child: Provider.of<IntroProvider>(context, listen: false)
                            .accessToken !=
                        null
                    ? Icon(
                        MdiIcons.cloudCheck,
                        size: 80,
                        color: Colors.greenAccent,
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          Provider.of<IntroProvider>(context, listen: false)
                              .updateLoading();
                          await Future.delayed(Duration(seconds: 1));
                          await Provider.of<IntroProvider>(context,
                                  listen: false)
                              .withAuthorization();
                          await Future.delayed(Duration(seconds: 1));
                          Provider.of<IntroProvider>(context, listen: false)
                              .updateLoading();

                          final snackbar = SnackBar(
                              backgroundColor: Colors.redAccent,
                              content:
                                  Text('Autenticazione fallita, riprova !'));
                          if (Provider.of<IntroProvider>(context, listen: false)
                                  .accessToken ==
                              null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbar);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                        ),
                        child: Text("Connetti !"),
                      ),
              ),
      ),
      PageViewModel(
          title: "Ora siamo pronti per iniziare !",
          body:
              "Premi sul pulsante sottostante per iniziare a usare l'applicazione",
          image: Center(
            child: Icon(
              MdiIcons.run,
              size: 250,
              color: Colors.black,
            ),
          ),
          footer: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            child: Text("Iniziamo !"),
            onPressed: () async {
              if (Provider.of<IntroProvider>(context, listen: false)
                      .accessToken !=
                  null) {
                Provider.of<IntroProvider>(context, listen: false).introEnded();
                Navigator.of(context).pushReplacementNamed(HomePage.route);
              } else {
                final snackbar = SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('Completa prima tutti i passaggi !'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
          )),
    ];
  }
}
