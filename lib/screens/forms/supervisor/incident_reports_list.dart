import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aims_mobile/screens/forms/supervisor/menu.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'incident_report_view.dart';

class IncidentReportsList extends StatefulWidget {
  @override
  _IncidentReportsListState createState() => _IncidentReportsListState();
}

class _IncidentReportsListState extends State<IncidentReportsList> {
  List<IncidentReport> clusters = new List<IncidentReport>();
  FormTemplate template;
  String id = "";
  // FormsDatabase db;
  FormsDatabase db = FormsDatabase.getInstance();
  bool loading = false;

  List<FormTemplate> fromJson(dynamic data) {
    // debugPrint("fromJson(dynamic) called");
    List<FormTemplate> list = <FormTemplate>[];
    for (var i in data) {
      list.add(FormTemplate(id: i["id"], form_name: i["formName"], form_content: i["formContents"], form_sections: i["formSections"]));
    }
    return list;
  }

  void getClusters() async {
    debugPrint("list getClusters() called");
    this.clusters.clear();
    try {
      var response = await http.get('http://10.0.2.2:8080/api/v1/entry/pending-incidents');
      // debugPrint(response.body);
      var list = json.decode(response.body);
      for (var i in list) {
        IncidentReport temp = new IncidentReport(id: i["id"], dataContent: i["dataContent"], formName: i["formName"], updatedBy: i["updatedBy"],
            dateUpdated: i["dateUpdated"], dateCreated: i["dateCreated"], approved: i["approved"]);
        setState(() {
          clusters.add(temp);
        });
        // debugPrint("$temp");
      }
      // sync();
      // performSyncToDb();
      // debugPrint("${json.decode(response.body)}");
    } on SocketException catch (e) {
      debugPrint("SOCKETEXCEPTION CLUSTERS");
      this.clusters = <IncidentReport>[];
      List<IncidentReport> incidents = await db.getIncidentReports();
      setState(() {
        this.clusters = incidents;
      });
    }
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("key");
  }

  void sync() async {
    // syncs have to be done one at a time to avoid possible negation with async calls
    performSyncToServer().then((value) {
      log("performSyncToServer result: $value");
      if (value == true) {
        performSyncToDb().then((value) {
          log("performSyncToDb result: $value");
          if (value) {
            getClusters();
            getTemplate();
          }
        });
      }
    });
    // bool s = performSyncToServer();
    // log("performSyncToServer result: $s");
    // if (s) {
    //   performSyncToDb().then((value) {
    //     log("performSyncToDb result: $value");
    //     if (value) {
    //       getClusters();
    //       getTemplate();
    //     }
    //   });
    // }
  }

