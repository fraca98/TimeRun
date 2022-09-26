import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; // Import stop_watch_timer
import 'package:timerun/database/AppDatabase.dart';
import 'package:timerun/providers/datacollectionprovider.dart';
import 'package:timelines/timelines.dart';
import 'package:timerun/providers/introprovider.dart';
import 'package:timerun/screens/userPage.dart';

import 'homePage.dart';

class DataCollectionPage extends StatefulWidget {
  DataCollectionPage({super.key});

  static const route = '/datacollection/';
  static const routename = 'DataCollectionPage';

  @override
  State<DataCollectionPage> createState() => _DataCollectionPageState();
}

class _DataCollectionPageState extends State<DataCollectionPage>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    //onChange: (value) => print('onChange $value'), //print value of timer on change
  );

  @override
  void initState() {
    super.initState();
    Provider.of<DataCollectionProvider>(context, listen: false).progressindex =
        0;
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sessione di allenamento'),
        centerTitle: true,
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
                Consumer<DataCollectionProvider>(
                  builder: (context, value, child) => Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Text(
                      (() {
                        switch (Provider.of<DataCollectionProvider>(context,
                                listen: false)
                            .progressindex) {
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
                        child: Consumer<DataCollectionProvider>(
                          builder: (context, value, child) =>
                              CircularProgressIndicator(
                            value: Provider.of<DataCollectionProvider>(context,
                                            listen: false)
                                        .timeplaying ==
                                    1
                                ? null
                                : 0,
                            strokeWidth: 10,
                            backgroundColor: Colors.grey,
                          ),
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
          Consumer<DataCollectionProvider>(
              builder: ((context, value, child) => _buttonsTimer())),
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

  Widget _buttonsTimer() {
    final idUser = ModalRoute.of(context)!.settings.arguments as int;
    switch (Provider.of<DataCollectionProvider>(context, listen: false)
        .timeplaying) {
      case 0:
        return Provider.of<DataCollectionProvider>(context, listen: false)
                    .progressindex <
                5
            ? FloatingActionButton(
                onPressed: () {
                  _stopWatchTimer.onStartTimer();
                  Provider.of<DataCollectionProvider>(context, listen: false)
                      .startTimer();
                },
                child: Icon(MdiIcons.play),
              )
            : Container();
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                _stopWatchTimer.onStopTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .pauseTimer();
              },
              child: Icon(MdiIcons.pause),
            ),
            SizedBox(
              width: 70,
            ),
            FloatingActionButton(
              onPressed: () {
                _stopWatchTimer.onStopTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .stopTimer();
              },
              child: Icon(MdiIcons.stop),
            ),
          ],
        );
      case 2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                _stopWatchTimer.onStartTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .resumeTimer();
              },
              child: Icon(MdiIcons.play),
            ),
            SizedBox(
              width: 70,
            ),
            FloatingActionButton(
              onPressed: () {
                _stopWatchTimer.onStopTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .stopTimer();
              },
              child: Icon(MdiIcons.stop),
            ),
          ],
        );
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () async {
                print('Salva timestamp');
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .offTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .updateProgressindex();
                if (Provider.of<DataCollectionProvider>(context, listen: false)
                        .progressindex ==
                    _status.length) {
                  User currentUser = await GetIt.I<AppDatabase>().usersDao.retrieveSpecificUser(idUser);
                  Navigator.of(context).pushReplacementNamed(UserPage.route, arguments: currentUser);
                }
              },
              child: Icon(MdiIcons.archive),
              backgroundColor: Colors.green,
            ),
            SizedBox(
              width: 70,
            ),
            FloatingActionButton(
              onPressed: () {
                print('Reset timer senza salvare');
                _stopWatchTimer.onResetTimer();
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .offTimer();
              },
              child: Icon(MdiIcons.delete),
              backgroundColor: Colors.red,
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _progressbar() {
    return Consumer<DataCollectionProvider>(
      builder: (context, value, child) => Timeline.tileBuilder(
        theme: TimelineThemeData(
          direction: Axis.horizontal,
          connectorTheme: ConnectorThemeData(
            space: 30.0,
            thickness: 5.0,
          ),
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.before,
          itemExtentBuilder: (_, __) =>
              MediaQuery.of(context).size.width / _status.length,
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
            if (index ==
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .progressindex) {
              color = Colors.grey;
              child = Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              );
            } else if (index <
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .progressindex) {
              color = Colors.green;
              child = Icon(
                Icons.check,
                color: Colors.white,
                size: 15.0,
              );
            } else {
              color = Color(0xffd1d2d7);
            }
            if (index <=
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .progressindex) {
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
            if (index >
                Provider.of<DataCollectionProvider>(context, listen: false)
                    .progressindex) {
              return DecoratedLineConnector(
                decoration: BoxDecoration(color: Color(0xffd1d2d7)),
              );
            } else {
              return SolidLineConnector(
                color: Colors.green,
              );
            }
          },
          itemCount: _status.length,
        ),
      ),
    );
  }
}
