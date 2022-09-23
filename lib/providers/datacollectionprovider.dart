import 'package:flutter/cupertino.dart';

class DataCollectionProvider extends ChangeNotifier {
  int progressindex = 0; // gestisce la barra dei progressi (0-->4)

  int timeplaying = 0; // variabile che gestisce se il timer sta andando
  /* 0: Timer spento e bisogna premere play
     1: Timer acceso e bisogna premere pausa/stop
     2: Timer in pausa con display play/stop
     3: Timer stoppato e bisogna selezionare salva/prosegui o cancella
  */
  void offTimer() {
    timeplaying = 0;
    notifyListeners();
  }

  void startTimer() {
    timeplaying = 1;
    print('Start timer: timestamp inizio');
    print(DateTime.now());
    print((DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
        .floor()); //UNIX timestamp in secondi
    notifyListeners();
  }

  void pauseTimer() {
    print('Timer in pausa');
    timeplaying = 2;
    notifyListeners();
  }

  void resumeTimer(){
    print('Resume timer');
    timeplaying = 1;
    notifyListeners();
  }

  void stopTimer() {
    print('Stop timer: timestamp finale se salvo');
    print(DateTime.now());
    print((DateTime.now().toUtc().millisecondsSinceEpoch / 1000)
        .floor()); //UNIX timestamp in secondi
    timeplaying = 3;
    notifyListeners();
  }

  void updateProgressindex() {
    progressindex++;
    notifyListeners();
  }

  void resetProgressindex(){
    progressindex = 0;
    notifyListeners();
  }
}