  getTemplate() async {
    debugPrint("getTemplate() called");
    List<String> list = <String>[];
    list.add("Incident Reports");
    try {
      var response = await http.get("http://10.0.2.2:8080/api/v1/form-templates?name=Incident Reports");
      template = fromJson(jsonDecode(response.body))[0];
      // add incident report template if it doesn't exist
      FormTemplate temp = await db.getTemplateByName("Incident Reports");
      if (temp == null) {
        await db.insertFormTemplate(template);
      }
      setState(() {
        loading = false;
      });
      if (response.statusCode != 200) {
        _showAlertDialog("Error", "There was an error. Your data could not be loaded");
      }
    } on SocketException catch (_) {
      // _showAlertDialog("Error", "You're offline");
      template = await db.getTemplateByName("Incident Reports");
      setState(() {
        loading = false;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void initState() {
    debugPrint("initState() called");
    sync();
    // getClusters();
    // getTemplate();
    // performSyncToDb();
    super.initState();
  }

  // add incident reports from server to local db and vice versa
  Future<bool> performSyncToServer() async {
    debugPrint("performSyncToServer() called");
    bool downstreamSync;
    // add unsynced incident reports in db to server
    // try {
      db.getUnsyncedIncidents().then((value) async {
        log("value is null: ${value == null}");
        log("value is empty: ${value.isEmpty}");
        if (value.isEmpty) {
          return true;
        }
        // log("GOT VALUES: $value");
        log("VALUES LENGTH: ${value.length}");
        for (IncidentReport i in value) {
          // log("$i");
          // debugPrint("id: ${i.id}");
          // String approveStr = i.approved == true ? "true" : "false";
          // debugPrint("approveStr: $approveStr");
          final String pendingUrl = "http://10.0.2.2:8080/api/v1/entry/pending-incidents/${i.id}";
          // debugPrint("GETTING SURVEY AT: $pendingUrl");
          var head = await http.head(pendingUrl);
          // if form exists in db, run http put request
          if (head.statusCode == 200) {
            // debugPrint("status code is 200");
            var put = await Dio().put(pendingUrl, data: {
              "id": i.id,
              "formName": i.formName,
              "dateCreated": i.dateCreated,
              "dateUpdated": i.dateUpdated,
              "updatedBy": i.updatedBy,
              "userLocation": i.userLocation,
              "imeI": i.imei,
              "dataContent": i.dataContent,
              "approved": i.approved,
            });
            if (put.statusCode == 200) {
              debugPrint("RESOURCE UPDATE SUCCEEDED");
              IncidentReport synced = new IncidentReport(
                  id: i.id,
                  formName: i.formName,
                  dateCreated: i.dateCreated,
                  dateUpdated: i.dateUpdated,
                  updatedBy: i.updatedBy,
                  userLocation: i.userLocation,
                  imei: i.imei,
                  dataContent: i.dataContent,
                  approved: i.approved,
                  synced: true
              );
              int result = await db.updateIndicentReport(synced);
              if (result == 0) {
                return false;
              }
            } else {
              debugPrint("RESOURCE UPDATE FAILED");
              return false;
            }
          } else {
            try {
              var post = await Dio().post(pendingUrl, data: {
                "id": i.id,
                "formName": i.formName,
                "dateCreated": i.dateCreated,
                "dateUpdated": i.dateUpdated,
                "updatedBy": i.updatedBy,
                "userLocation": i.userLocation,
                "imei": i.imei,
                "dataContent": i.dataContent,
                "approved": i.approved,
                "synced": true
              });
              if (post.statusCode != 201) {
                return false;
              } else {
                IncidentReport syncedLocal = new IncidentReport(
                    id: i.id,
                    formName: i.formName,
                    dateCreated: i.dateCreated,
                    dateUpdated: i.dateUpdated,
                    updatedBy: i.updatedBy,
                    userLocation: i.userLocation,
                    imei: i.imei,
                    dataContent: i.dataContent,
                    approved: i.approved,
                    synced: true
                );
                int syncResult = await db.updateIndicentReport(syncedLocal);
                if (syncResult == 0) {
                  return false;
                }
              }
            } on DioError catch (e) {
              debugPrint("SOCKETEXCEPTION: POSTING UNSYNCED ITEM");
              // debugPrint(e.message);
              return false;
            }
          }
        }
        // downstreamSync = await performSyncToDb();
        // return true && downstreamSync;
        return true;
      });
    // } on DioError catch (e) {  // if internet cuts out when syncing
    //   debugPrint("DIOERROR IN SYNCSERVER");
      // debugPrint(e.message);
      // return false;
    // }
    return true;
  }

  Future<bool> performSyncToDb() async {
    debugPrint("performSyncToDb() called");

    List<IncidentReport> incidents = await db.getIncidentReports();
    List<String> ids = <String>[];
    // create a list of ids in the database
    for (IncidentReport i in incidents) {
      ids.add(i.id);
    }
    log("forms in db:");
    incidents.forEach((e) => log("${e.id}, ${e.approved}"));
    var response = await http.get("http://10.0.2.2:8080/api/v1/entry/pending-incidents");
    // log("${jsonDecode(response.body)}");
    var serverIncidents = jsonDecode(response.body);
    for (var incident in serverIncidents) {
      IncidentReport temp = new IncidentReport(id: incident["id"], dataContent: incident["dataContent"], formName: incident["formName"], updatedBy: incident["updatedBy"],
        dateUpdated: incident["dateUpdated"], dateCreated: incident["dateCreated"], approved: incident["approved"]);
      log("contains ${temp.id}: ${ids.contains(temp.id)}");
      // if the local db does not contain an element from the server, check if its
      // id exists. if it does, then it needs an update. else, it's a new record
      if (!incidents.contains(temp)) {
        if (ids.contains(temp.id)) {
          await db.updateIndicentReport(temp);
        } else {
          await db.insertIndicentReport(temp);
        }
      }
    }
    return true;
  }

  Icon getApprovalIcon(int approve) {
    return approve == 1 ? Icon(
      Icons.check,
      color: Colors.white,
    ) : approve == 2 ? Icon(
      Icons.dangerous,
      color: Colors.white
    ) : Icon(
      Icons.error,
      color: Colors.white
    );
  }

  // return performance color
  Color getApprovalColor(int status) {
    return status == 1 ? Colors.green : status == 2 ? Colors.red : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) { Future.delayed(Duration.zero, () => showLoadingDialog()); }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        title: Text("Supervisor"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () async {
            sync();
            getClusters();
          },
          child: ListView.builder(
            itemCount: clusters.length,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  title: Text(this.clusters[position].formName),
                  leading: CircleAvatar(
                    backgroundColor: getApprovalColor(this.clusters[position].approved == true ? 1 : this.clusters[position].approved == false ? 2 : 0),
                    child: getApprovalIcon(this.clusters[position].approved == true ? 1 : this.clusters[position].approved == false ? 2 : 0),
                  ),
                  subtitle: Text(
                      "Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.clusters[position].dateUpdated))} by ${this.clusters[position].updatedBy}"),
                  trailing: GestureDetector(
                      child: Icon(Icons.chevron_right, color: Colors.grey)),
                  onTap: () {
                    debugPrint("Item tapped");
                    goToDetails(position);
                    // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    //   return IncidentReportView(this.template, this.clusters[position]);
                    // }));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  goToDetails(int index) async {
    debugPrint("goToDetails() called");
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return IncidentReportView(this.template, this.clusters[index]);
    }));
    if (result != null && result) {
      getClusters();
    }
  }

  void showLoadingDialog() {
    AlertDialog saveDialog =
    AlertDialog(content: Row(
      children: <Widget>[
        Padding(
          child: SizedBox(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
              ),
              height: 15.0,
              width: 15.0
          ),
          padding: EdgeInsets.only(left: 15.0),
        ),
        Padding(
          child: Text(
            "Loading...",
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(15.0),
        ),
      ],
    ));
    showDialog(context: context, builder: (_) => saveDialog);
  }
}
