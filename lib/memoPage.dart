import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

class MemoPage extends StatefulWidget{
  const MemoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL = 'https://fir-example-9b685-default-rtdb.asia-southeast1.firebasedatabase.app/';
  List<Memo> memos = List.empty(growable: true);

  AndroidNotificationChannel? channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('memo');

    reference!.onChildAdded.listen((event) {
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }


  _initFirebaseMessaging(BuildContext context) async{
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (notification != null && android != null) {
        print('Message also contained a notification: ${message.notification}');
        // showDialog(context: context, builder: (context){
        //   return AlertDialog(title: Text("${notification.title}"), content: Text("${notification.body}"),);
        // });

        flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel!.id,
                channel!.name,
                channel!.description,
                icon: 'launch_background',
              ),
            ));

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    print("messaging.getToken() , ${await messaging.getToken()}");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Memo App'),
        ),
        body: Container(
            child: Center(
                child: memos.isEmpty
                    ? const CircularProgressIndicator()
                    : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Card(
                          child: GridTile(
                              child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  child: SizedBox(
                                      child: GestureDetector(
                                          onTap: () async {
                                            Memo? memo = await Navigator.of(
                                                context).push(
                                                MaterialPageRoute<Memo>(
                                                    builder: (
                                                        BuildContext context) =>
                                                        MemoDetailPage(
                                                            reference!,
                                                            memos[index])
                                                )
                                            );
                                            if (memo != null) {
                                              setState(() {
                                                memos[index].title = memo.title;
                                                memos[index].content =
                                                    memo.content;
                                              });
                                            }
                                          },
                                          onLongPress: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text(
                                                          memos[index].title),
                                                      content: const Text(
                                                          'Are you sure to delete'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                            onPressed: () {
                                                              reference!.child(
                                                                  memos[index]
                                                                      .key!)
                                                                  .remove()
                                                                  .then((_) {
                                                                setState(() {
                                                                  memos
                                                                      .removeAt(
                                                                      index);
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                });
                                                              });
                                                            },
                                                            child: const Text(
                                                                'Yes')
                                                        ),
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'No'))

                                                      ]
                                                  );
                                                }
                                            );
                                          },
                                          child: Text(memos[index].content)
                                      )
                                  )
                              ),
                              header: Text(memos[index].title),
                              footer: Text(
                                  memos[index].createTime.substring(0, 10))
                          )
                      );
                    },
                    itemCount: memos.length
                )
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MemoAddPage(reference!)));
          },
        )
    );
  }


}