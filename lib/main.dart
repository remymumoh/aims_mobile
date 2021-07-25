import 'dart:isolate';
import 'dart:async';
import 'dart:core';

import 'package:aims_mobile/screens/authentication/siginweb.dart';
import 'package:aims_mobile/screens/authentication/signin.dart';
import 'package:aims_mobile/screens/pages/nav_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'config/palette.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //
  // Isolate.current.addErrorListener(RawReceivePort((pair) async {
  //   final List<dynamic> errorAndStacktrace = pair;
  //   await FirebaseCrashlytics.instance.recordError(
  //     errorAndStacktrace.first,
  //     errorAndStacktrace.last,
  //   );
  // }).sendPort);

  // if (kDebugMode) {
  //   // Force disable Crashlytics collection while doing every day development.
  //   // Temporarily toggle this to true if you want to test crash reporting in your app.
  //   await FirebaseCrashlytics.instance
  //       .setCrashlyticsCollectionEnabled(false);
  // } else {
  //   // Handle Crashlytics enabled status when not in Debug,
  //   // e.g. allow your users to opt-in to crash reporting.
  // }

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  //final UserAgentApplication userAgentApplication;

  const MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoring Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Palette.scaffold,
      ),
      // home: SignIn(),
      routes: {
        //Homepage and being controled by PagesProvider
        '/': (context) => SignIn(),
        'nav': (context) => NavScreen(),
        // add all routes with names here
      },
    );
  }

}
