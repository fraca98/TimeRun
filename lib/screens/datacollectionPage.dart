import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; // Import stop_watch_timer
import 'package:timerun/screens/homePage.dart';
import 'package:timelines/timelines.dart';

class DataCollectionPage extends StatefulWidget {
  DataCollectionPage({super.key});

  static const route = '/datacollection/';
  static const routename = 'DataCollectionPage';

  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage>
    with SingleTickerProviderStateMixin {
  StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) => print('onChange $value'), //print value of timer on change
  );
  late AnimationController _animationController;
  int progressindex = 0; // gestisce la barra dei progressi

  int timeplaying = 0; // variabile che gestisce se il timer sta andando
  /* 0: Timer spento e bisogna premere play
     1: Timer acceso e bisogna premere stop
     2: Timer spento e bisogna selezionare salva/prosegui o cancella
  */

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data collection'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 10),
                  child: Image.asset(
                    'assets/polar.png',
                    width: 200,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        '100',
                        style: TextStyle(fontSize: 40, fontFamily: 'Poppins'),
                      ),
                      Text(
                        ' BPM',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins'),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
                  child: SfLinearGauge(
                    minimum: 40,
                    maximum: 200,
                    ranges: [
                      LinearGaugeRange(
                        startValue: 40,
                        endValue: 98,
                        color: Colors.greenAccent,
                      ),
                      LinearGaugeRange(
                        startValue: 98,
                        endValue: 137,
                        color: Colors.yellowAccent,
                      ),
                      LinearGaugeRange(
                        startValue: 137,
                        endValue: 176,
                        color: Colors.orangeAccent,
                      ),
                      LinearGaugeRange(
                        startValue: 176,
                        endValue: 200,
                        color: Colors.redAccent,
                      ),
                    ],
                    markerPointers: [
                      LinearShapePointer(
                        color: Colors.black,
                        value: 100,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Text(
                    (() {
                      switch (progressindex) {
                        case 0:
                          return 'Stai fermo, a riposo';
                        case 1:
                          return "Mantieni l'indicatore nella zona verde";
                        case 2:
                          return "Mantieni l'indicatore nella zona gialla";
                        case 3:
                          return "Mantieni l'indicatore nella zona arancione";
                        case 4:
                          return "Mantieni l'indicatore nella zona rossa";
                        default:
                          return '';
                      }
                    }()),
                    style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Container(
                height: 215.0,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: timeplaying == 1 ? null : 0,
                          strokeWidth: 10,
                          //color: Colors.red,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    Center(
                      child: StreamBuilder<int>(
                        /// Display time
                        stream: _stopWatchTimer.rawTime,
                        initialData: _stopWatchTimer.rawTime.value,
                        builder: (context, snap) {
                          final value = snap.data!;
                          final displayTime = StopWatchTimer.getDisplayTime(
                              value,
                              hours: false);
                          return Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          timeplaying != 2
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      if (timeplaying == 0) {
                        print(DateTime.now());
                        print((DateTime.now().toUtc().millisecondsSinceEpoch /
                                1000)
                            .floor()); //UNIX timestamp in secondi
                        timeplaying = 1;
                        _stopWatchTimer.onStartTimer();
                      } else {
                        print(DateTime.now());
                        print((DateTime.now().toUtc().millisecondsSinceEpoch /
                                1000)
                            .floor()); //UNIX timestamp in secondi
                        timeplaying = 2;
                        _stopWatchTimer.onStopTimer();
                      }
                    });
                  },
                  //backgroundColor: Colors.red,
                  child: Icon(() {
                    if (timeplaying == 0) {
                      return MdiIcons.play;
                    } else {
                      return MdiIcons.stop;
                    }
                  }()),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      //saving button
                      onPressed: () {
                        setState(() {
                          print(DateTime.now());
                          progressindex++;
                          if (progressindex == 5) {
                            Navigator.pushReplacementNamed(
                                context, HomePage.route);
                          }
                          _stopWatchTimer.onResetTimer();
                          timeplaying = 0;
                        });
                      },
                      backgroundColor: Colors.greenAccent,
                      child: Icon(MdiIcons.contentSave),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _stopWatchTimer.onResetTimer();
                          timeplaying = 0;
                        });
                      },
                      backgroundColor: Colors.black,
                      child: Icon(MdiIcons.delete),
                    ),
                  ],
                ),
          Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              child: _progressbar()),
        ],
      ),
    );
  }

  final _status = [
    'A riposo',
    'Leggero',
    'Medio',
    'Intenso',
    'Picco',
  ];

  Widget _progressbar() {
    return Timeline.tileBuilder(
      theme: TimelineThemeData(
        direction: Axis.horizontal,
        connectorTheme: ConnectorThemeData(
          space: 30.0,
          thickness: 5.0,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemExtentBuilder: (_, __) => MediaQuery.of(context).size.width / 5,
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              '${_status[index]}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          var color;
          var child;
          if (index == progressindex) {
            color = Colors.grey;
            child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          } else if (index < progressindex) {
            color = Colors.greenAccent;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = Color(0xffd1d2d7);
          }
          if (index <= progressindex) {
            return DotIndicator(
              size: 30.0,
              color: color,
              child: child,
            );
          } else {
            return OutlinedDotIndicator(
              borderWidth: 4.0,
              color: color,
            );
          }
        },
        connectorBuilder: (_, index, type) {
          if (index > progressindex) {
            return DecoratedLineConnector(
              decoration: BoxDecoration(color: Color(0xffd1d2d7)),
            );
          } else {
            return SolidLineConnector(
              color: Colors.greenAccent,
            );
          }
        },
        itemCount: 5,
      ),
    );
  }
}
