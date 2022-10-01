import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart'; // Import stop_watch_timer
import 'package:timelines/timelines.dart';
import 'package:timerun/bloc/crono_bloc/crono_bloc.dart';
import 'package:timerun/model/status.dart';
import 'package:timerun/screens/detailPage.dart';
import 'package:timerun/screens/homePage.dart';

class DataCollectionPage extends StatefulWidget {
  final int id;
  final List<String> sessionDevices;
  final int numSession;

  DataCollectionPage(
      {required this.numSession,
      required this.sessionDevices,
      required this.id,
      super.key});

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
  Future<void> dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CronoBloc(
        idUser: widget.id,
        sessionDevices: widget.sessionDevices,
        numSession: widget.numSession,
      ),
      child: BlocConsumer<CronoBloc, CronoState>(
        listener: (context, state) async {
          if (state is CronoStateDeletedSession) {
            //TODO: fix route
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (_) => false);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          id: widget.id,
                        )));
          }
          if (state is CronoStateCompleted) {
            //TODO: fix this route
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (_) => false);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailPage(
                          id: widget.id,
                        )));
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is CronoStatePlay ||
                  state is CronoStatePause ||
                  state is CronoStateStop) {
                showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return _alertDeleteCurrentSession(
                          context); //pass the context of the page to use BLOC in alertdialog
                    });
              }
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Sessione di allenamento'),
                centerTitle: true,
                automaticallyImplyLeading: state is CronoStateSaving ||
                        state is CronoStateCompleted ||
                        state is CronoStateDeletingSession ||
                        state is CronoStateDeletedSession || state is CronoStateRunning
                    ? false
                    : true,
              ),
              body: Column(
                children: [
                  _polar(context, state),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _crono(context, state),
                  Spacer(),
                  _buttonsTimer(context, state),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: _progressbar(context, state),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _polar(BuildContext context, CronoState state) {
    String text;
    switch (state.progressIndex) {
      case 0:
        text = 'Stai fermo, a riposo';
        break;
      case 1:
        text = "Mantieni l'indicatore nella zona verde";
        break;
      case 2:
        text = "Mantieni l'indicatore nella zona gialla";
        break;
      case 3:
        text = "Mantieni l'indicatore nella zona arancione";
        break;
      case 4:
        text = "Mantieni l'indicatore nella zona rossa";
        break;
      default:
        text = '';
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 24,
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 10),
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
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
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
          state is CronoStateSaving || state is CronoStateCompleted
              ? Text(
                  'Salvataggio ...',
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                )
              : Container(),
          state is CronoStateDeletingSession ||
                  state is CronoStateDeletedSession
              ? Text(
                  'Cancellando la sessione in corso ...',
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                )
              : Container(),
          state is CronoStatePlay ||
                  state is CronoStatePause ||
                  state is CronoStateStop ||
                  state is CronoStateRunning
              ? Text(
                  text,
                  style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _crono(BuildContext context, CronoState state) {
    return Column(
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
                    strokeWidth: 10,
                    backgroundColor: Colors.grey,
                    value: state is CronoStateRunning ? null : 0,
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
                    final displayTime =
                        StopWatchTimer.getDisplayTime(value, hours: false);
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
    );
  }

  Widget _buttonsTimer(BuildContext context, CronoState state) {
    if (state is CronoStateSaving ||
        state is CronoStateCompleted ||
        state is CronoStateDeletingSession ||
        state is CronoStateDeletedSession) {
      return CircularProgressIndicator();
    }
    if (state is CronoStatePlay) {
      return FloatingActionButton(
        onPressed: () {
          _stopWatchTimer.onStartTimer();
          context.read<CronoBloc>().add(CronoEventPlay());
        },
        child: Icon(MdiIcons.play),
      );
    }
    if (state is CronoStateRunning) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              _stopWatchTimer.onStopTimer();
              context.read<CronoBloc>().add(CronoEventPause());
            },
            child: Icon(MdiIcons.pause),
          ),
          FloatingActionButton(
            onPressed: () {
              _stopWatchTimer.onStopTimer();
              context.read<CronoBloc>().add(CronoEventStop());
            },
            child: Icon(MdiIcons.stop),
          ),
        ],
      );
    }
    if (state is CronoStatePause) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              _stopWatchTimer.onStartTimer();
              context.read<CronoBloc>().add(CronoEventResume());
            },
            child: Icon(MdiIcons.play),
          ),
          FloatingActionButton(
            onPressed: () {
              _stopWatchTimer.onStopTimer();
              context.read<CronoBloc>().add(CronoEventStop());
            },
            child: Icon(MdiIcons.stop),
          ),
        ],
      );
    }
    if (state is CronoStateStop) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              _stopWatchTimer.onResetTimer();
              context.read<CronoBloc>().add(CronoEventSave());
            },
            child: Icon(MdiIcons.archive),
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              _stopWatchTimer.onResetTimer();
              context.read<CronoBloc>().add(CronoEventDelete());
            },
            child: Icon(MdiIcons.delete),
          ),
        ],
      );
    }
    if (state is CronoStateCompleted) {
      return Container();
    } else {
      return Text('Error CronoBloc');
    }
  }

  Widget _progressbar(BuildContext context, CronoState state) {
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
        itemExtentBuilder: (_, __) =>
            MediaQuery.of(context).size.width / status.length,
        contentsBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              '${status[index]}',
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
          if (index == state.progressIndex) {
            color = Colors.grey;
            child = Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          } else if (index < state.progressIndex) {
            color = Colors.green;
            child = Icon(
              Icons.check,
              color: Colors.white,
              size: 15.0,
            );
          } else {
            color = Color(0xffd1d2d7);
          }
          if (index <= state.progressIndex) {
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
          if (index > state.progressIndex) {
            return DecoratedLineConnector(
              decoration: BoxDecoration(color: Color(0xffd1d2d7)),
            );
          } else {
            return SolidLineConnector(
              color: Colors.green,
            );
          }
        },
        itemCount: status.length,
      ),
    );
  }

  // set up the AlertDialog when deleting current session (go back)
  Widget _alertDeleteCurrentSession(BuildContext context) {
    //pass the context of the page
    return AlertDialog(
      icon: Icon(MdiIcons.alert),
      title: Text("Attenzione", style: TextStyle(fontFamily: 'Poppins')),
      content: Text("Sei sicuro di voler eliminare questa sessione ?",
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
              Navigator.pop(context);
              context.read<CronoBloc>().add(CronoEventDeleteSession());
            },
            child: Text('Elimina', style: TextStyle(fontFamily: 'Poppins')))
      ],
    );
  }
}
