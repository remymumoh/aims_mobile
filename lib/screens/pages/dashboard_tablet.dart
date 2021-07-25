import 'dart:convert';
import 'dart:developer';

import 'package:aims_mobile/screens/authentication/signin.dart';
import 'package:aims_mobile/screens/forms/forms_dashboard.dart';
import 'package:aims_mobile/screens/forms/supervisor/incident_reports_list.dart';
import 'package:aims_mobile/screens/pages/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aims_mobile/screens/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key key, this.result}) : super(key: key);

  final result;
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Items home = new Items(screen: NavScreen());
  // Items update = new Items(screen: CameraExampleHome());
  // Items bluetooth = new Items(screen: BluetoothApp());
  Items forms = new Items(screen: FormsDashboard());

  Items supervisor = new Items(screen: SuperVisorSheet());
  // Items messages = new Items(screen: NavScreen());
  Items settings = new Items(screen: Settings());
  // Items check = new Items(screen: NavScreen());
  // Items logout = new Items(screen: AudioRecorder());
  bool isAdmin = true;
  String name = "";
  List<String> studies = [];
  List<dynamic> pending = [], approved = [];

  @override
  void initState() {
    super.initState();
    getAdminStatus();
  }

  void getAdminStatus() async {
    debugPrint("getAdminStatus() called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // isAdmin = prefs.getString("roles") == "ROLE_ADMIN";
    isAdmin = true;
    name = prefs.get("username");
    if (!isAdmin) {
      studies.add("Enrolled Studies:");
      http.get("http://10.0.2.2:8080/api/v1/user/$name/studies-by-name").then((response) {
        debugPrint(response.body);
        debugPrint("${json.decode(response.body)}");
        var respList = json.decode(response.body);
        for (var i in respList) {
          setState(() {
            studies.add("• " + i.toString());
          });
        }
        // build(context);
      });
    } else {
      http.get("http://10.0.2.2:8080/api/v1/entry/pending-incidents/pending").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          pending = list;
        });

        // log(value.body);
        // log(list.toString());
        // log("${list.length}");
        // log("${list[0]['approved']}");
        if (list.length > 0) {
          for (var i in list) {
            log("${i['approved']}");
          }
        }
      });
      http.get("http://10.0.2.2:8080/api/v1/entry/pending-incidents/approved").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });

        // log(value.body);
        // log(list.toString());
        // log("${list.length}");
        // log("${list[0]['approved']}");
        if (list.length > 0) {
          for (var i in list) {
            log("${i['approved']}");
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("build(BuildContext) called");
    // return Expanded(
    //   child: Column(
    //     // shrinkWrap: true,
    //     children: <Widget>[
    //       if (!isAdmin) showStudies(),
    //       if (isAdmin) showNCEStatuses(),
    //       dashboardContents(),
    //     ],
    //   )
    // );
    return Padding(
      // shrinkWrap: true,
        padding: EdgeInsets.only(left: 10, top: 30, right: 10),
        child: Container(
            height: 600,
            child: SingleChildScrollView(
              child: Container(
                // height: 500,
                child: new Column(
                  children: <Widget>[
                    (!isAdmin) ? showStudies() : showNCEStatuses(),
                    dashboardContents(),
                    // Spacer()
                  ],
                ),
              ),
            )
        )
    );
  }

  Widget showStudies() {
    // debugPrint("showStudies() called");
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300.0, minHeight: 0.0),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: studies.length,
            itemBuilder: (BuildContext context, int position) {
              return Padding(
                  padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                  child: position != 0 ? Text(this.studies[position]) : Text(this.studies[position], style: TextStyle(fontSize: 18),)
              );
            }
        )
    );
  }

  Widget showNCEStatuses() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("NCE Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${approved.length} ${approved.length == 1 ? "report is" : "reports are"} marked as approved")
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.error, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${pending.length} ${pending.length == 1 ? "report is" : "reports are"} pending review")
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review NCEs"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return IncidentReportsList();
                }));
              },
            ),
          )
        ]
    );
  }

  Widget dashboardContents() {
    return Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text("Forms"),
            trailing: GestureDetector(
                child: Icon(Icons.chevron_right, color: Colors.grey)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return FormsDashboard();
              }));
            },
          ),
        ),
        Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text("Settings"),
            trailing: GestureDetector(
                child: Icon(Icons.chevron_right, color: Colors.grey)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return Settings();
              }));
            },
          ),
        ),
        Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
              title: Text("Log out"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () => showAlertDialog(context)
          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', null);
        await prefs.clear();
        await SignIn().getMsal.signOut();
        // msal = null;
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you would like to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  final Widget screen;

  Items({this.title, this.subtitle, this.event, this.img, this.screen});
}
