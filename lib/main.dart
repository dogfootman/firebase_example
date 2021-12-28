import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'memoPage.dart';
// import 'tabsPage.dart';

void main() {
  runApp(MyApp());
}



// class MyApp extends StatelessWidget {
//   static FirebaseAnalytics analytics = FirebaseAnalytics();
//   static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
//
//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       title: 'Firebase Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       navigatorObservers: <NavigatorObserver>[observer],
//       home: FirebaseApp(
//         analytics: analytics,
//         observer: observer,
//       )
//     );
//   }
// }
//
// class FirebaseApp extends StatefulWidget{
//   FirebaseApp({Key? key,required this.analytics,required this.observer}) : super(key: key);
//   // FirebaseApp({Key? key, this.analytics, this.observer}): super(key: key);
//
//   final FirebaseAnalytics analytics;
//   final FirebaseAnalyticsObserver observer;
//
//   @override
//   _FirebaseAppState createState() => _FirebaseAppState(analytics, observer);
//
// }
//
// class _FirebaseAppState extends State<FirebaseApp>{
//   _FirebaseAppState( this.analytics, this.observer);
//
//   final FirebaseAnalyticsObserver observer;
//   final FirebaseAnalytics analytics;
//   String _message = '';
//
//   void setMessage(String message){
//     setState( () {
//       _message = message;
//     });
//   }
//
//   Future<void> _sendAnalyticsEvent() async {
//     await analytics.logEvent(
//       name: 'test_event',
//       parameters: <String, dynamic> {
//         'string': 'hello flutter',
//         'int': 100
//       }
//     );
//     setMessage('Analytics send success');
//   }
//
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Example'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             RaisedButton(
//                 child: Text('Test ...'),
//                 onPressed: _sendAnalyticsEvent
//             ),
//             Text(_message, style: const TextStyle(color: Colors.blueAccent))
//           ],
//           mainAxisAlignment: MainAxisAlignment.center
//         )
//       ),
//       floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.tab),
//           onPressed: (){
//             Navigator.of(context).push(MaterialPageRoute<TabsPage>(
//               settings: RouteSettings(name: '/tab'),
//               builder: (BuildContext context){
//                 return TabsPage(observer);
//               }));
//           }),
//     );
//   }
//
// }


// memo
class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Firebase memo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot){
          if( snapshot.hasError){
            return Center(
              child: Text('Error ')
            );
          }
          //if( snapshot.connectionState == ConnectionState.done ){

            return MemoPage();
          //}

          // return Center(
          //   child: CircularProgressIndicator()
          // );
        }
      )
    );
  }
}