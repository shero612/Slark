import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:slark/bloc/account_bloc.dart';
import 'package:slark/bloc/list_bloc.dart';
import 'package:slark/bloc/space_bloc.dart';
import 'package:slark/bloc/task_bloc.dart';
import 'package:slark/bloc/workspace_bloc.dart';
import 'package:slark/dto/dto_list.dart';
import 'package:slark/dto/dto_space.dart';
import 'package:slark/dto/dto_task.dart';
import 'package:slark/dto/dto_user.dart';
import 'package:slark/dto/dto_ws.dart';
import 'package:slark/ui/home.dart';

class InitialSplashScreen extends StatefulWidget {
  @override
  _InitialSplashScreenState createState() => _InitialSplashScreenState();
  final data;
  InitialSplashScreen(this.data);
}

class _InitialSplashScreenState extends State<InitialSplashScreen> {
  // SpaceBloc spaceBloc;
  // ignore: unused_field
  final _wsbloc = WorkspaceBloc();
  final _bloc = AccountBloc();
  final _spacebloc = SpaceBloc();
  final _listbloc = ListBloc();
  final _taskbloc = TaskBloc();
  var udto = new DtoUser();
  var wsdto = new DtoWS();
  var spacedto = new DtoSpace();
  var listdto = new DtoList();
  var taskdto = new DtoTask();

  @override
  void initState() {
    super.initState();
    getData();
    print('INIIIT ENNDDD');
  }

  getData() async {
    // int scount = 0;
    print('In getdata function');
    int counter = 0;
    // int count = 0;
    await _bloc.getUserData(widget.data).then((value) async {
      udto.username = value.name;
      udto.email = value.email;
      print(udto.username);
      print(udto.email);
      for (var wsItem in value.workspaces) {
        print('Round $counter ');
        print('Printing the workspaces names');
        print(wsItem.name);
        // ignore: await_only_futures
        await setState(() {
          wsdto = new DtoWS();
          wsdto.workspaceId = wsItem.id;
          print(wsdto.workspaceId);
          wsdto.workspacename = wsItem.name;
          // udto.workspaces.add(wsdto);
        });

        await _spacebloc.getAllSpaces(wsItem.id).then(
          (value) async {
            if (value.length > 0) {
              for (var spaceItem in value) {
                setState(() {
                  spacedto = new DtoSpace();
                  spacedto.spaceId = spaceItem.id;
                  spacedto.spacename = spaceItem.name;
                  // scount++;
                });

                await _listbloc.getAllLists(spaceItem.id).then(
                  (value) async {
                    if (value.length > 0) {
                      for (var listItem in value) {
                        setState(() {
                          listdto = new DtoList();
                          listdto.id = listItem.id;
                          listdto.name = listItem.name;

                          print('--- $listItem');
                          print('==== ${listdto.name}');
                          // count++;
                        });
                        await _taskbloc.getAllTasks(listItem.id).then((value) {
                          print(
                              "the taskblocklength" + value.length.toString());
                          if (value != null) if (value.length > 0) {
                            // ignore: deprecated_member_use
                            listdto.tasks = new List<DtoTask>();
                            for (var taskitem in value) {
                              // if (taskitem.list == listItem) {
                              setState(() {
                                taskdto = new DtoTask();
                                taskdto.id = taskitem.id;
                                taskdto.name = taskitem.name;
                              });
                              listdto.tasks.add(taskdto);
                              // }
                            }
                          }
                        });
                        spacedto.lists.add(listdto);
                      }
                    }
                  },
                );
                wsdto.spaces.add(spacedto);
              }
            }
          },
        );

        counter++;
        udto.workspaces.add(wsdto);
      }
    });

    // for (var item in udto.workspaces) {
    //   print('workspace: ${item.workspacename}');
    //   if (item.spaces.length > 0) {
    //     for (var item2 in item.spaces) {
    //       print('Space name: ${item2.spacename}');
    //       print('SpaceId : ${item2.spaceId}');
    //       if (item2.lists.length > 0) {
    //         for (var item3 in item2.lists) {
    //           print('listname: ${item3.name}');
    //           print('listId : ${item3.id}');
    //           if (item3.tasks.length > 0) {
    //             for (var item4 in item3.tasks) {
    //               print('taskname: ${item4.name}');
    //               print('taskId : ${item4.id}');
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }

    //   print('_________');
    // }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          data: udto,
          isStepper: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7b68ee),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150.0,
              ),
              Text(
                'Slark',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Aviliator',
                    fontWeight: FontWeight.bold,
                    fontSize: 60.0),
              ),
              SizedBox(
                height: 85.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please wait a moment!',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'AdventPro',
                        fontSize: 30.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SpinKitFoldingCube(
                    color: Colors.white,
                    size: 70.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
