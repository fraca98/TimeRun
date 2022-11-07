import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:polar/polar.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:timelines/timelines.dart';
import 'package:timerun/bloc/crono_bloc/crono_bloc.dart';
import 'package:timerun/bloc/detail_bloc/detail_bloc.dart';
import 'package:timerun/model/status.dart';
import 'package:timerun/widget/timerText.dart';
import '../database/AppDatabase.dart';

class DataCollectionPage extends StatelessWidget {
  final Polar polar;
  final User user;
  final List<String> sessionDevices;
  final int numSession;
  BuildContext detailcontext;

  DataCollectionPage(
      {required this.polar,
      required this.numSession,
      required this.sessionDevices,
      required this.user,
      required this.detailcontext,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CronoBloc(
        polar: polar,
        idUser: user.id,
        sessionDevices: sessionDevices,
        numSession: numSession,
      ),
      child: BlocConsumer<CronoBloc, CronoState>(
        listener: (context, state) async {
          if (state is CronoStateCompleted) {
            detailcontext
                .read<DetailBloc>()
                .subStreamSession
                ?.resume(); //resume stream for detail
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              //Manage navigation
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
                  title: Text('Data Collection Session'),
                  centerTitle: true,
                  automaticallyImplyLeading: state is CronoStateInit ||
                          state is CronoStateSaving ||
                          state is CronoStateCompleted ||
                          state is CronoStateRunning
                      ? false
                      : true,
                ),
                body: BlocListener<CronoBloc, CronoState>(
                  listenWhen: ((previous, current) {
                    //print(previous);
                    //print(current);
                    if (previous is CronoStateExt && current is CronoStateExt) {
                      if (previous.errorMessage != null &&
                          previous.errorMessage == current.errorMessage) {
                        //print('Same error');
                        return false;
                      } else if (previous.errorMessage != null &&
                          previous.errorMessage!.contains('interval') &&
                          current.errorMessage == null) {
                        //to show snackbar of empty interval without removing it if there are not errors then
                        return false;
                      } else {
                        return true;
                      }
                    } else {
                      return true;
                    }
                  }),
                  listener: (context, state) {
                    SnackBar snackBar;
                    if (state is CronoStateExt) {
                      (state).errorMessage != null
                          ? state.errorMessage!.contains('interval')
                              ? snackBar = SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        MdiIcons.noteRemove,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(state.errorMessage!)
                                    ],
                                  ),
                                  dismissDirection: DismissDirection.none,
                                )
                              : snackBar = SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        state.errorMessage!
                                                .contains('Bluetooth')
                                            ? MdiIcons.bluetoothOff
                                            : MdiIcons.contactlessPayment,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(state.errorMessage!)
                                    ],
                                  ),
                                  duration: Duration(days: 365),
                                  dismissDirection: DismissDirection.none,
                                )
                          : snackBar = SnackBar(content: SizedBox());

                      if (state is CronoStatePlay &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (state is CronoStatePause &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (state is CronoStateStop &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (state is CronoStateRunning &&
                          state.errorMessage != null) {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }
                    }
                  },
                  child: state is CronoStateInit
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : state is CronoStateSaving ||
                              state is CronoStateCompleted
                          ? Center(
                              child: LottieBuilder.asset(
                                'assets/database-store.json',
                                repeat: true,
                                frameRate: FrameRate.max,
                              ),
                            )
                          : Column(
                              children: [
                                _polar(context, state as CronoStateExt),
                                Divider(
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _crono(context, state),
                                SizedBox(
                                  height: 30,
                                ),
                                _buttonsTimer(context, state),
                                Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: _progressbar(context, state),
                                )
                              ],
                            ),
                )),
          );
        },
      ),
    );
  }

  Widget _polar(BuildContext context, CronoStateExt state) {
    final double maxHrValue =
        (220 - (DateTime.now().year - user.birthDate)).toDouble();
    String text;
    switch (state.progressIndex) {
      case 0:
        text = 'Keep the indicator in the white zone';
        break;
      case 1:
        text = "Keep the indicator in the blue zone";
        break;
      case 2:
        text = "Keep the indicator in the green zone";
        break;
      case 3:
        text = "Keep the indicator in the yellow zone";
        break;
      case 4:
        text = "Keep the indicator in the orange zone";
        break;
      default:
        text = '';
    }
    Icon batteryIcon;
    String batteryLevel;
    if (state.battery != null) {
      if (state.errorMessage != null &&
          state.errorMessage!.contains('Bluetooth')) {
        batteryIcon = Icon(MdiIcons.batteryUnknown);
        batteryLevel = '';
      } else {
        if (state.battery! == 100) {
          batteryIcon = Icon(
            MdiIcons.battery,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! > 100 && state.battery! >= 90) {
          batteryIcon = Icon(
            MdiIcons.battery90,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 90 && state.battery! >= 80) {
          batteryIcon = Icon(
            MdiIcons.battery80,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 80 && state.battery! >= 70) {
          batteryIcon = Icon(
            MdiIcons.battery70,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 70 && state.battery! >= 60) {
          batteryIcon = Icon(
            MdiIcons.battery60,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 60 && state.battery! >= 50) {
          batteryIcon = Icon(
            MdiIcons.battery50,
            color: Colors.green,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 50 && state.battery! >= 40) {
          batteryIcon = Icon(
            MdiIcons.battery40,
            color: Colors.orange,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 40 && state.battery! >= 30) {
          batteryIcon = Icon(
            MdiIcons.battery30,
            color: Colors.orange,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 30 && state.battery! >= 20) {
          batteryIcon = Icon(
            MdiIcons.battery20,
            color: Colors.red,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 20 && state.battery! >= 10) {
          batteryIcon = Icon(
            MdiIcons.battery10,
            color: Colors.red,
          );
          batteryLevel = state.battery.toString();
        } else if (state.battery! < 10) {
          batteryIcon = Icon(
            MdiIcons.batteryOff,
            color: Colors.red,
          );
          batteryLevel = state.battery.toString();
        } else {
          batteryIcon = Icon(MdiIcons.batteryUnknown);
          batteryLevel = '';
        }
      }
    } else {
      batteryIcon = Icon(MdiIcons.batteryUnknown);
      batteryLevel = '';
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
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/polar.png',
                    width: 200,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      batteryIcon,
                      Text(batteryLevel),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Spacer(),
              Text(
                state.hr == 0 ? '?' : state.hr.toString(),
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
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
            child: SfLinearGauge(
              minimum: 40,
              maximum: 220,
              ranges: [
                LinearGaugeRange(
                  startValue: 0,
                  endValue: 0.5 * maxHrValue,
                  color: Colors.white,
                ),
                LinearGaugeRange(
                  startValue: 0.5 * maxHrValue,
                  endValue: 0.6 * maxHrValue,
                  color: Colors.lightBlueAccent,
                ),
                LinearGaugeRange(
                  startValue: 0.6 * maxHrValue,
                  endValue: 0.7 * maxHrValue,
                  color: Colors.greenAccent,
                ),
                LinearGaugeRange(
                  startValue: 0.7 * maxHrValue,
                  endValue: 0.8 * maxHrValue,
                  color: Colors.yellowAccent,
                ),
                LinearGaugeRange(
                  startValue: 0.8 * maxHrValue,
                  endValue: 0.9 * maxHrValue,
                  color: Colors.orangeAccent,
                ),
                LinearGaugeRange(
                  startValue: 0.9 * maxHrValue,
                  endValue: 220,
                  color: Colors.redAccent,
                ),
              ],
              markerPointers: [
                LinearShapePointer(
                  color: Colors.black,
                  value: state.hr.toDouble(),
                )
              ],
            ),
          ),
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
                child: TimerText(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonsTimer(BuildContext context, CronoState state) {
    if (state is CronoStatePlay) {
      return FloatingActionButton(
        onPressed: () {
          context
              .read<CronoBloc>()
              .add(CronoEventPlay(duration: state.duration));
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
              context.read<CronoBloc>().add(CronoEventPause());
            },
            child: Icon(MdiIcons.pause),
          ),
          FloatingActionButton(
            onPressed: () {
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
              context.read<CronoBloc>().add(CronoEventResume());
            },
            child: Icon(MdiIcons.play),
          ),
          FloatingActionButton(
            onPressed: () {
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
              context.read<CronoBloc>().add(CronoEventSave());
            },
            child: Icon(MdiIcons.archive),
          ),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              context.read<CronoBloc>().add(CronoEventDelete());
            },
            child: Icon(MdiIcons.delete),
          ),
        ],
      );
    } else {
      return Text('Error CronoBloc');
    }
  }

  Widget _progressbar(BuildContext context, CronoStateExt state) {
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
      title: Text("Warning", style: TextStyle(fontFamily: 'Poppins')),
      content: Text("Are you sure to delete this session ?",
          style: TextStyle(fontFamily: 'Poppins')),
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: TextStyle(fontFamily: 'Poppins')),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CronoBloc>().add(CronoEventDeleteSession());
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(fontFamily: 'Poppins')))
      ],
    );
  }
}
