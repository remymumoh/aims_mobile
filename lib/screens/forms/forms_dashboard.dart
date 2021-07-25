import 'dart:convert';
import 'dart:developer';
import 'package:aims_mobile/screens/forms/form_list.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:aims_mobile/utils/database/mobile.dart' as mobile;

class FormsDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FormsDashboardState();
  }
}

class FormsDashboardState extends State {
  List<String> formNames = <String>[];
  String formStr = "", formSecStr = "";
  // final String formTemplateUri = "http://10.0.2.2:8080/api/v1/form-templates";
  final String formTemplateUri = "http://10.0.2.2:8080/api/v1/form-templates";
  List<String> formInputs = <String>[];
  String syncMessage = "Everything's up to date";
  bool syncInProgress = false;
  String email = "";
  String hostUrl = "http://10.0.2.2:8080/api/v1";

  @override
  void initState() {
    performSync();
    super.initState();
  }

  // FormsDatabase db;
  FormsDatabase db = FormsDatabase.getInstance();
  List<String> forms = <String>[];
  List<FormTemplate> templates, locals;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        title: Text("Forms"),
        // actions: <Widget>[],
      ),
      body: getFormList(),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xff392850),
        child: Row(
          children: <Widget>[
            Visibility(
                child: Padding(
                  child: SizedBox(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      height: 15.0,
                      width: 15.0),
                  padding: EdgeInsets.only(left: 15.0),
                ),
                visible: syncInProgress),
            Padding(
              child: Text(
                syncMessage,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(15.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFormList() {
    return RefreshIndicator(
      onRefresh: () async {
        performSync();
      },
      child: ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(this.templates[position].form_name),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return FormList(this.templates[position]);
                }));
              },
            ),
          );
        },
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
    String email = sharedPreferences.getString("username");
    // print("the username is" + email);
    try {
      var response = await http.get("$hostUrl/user/$email/studies");
      locals = await db.getFormTemplates();
      if(response.statusCode== 201){
        setState(() {
          templates = fromJson(jsonDecode(response.body));
          count = templates.length;
          // set local db to results
        });
      }else if(response.statusCode == 200){
          setState(() {
            templates = fromJson(jsonDecode(response.body));
            count = templates.length;
            // set local db to results
            for (FormTemplate f in templates) {
              if (!locals.contains(f)) {
                if (existsInLocalsById(f.id)) {
                  db.updateFormTemplate(f);
                } else {
                  db.insertFormTemplate(f);
                }
              }
            }
          });
      }

      // sync if connected to the internet
      bool successfulSync = await syncToServer() && await syncToDb();
      debugPrint("successfulSync is $successfulSync");
      return successfulSync;
    } on SocketException catch (e) {
      debugPrint("SOCKETEXCEPTION IN getFormTypes()");
      debugPrint(e.message);
      // if there's no internet, load templates from local storage
      locals = await db.getFormTemplates();
      setState(() {
        templates = locals;
        count = templates.length;
      });
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
    log("getting forms at: $hostUrl/entry?updatedBy=$email");
    var response = await http.get("$hostUrl/entry?updatedBy=$email");
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
    bool syncedSuccessfully = true;
    try {
      List<DbForm> futureList = await db.getUnsyncedForms();
      for (DbForm form in futureList) {
        // var url = formBaseUri + "/" + form.id;
        var url = "$hostUrl/entry/" + form.id;
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
            var post = await Dio().post("$hostUrl/entry",
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

  bool existsInLocalsById(String id) {
    for (FormTemplate temp in locals) {
      if (temp.id == id) {
        return true;
      }
    }
    return false;
  }

  List<FormTemplate> fromJson(dynamic data) {
    // debugPrint("fromJson(dynamic) called");
    List<FormTemplate> list = <FormTemplate>[];
    for (var i in data) {
      list.add(FormTemplate(
          id: i["id"],
          form_name: i["formName"],
          form_content: i["formContents"],
          form_sections: i["formSections"]));
    }
    return list;
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

  DbForm toDbForm(dynamic report) {
    return DbForm(
      id: report["id"],
      data_content: report["dataContent"],
      updated_by: report["updatedBy"],
      date_created: report["dateCreated"],
      date_updated: report["dateUpdated"],
      user_location: report["userLocation"],
      form_name: report["formName"],
      imei: report["imeI"],
      synced: report["synced"],
      facility: report["facility"],
      dateOfSurvey: report["dateOfSurvey"],
      initiator: report["initiator"],
      processType: report['processType'],
      reviewedByLead: report["reviewedByLead"],
      leadAccepted: report["leadAccepted"],
      leadId: report["leadId"],
      reviewedByRfc: report["reviewedByRfc"],
      rfcAccepted: report["rfcAccepted"],
      rfcId: report["rfcId"],
      leadComments: report["leadComments"],
      rfcComments: report["rfcComments"],
      satelliteLeadId: report["satelliteLeadId"],
      reviewedBySatelliteLead: report["reviewedBySatelliteLead"],
      satelliteLeadAccepted: report["satelliteLeadAccepted"],
      satelliteLeadComments: report["satelliteLeadComments"],
      ethicsId: report["ethicsId"],
      reviewedByEthics: report["reviewedByEthics"],
      ethicsAccepted: report["ethicsAccepted"],
      ethicsComments: report["ethicsComments"],
      techLeadId: report["techLeadId"],
      reviewedByTechLead: report["reviewedByTechLead"],
      techLeadAccepted: report["techLeadAccepted"],
      submittedToTeamLead: report["submittedToTeamLead"],
      techLeadComments: report["techLeadComments"],
      ethicsAssistantId: report["ethicsAssistantId"],
      reviewedByEthicsAssistant: report["reviewedByEthicsAssistant"],
      ethicsAssistantAccepted: report["ethicsAssistantAccepted"],
      ethicsAssistantComments: report["ethicsAssistantComments"],
      projectLeadId: report["projectLeadId"],
      reviewedByProjectLead: report["reviewedByProjectLead"],
      projectLeadReturned: report["projectLeadReturned"],
      projectLeadComments: report["projectLeadComments"],
    );
  }

  List<DbForm> dbFormFromJson(dynamic data) {
    debugPrint("fromJson(dynamic) called");
    List<DbForm> list = <DbForm>[];
    for (var i in data) {
      list.add(toDbForm(i));
    }
    return list;
  }
}
