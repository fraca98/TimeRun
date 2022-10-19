import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timerun/bloc/detail_bloc/detail_bloc.dart';
import '../bloc/download_bloc/download_bloc.dart';

class DownloadPage extends StatelessWidget {
  //download page to download the data of the session
  int idSession;
  int numTile;
  DownloadPage({required this.idSession, required this.numTile, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DownloadBloc(idSession: idSession),
      child: BlocConsumer<DownloadBloc, DownloadState>(
        listener: ((context, state) {
          if (state is DownloadStateLoaded && state.error == true) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Something went wrong, retry later')));
          }
        }),
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is DownloadStateLoading) {
                return false;
              } else {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                return true;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text('Session $numTile'),
                centerTitle: true,
                automaticallyImplyLeading: state is DownloadStateInitial ||
                        state is DownloadStateLoading
                    ? false
                    : true,
              ),
              body: BlocBuilder<DownloadBloc, DownloadState>(
                  builder: (context, state) {
                if (state is DownloadStateInitial) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is DownloadStateLoaded) {
                  return Column(
                    children: [
                      ListTile(
                          leading: Icon(MdiIcons.circleSmall),
                          title: Text(state.session.device1),
                          trailing: state.session.download1
                              ? Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(MdiIcons.download),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    context
                                        .read<DownloadBloc>()
                                        .add(DownloadEventDownload(numTile: 1));
                                  },
                                )),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                          leading: Icon(MdiIcons.circleSmall),
                          title: Text(state.session.device2),
                          trailing: state.session.download2
                              ? Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(MdiIcons.download),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .removeCurrentSnackBar();
                                    context
                                        .read<DownloadBloc>()
                                        .add(DownloadEventDownload(numTile: 2));
                                  },
                                )),
                    ],
                  );
                }
                if (state is DownloadStateLoading) {
                  return Column(
                    children: [
                      ListTile(
                          leading: Icon(MdiIcons.circleSmall),
                          title: Text(state.session.device1),
                          trailing: state.session.download1
                              ? Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : state.numTile == 1
                                  ? CircularProgressIndicator()
                                  : null),
                      SizedBox(
                        height: 30,
                      ),
                      ListTile(
                          leading: Icon(MdiIcons.circleSmall),
                          title: Text(state.session.device2),
                          trailing: state.session.download2
                              ? Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    MdiIcons.check,
                                    color: Colors.green,
                                  ),
                                )
                              : state.numTile == 2
                                  ? CircularProgressIndicator()
                                  : null),
                    ],
                  );
                } else {
                  return Text('Error DownloadBloc');
                }
              }),
            ),
          );
        },
      ),
    );
  }
}
