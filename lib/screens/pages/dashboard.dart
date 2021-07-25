import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform, SocketException;

import 'package:aims_mobile/screens/authentication/signin.dart';
import 'package:aims_mobile/screens/forms/ethics_lead/ethics_report_list.dart';
import 'package:aims_mobile/screens/forms/forms_dashboard.dart';
import 'package:aims_mobile/screens/forms/project_lead/project_lead_report_list.dart';
import 'package:aims_mobile/screens/forms/rfc/rfc_report_list.dart';
import 'package:aims_mobile/screens/forms/satellite_lab/satellite_report_list.dart';
import 'package:aims_mobile/screens/forms/team_lead/reports_list.dart';
import 'package:aims_mobile/screens/forms/tech_lead/tech_lead_report_list.dart';
import 'package:aims_mobile/screens/pages/screen.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aims_mobile/screens/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key, this.result}) : super(key: key);

  final result;
  @override
  _DashboardState createState() => _DashboardState();
}
// FormsDatabase db;
class _DashboardState extends State<Dashboard> {
  bool dataIsLoading = false;
  bool syncedSuccessfully = false;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final Firestore _fdb = Firestore.instance;

  Items forms = new Items(screen: FormsDashboard());

  Items supervisor = new Items(screen: SuperVisorSheet());
  Items settings = new Items(screen: Settings());
  bool syncToServerReqd = false;
  FormsDatabase db = FormsDatabase.getInstance();

  String role = "";
  String name = "";
  List<String> studies = [];
  List<dynamic> pending = [], approved = [], rejected = [], rejectedByHigherUp = [];
  String id = "";
  String baseUrl = "http://10.0.2.2:8080/api/v1";
  String email = "";
  String syncMessage = "Everything's up to date";
  bool syncInProgress = false;



