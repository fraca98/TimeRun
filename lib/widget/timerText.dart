import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timerun/bloc/crono_bloc/crono_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final duration = context.select((CronoBloc bloc) {
      if (bloc.state is CronoStateExt) {
        var ext = bloc.state as CronoStateExt;
        return ext.duration;
      } else {
        return null;
      }
    });
    final minutesStr =
        ((duration! / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: TextStyle(fontSize: 60),
    );
  }
}