  @override
  void initState() {
    super.initState();
    getAdminStatus();
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          AlertDialog alertDialog =
          AlertDialog(title: Text(message['notification']['title']), content: Text(message['notification']['body']));

          showDialog(context: context, builder: (_) => alertDialog);
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        }
    );
    setState(() {
      syncToServer();
      checkSyncStatus();
    });
  }


  Future<void> performSync() async {
    if (!kIsWeb) {
      db = FormsDatabase.getInstance();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("username");
    syncMessage = "Syncing...";
    syncInProgress = true;
    bool synced = await getFormTypes();

    setState(() {
      syncMessage = synced ? "Updated Successfully" : "Sync failed";
      syncInProgress = false;
    });
  }
  Future<bool> getFormTypes() async {
    debugPrint("getFormTypes() called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    dataIsLoading = true;
    // print("the username is" + email);
    try {
      // sync if connected to the internet
      bool successfulSync = await syncToServer() && await syncToDb();
      debugPrint("successfulSync is $successfulSync");
      dataIsLoading = false;
      return successfulSync;
    } on SocketException catch (e) {

      debugPrint("SOCKETEXCEPTION IN getFormTypes()");
      debugPrint(e.message);
      // if there's no internet, load templates from local storage
      return false;
    }
  }


  Future<bool> syncToDb() async {
    debugPrint("syncToDb() called");
    // get all submitted forms by user
    List<DbForm> reports = await db.getAllForms();
    List<String> ids = <String>[];
    // create a list of ids in the databases
    for (DbForm i in reports) {
      ids.add(i.id);
    }

    // get all reports with current lead's id
    log("getting forms at: $baseUrl/entry?updatedBy=$email");
    var response = await http.get("$baseUrl/entry?updatedBy=$email");
    // log("${jsonDecode(response.body)}");
    // log("${response.statusCode}");
    var serverReports = jsonDecode(response.body);
    for (var i in serverReports) {
      DbForm temp = new DbForm(
          id: i["id"],
          data_content: i["dataContent"],
          updated_by: i["updatedBy"],
          date_created: i["dateCreated"],
          date_updated: i["dateUpdated"],
          user_location: i["userLocation"],
          form_name: i["formName"],
          imei: i["imeI"],
          synced: i["synced"],
          facility: i["facility"],
          dateOfSurvey: i["dateOfSurvey"],
          processType: i["processType"],
          initiator: i['initiator'],
          reviewedByLead: i["reviewedByLead"],
          leadAccepted: i["leadAccepted"],
          leadId: i["leadId"],
          reviewedByRfc: i["reviewedByRfc"],
          rfcAccepted: i["rfcAccepted"],
          rfcId: i["rfcId"],
          leadComments: i["leadComments"],
          rfcComments: i["rfcComments"],
          satelliteLeadId: i["satelliteLeadId"],
          reviewedBySatelliteLead: i["reviewedBySatelliteLead"],
          satelliteLeadAccepted: i["satelliteLeadAccepted"],
          satelliteLeadComments: i["satelliteLeadComments"],
          ethicsId: i["ethicsId"],
          reviewedByEthics: i["reviewedByEthics"],
          ethicsAccepted: i["ethicsAccepted"],
          ethicsComments: i["ethicsComments"],
          techLeadId: i["techLeadId"],
          reviewedByTechLead: i["reviewedByTechLead"],
          techLeadAccepted: i["techLeadAccepted"],
          submittedToTeamLead: i["submittedToTeamLead"],
          techLeadComments: i["techLeadComments"],
          ethicsAssistantId: i["ethicsAssistantId"],
          reviewedByEthicsAssistant: i["reviewedByEthicsAssistant"],
          ethicsAssistantAccepted: i["ethicsAssistantAccepted"],
          ethicsAssistantComments: i["ethicsAssistantComments"],
          projectLeadId: i["projectLeadId"],
          reviewedByProjectLead: i["reviewedByProjectLead"],
          projectLeadReturned: i["projectLeadReturned"],
          projectLeadComments: i["projectLeadComments"]);
      // if the local db does not contain an element from the server, check if its
      // id exists. if it does, then it needs an update. else, it's a new record
      if (!reports.contains(temp)) {
        if (ids.contains(temp.id)) {
          await db.updateForm(temp);
        } else {
          await db.insertForm(temp);
        }
      }
    }
    return true;
  }
  Future<bool> syncToServer() async {
    debugPrint("syncToServer() called");
    syncedSuccessfully = true;
    try {
      List<DbForm> futureList = await db.getUnsyncedForms();
      for (DbForm form in futureList) {
        // var url = formBaseUri + "/" + form.id;
        var url = "$baseUrl/entry/" + form.id;
        // see if form exists in remote server (head request)
        var head = await http.head(url);
        bool exists = (head.statusCode == 200);
        if (exists) {
          // if the form exists in the remote server, update
          var remoteForm = copyLocalToRemote(form);
          // send new data to server via a PUT request
          var putResp = await Dio().put(url, data: remoteForm);
          if (putResp.statusCode != 200) {
            syncedSuccessfully = false;
          } else {
            debugPrint("UPDATED");
            DbForm syncedLocal = duplicateToSynced(form);
            int syncResult = await db.updateForm(syncedLocal);
            if (syncResult == 0) {
              syncedSuccessfully = false;
            }
          }
        } else {
          // if forms do not exist, insert
          try {
            var post = await Dio().post("$baseUrl/entry",
                data: copyLocalToRemote(form));
            debugPrint("Status code: ${post.statusCode}");
            if (post.statusCode != 201) { // if form wasn't inserted correctly using spring, set sync success to false
              // if (post.statusCode != 200) {
              // if form wasn't inserted correctly using node, set sync success to false
              syncedSuccessfully = false;
            } else {
              DbForm syncedLocal = duplicateToSynced(form);
              int syncResult = await db.updateForm(syncedLocal);
              if (syncResult == 0) {
                syncedSuccessfully = false;
              }
            }
            // } on DioError catch (e) {
          } on SocketException catch (e) {
            debugPrint("CAUGHT SOCKETEXCEPTION in forms_dashboard.dart");
            debugPrint(
                "form in question is: ${form.form_name}, id: ${form.id}");
            debugPrint(e.message);
            // debugPrintStack();
            // syncedSuccessfully = false;
            syncedSuccessfully = false;
            // break;
          }
        }
      }
      return syncedSuccessfully;
    } on SocketException catch (e) {
      debugPrint("CAUGHT SOCKETEXCEPTION\n");
      debugPrint(e.message);
      return false;
    }
  }
  void saveDeviceToken(String email) async {
    log("saveDeviceToken($email) async called");
    String fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      DocumentSnapshot tokenRef = await _fdb.collection('users').document(email).collection('tokens').document(fcmToken).get();
      DocumentSnapshot userRef = await _fdb.collection('users').document(email).get();

      if (!tokenRef.exists) {
        log("DOES NOT EXIST. CREATE");
        _fdb.collection('users').document(email).setData({
          'token': 'some token'
        }).then((value) {
          log("tokenRef existance: ${userRef.exists}");
        });
        await _fdb.collection('users').document(email).collection('tokens').document(fcmToken).setData({
          'token': fcmToken
        });
      }
    }
  }

  void getAdminStatus() async {
    debugPrint("getAdminStatus() called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("username");
    await http.get("$baseUrl/user-records?email=$name").then((response) {
      var parse = jsonDecode(response.body);
      prefs.setString("role", parse["userRole"]);
      prefs.setString("leadId", parse["teamLeadId"]);
      prefs.setString("rfcId", parse["rfcId"]);
      prefs.setString("ethicsId", parse["ethicsId"]);
      prefs.setString("techLeadId", parse["techLeadId"]);
      prefs.setString("ethicsAssistantId", parse["ethicsAssistantId"]);
      prefs.setString("projectLeadId", parse["projectLeadId"]);
      prefs.setString("name", parse['name']);
    });
    role = prefs.getString("role") ?? "ROLE_USER";    // set user role to determine which dashboard they see. set to ROLE_USER as a default
    saveDeviceToken(name.toLowerCase());

    id = prefs.get("username");
    if (role == "ROLE_USER") {   // if role is user, get user reports
      studies.add("Studies you are enrolled in:");
      // if there's no internet connection or if data isn't found, show message
      try {
        http.get("$baseUrl/user/$name/studies-by-name").then((response) {
          debugPrint(response.body);
          debugPrint("${json.decode(response.body)}");
          var respList = json.decode(response.body);
          for (var i in respList) {
            setState(() {
              studies.add("• " + i.toString());
            });
          }
        });
      } on SocketException catch (e) {
        log("$e");
        debugPrintStack();
        studies.add("You are not currently enrolled in any studies. Contact your supervisor to be added to a study.");
      }
    } else if (role == "ROLE_TEAM_LEAD") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      http.get("$baseUrl/entry/lead-pending-reports?leadId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      http.get("$baseUrl/entry/lead-reviewed-reports?leadId=$id&leadAccepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
      // list of reports rejected by rfc
      http.get("$baseUrl/entry/lead-rfc-rejected-reports?leadId=$id&leadAccepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejectedByHigherUp = list;
        });
      });
    } else if (role == "ROLE_RFC") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      http.get("$baseUrl/entry/rfc-pending-reports?rfcId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      http.get("$baseUrl/entry/rfc-reviewed-reports?rfcId=$id&accepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
      // list of reports rejected by tech lead for rfc to review
      http.get("$baseUrl/entry/rfc-higherups-rejected-reports?rfcId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejectedByHigherUp = list;
        });
      });
      // list of reports rejected by rfc
      http.get("$baseUrl/entry/rfc-reviewed-reports?rfcId=$id&accepted=false").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejected = list;
        });
      });
    } else if (role == "ROLE_SATELLITE_LEAD") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      http.get("$baseUrl/entry/satellite-lead-pending-reports?satelliteId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      http.get("$baseUrl/entry/satellite-lead-reviewed-reports?satelliteId=$id&accepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
      // list of rejected reports BY HIGHER UPS
      http.get("$baseUrl/entry/satellite-lead-ethics-lead-rejected-reports?satelliteId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejectedByHigherUp = list;
        });
      });
      // list of reports rejected by satellite lead
      http.get("$baseUrl/entry/satellite-lead-reviewed-reports?satelliteId=$id&accepted=false").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejected = list;
        });
      });
    } else if (role == "ROLE_TECH_LEAD") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      http.get("$baseUrl/entry/tech-lead-pending-reports?techLeadId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      http.get("$baseUrl/entry/tech-lead-reviewed-reports?techLeadId=$id&accepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
      // list of rejected reports BY HIGHER UPS
      http.get("$baseUrl/entry/tech-lead-ethics-rejected-reports?techLeadId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejectedByHigherUp = list;
        });
      });
      // list of reports rejected by rfc
      http.get("$baseUrl/entry/tech-lead-reviewed-reports?techLeadId=$id&accepted=false").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejected = list;
        });
      });
    } else if (role == "ROLE_ETHICS_LEAD" || role == "ROLE_ETHICS_ASSISTANT") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      log("ethics url: $baseUrl/entry/ethics-pending-reports?ethicsId=$id");
      http.get("$baseUrl/entry/ethics-pending-reports?ethicsId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      log("ethics accepted reports url: $baseUrl/entry/ethics-reviewed-reports?ethicsId=$id&accepted=true");
      http.get("$baseUrl/entry/ethics-reviewed-reports?ethicsId=$id&accepted=true").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
      // list of rejected reports
      log("ethics rejected reports url: $baseUrl/entry/ethics-reviewed-reports?ethicsId=$id&accepted=false");
      http.get("$baseUrl/entry/ethics-reviewed-reports?ethicsId=$id&accepted=false").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejected = list;
        });
      });
      // list of reports sent to ethics lead/assistant from project lead
      http.get("$baseUrl/entry/ethics-reports-from-project-lead?ethicsId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          rejectedByHigherUp = list;
        });
      });
    } else if (role == "ROLE_PROJECT_LEAD") {  // else if role is lead, get reports with assigned lead of the current user
      // list of pending reports with current user assigned as lead
      http.get("$baseUrl/entry/project-lead-pending-reports?projLeadId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        // log(list.toString());
        setState(() {
          pending = list;
        });
      });
      // list of accepted reports
      http.get("$baseUrl/entry/project-lead-returned-reports?projLeadId=$id").then((value) {
        List<dynamic> list = json.decode(value.body);
        setState(() {
          approved = list;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Padding(
        // shrinkWrap: true,
          padding: EdgeInsets.only(left: 10, top: 30, right: 10),
          child: Container(
              height: 600,
              child: SingleChildScrollView(
                child: Container(
                  // height: 500,
                  child: new Column(
                    children: <Widget>[
                      (role == "ROLE_USER") ? showStudies() :
                      (role == "ROLE_RFC") ? showRFCReports() :
                      (role == "ROLE_ETHICS_LEAD" || role == "ROLE_ETHICS_ASSISTANT") ? showEthicsReports() :
                      (role == "ROLE_SATELLITE_LEAD") ? showSatelliteReports() :
                      (role == "ROLE_TEAM_LEAD") ? showLeadReports() :
                      (role == "ROLE_TECH_LEAD") ? showTechLeadReports():
                      (role == "ROLE_PROJECT_LEAD") ? showProjectLeadReports():
                      showStudies(),
                      dashboardContents(),
                      _buildButtons()
                      // Spacer()
                    ],
                  ),
                ),
              )
          )
      ),
      onRefresh: () async {
        getAdminStatus();
      }
    );
  }

  Widget showStudies() {
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

  Widget showProjectLeadReports() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("Project Lead Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${approved.length} ${approved.length == 1 ? "report has" : "reports have"} been returned to the ethics lead")
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
              title: Text("Review Returned Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ProjectLeadReportsList(true);
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ProjectLeadReportsList(false); // view reports not yet submitted and not rejected
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
        ]
    );
  }

  Widget showLeadReports() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
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
          if (rejectedByHigherUp.length > 0)
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.dangerous, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${rejectedByHigherUp.length} ${rejectedByHigherUp.length == 1 ? "report was" : "reports were"} rejected by the RFC")
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ReportsList(false, false); // view reports not yet submitted and not rejected
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Submitted Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ReportsList(true, false);  // view reports submitted and not rejected
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejectedByHigherUp.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Rejected Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return ReportsList(true, true); // view reports submitted, but rejected by higherups
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          )
        ]
    );
  }

  Widget showTechLeadReports() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
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
          if (rejected.length > 0)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.dangerous, color: Colors.white),
                  ),
                  Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                  Text("${rejected.length} ${rejected.length == 1 ? "report was" : "reports were"} rejected by you")
                ],
              ),
            ),
          if (rejectedByHigherUp.length > 0)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.dangerous, color: Colors.white),
                  ),
                  Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                  Text("${rejectedByHigherUp.length} ${rejectedByHigherUp.length == 1 ? "report was" : "reports were"} rejected by the ethics lead")
                ],
              ),
            ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TechLeadReportsList(false, false, false); // view reports not yet submitted and not rejected by rfc or tech lead
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Submitted Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TechLeadReportsList(true, false, false); // view reports that were submitted and NOT rejected by anyone
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejectedByHigherUp.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By Ethics Lead"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TechLeadReportsList(true, true, false); // view reports submitted, but rejected ONLY by higherups
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejected.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By You"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return TechLeadReportsList(false, false, true); // view reports not submitted, but rejected ONLY by tech lead
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          )
        ]
    );
  }

  Widget showRFCReports() {
    return Column(
      // shrinkWrap: true,
      children: <Widget>[
        Text("Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
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
        if (rejected.length > 0)
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.dangerous, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${rejected.length} ${rejected.length == 1 ? "report was" : "reports were"} rejected by you")
              ],
            ),
          ),
        if (rejectedByHigherUp.length > 0)
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.dangerous, color: Colors.white),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${rejectedByHigherUp.length} ${rejectedByHigherUp.length == 1 ? "report was" : "reports were"} rejected by the technical lead")
              ],
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return RfcReportsList(false, false, false); // view reports not yet submitted and not rejected by rfc or tech lead
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Submitted Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return RfcReportsList(true, false, false); // view reports that were submitted and NOT rejected by anyone
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejectedByHigherUp.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By Technical Lead"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return RfcReportsList(true, true, false); // view reports submitted, but rejected ONLY by higherups
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
        if (rejected.length > 0) Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text("Review Reports Rejected By You"),
            trailing: GestureDetector(
                child: Icon(Icons.chevron_right, color: Colors.grey)),
            onTap: () async {
              bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return RfcReportsList(false, false, true); // view reports submitted, but rejected ONLY by rfc
              }));
              if (result == true) {
                getAdminStatus();
              }
            },
          ),
        )
        ]
    );
  }

  Widget showSatelliteReports() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
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
          if (rejected.length > 0)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.dangerous, color: Colors.white),
                  ),
                  Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                  Text("${rejected.length} ${rejected.length == 1 ? "report was" : "reports were"} rejected by you")
                ],
              ),
            ),
          if (rejectedByHigherUp.length > 0)
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(Icons.dangerous, color: Colors.white),
                  ),
                  Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                  Text("${rejectedByHigherUp.length} ${rejectedByHigherUp.length == 1 ? "report was" : "reports were"} rejected by the technical lead")
                ],
              ),
            ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return SatelliteReportsList(false, false, false); // view reports not yet submitted and not rejected by rfc or tech lead
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Submitted Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return SatelliteReportsList(true, false, false); // view reports that were submitted and NOT rejected by anyone
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejectedByHigherUp.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By Technical Lead"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return SatelliteReportsList(true, true, false); // view reports submitted, but rejected ONLY by higherups
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejected.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By You"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return RfcReportsList(false, false, true); // view reports submitted, but rejected ONLY by rfc
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          )
        ]
    );
  }

  Widget showEthicsReports() {
    return Column(
      // shrinkWrap: true,
        children: <Widget>[
          Text("Reports Summary", textAlign: TextAlign.left, style: TextStyle(fontSize: 18)),
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
              title: Text("Review Pending Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return EthicsReportsList(false, false, false); // view reports not yet submitted and not rejected by rfc or tech lead
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Submitted Reports"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return EthicsReportsList(true, false, false); // view reports that were submitted and NOT rejected by anyone
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejected.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review Reports Rejected By You"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return EthicsReportsList(false, false, true); // view reports submitted, but rejected ONLY by ethics lead/assistant
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
          if (rejectedByHigherUp.length > 0) Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text("Review New Reports From Project Director"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return EthicsReportsList(true, true, false); // view reports submitted, but rejected ONLY by higherups
                }));
                if (result == true) {
                  getAdminStatus();
                }
              },
            ),
          ),
        ]
    );
  }

  Widget dashboardContents() {
    return Column(
      children: <Widget>[
        if (role == "ROLE_USER") Card(
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
              title: Text("Log out"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () => showAlertDialog(context)
          ),
        )
      ],
    );
  }

  void checkSyncStatus() async {
    db.getUnsyncedForms().then((value) async {
      syncToServerReqd = value.length > 0 ? true : false;
    });
  }
  Widget _buildButtons() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 40.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child: FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () {
                setState(() {
                  performSync();
                });
              },
              child: Text(
                dataIsLoading ? "Syncing..." : "Sync",
                style: TextStyle(
                    color: syncToServerReqd ? Colors.red : Color(0xFF6F35A5), fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: syncToServerReqd ? Colors.red : Color(0xFF6F35A5), width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ),
        ]
    );
  }


  copyLocalToRemote(DbForm i) {
    return {
      "id": i.id,
      "formName": i.form_name,
      "dateCreated": i.date_created,
      "dataContent": i.data_content,
      "dateUpdated": i.date_updated,
      "userLocation": i.user_location,
      "imeI": i.imei,
      "updatedBy": i.updated_by,
      "synced": true,
      "facility": i.facility,
      "dateInSurvey": i.dateOfSurvey,
      "initiator": i.initiator,
      "processType": i.processType,
      "submittedToTeamLead": i.submittedToTeamLead,
      "reviewedByLead": i.reviewedByLead,
      "leadAccepted": i.leadAccepted,
      "leadId": i.leadId,
      "reviewedByRfc": i.reviewedByRfc,
      "rfcAccepted": i.rfcAccepted,
      "rfcId": i.rfcId,
      "leadComments": i.leadComments,
      "rfcComments": i.rfcComments,
      "satelliteLeadId": i.satelliteLeadId,
      "reviewedBySatelliteLead": i.reviewedBySatelliteLead,
      "satelliteLeadAccepted": i.satelliteLeadAccepted,
      "satelliteLeadComments": i.satelliteLeadComments,
      "ethicsId": i.ethicsId,
      "reviewedByEthics": i.reviewedByEthics,
      "ethicsAccepted": i.ethicsAccepted,
      "ethicsComments": i.ethicsComments,
      "techLeadId": i.techLeadId,
      "reviewedByTechLead": i.reviewedByTechLead,
      "techLeadAccepted": i.techLeadAccepted,
      "techLeadComments": i.techLeadComments,
      "ethicsAssistantId": i.ethicsAssistantId,
      "reviewedByEthicsAssistant": i.reviewedByEthicsAssistant,
      "ethicsAssistantAccepted": i.ethicsAssistantAccepted,
      "ethicsAssistantComments": i.ethicsAssistantComments,
      "projectLeadId": i.projectLeadId,
      "reviewedByProjectLead": i.reviewedByProjectLead,
      "projectLeadReturned": i.projectLeadReturned,
      "projectLeadComments": i.projectLeadComments,
    };
  }

  duplicateToSynced(DbForm i) {
    return DbForm(
      id: i.id,
      form_name: i.form_name,
      data_content: i.data_content,
      date_created: i.date_created,
      date_updated: i.date_updated,
      updated_by: i.updated_by,
      user_location: i.user_location,
      imei: i.imei,
      synced: false,
      dateOfSurvey: i.dateOfSurvey,
      initiator: i.initiator,
      processType: i.processType,
      submittedToTeamLead: i.submittedToTeamLead,
      facility: i.facility,
      reviewedByLead: i.reviewedByLead,
      leadAccepted: i.leadAccepted,
      leadId: i.leadId,
      reviewedByRfc: i.reviewedByRfc,
      rfcAccepted: i.rfcAccepted,
      rfcId: i.rfcId,
      leadComments: i.leadComments,
      rfcComments: i.rfcComments,
      satelliteLeadId: i.satelliteLeadId,
      reviewedBySatelliteLead: i.reviewedBySatelliteLead,
      satelliteLeadAccepted: i.satelliteLeadAccepted,
      satelliteLeadComments: i.satelliteLeadComments,
      ethicsId: i.ethicsId,
      reviewedByEthics: i.reviewedByEthics,
      ethicsAccepted: i.ethicsAccepted,
      ethicsComments: i.ethicsComments,
      techLeadId: i.techLeadId,
      reviewedByTechLead: i.reviewedByTechLead,
      techLeadAccepted: i.techLeadAccepted,
      techLeadComments: i.techLeadComments,
      ethicsAssistantId: i.ethicsAssistantId,
      reviewedByEthicsAssistant: i.reviewedByEthicsAssistant,
      ethicsAssistantAccepted: i.ethicsAssistantAccepted,
      ethicsAssistantComments: i.ethicsAssistantComments,
      projectLeadId: i.projectLeadId,
      reviewedByProjectLead: i.reviewedByProjectLead,
      projectLeadReturned: i.projectLeadReturned,
      projectLeadComments: i.projectLeadComments,
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
