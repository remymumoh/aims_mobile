import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aims_mobile/screens/forms/rfc/rfc_report_summary.dart';
import 'package:aims_mobile/screens/forms/supervisor/menu.dart';
import 'package:aims_mobile/screens/forms/team_lead/report_summary.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ethics_assistant_report_summary.dart';

class EthicsAssistantReportsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EthicsAssistantReportsListState();
}

class _EthicsAssistantReportsListState extends State<EthicsAssistantReportsList> {
  List<DbForm> clusters = new List<DbForm>();
  List <FormTemplate> template;
  List<FormTemplate> locals;
  String id = "";
  // FormsDatabase db;
 FormsDatabase db = FormsDatabase.getInstance();
  bool loading = false;
  int count = 0;

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
      var response = await http.get("http://10.0.2.2:8080/api/v1/entry?ethicsId=$id");
      // log(response.body);
      // log(jsonDecode(response.body));
      var list = json.decode(response.body);
      // var list = response.body;
      for (var i in list) {
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
          reviewedByLead: i["reviewedByLead"],
          leadAccepted: i["leadAccepted"],
          leadId: i["leadId"],
          reviewedByRfc: i["reviewedByRfc"],
          rfcAccepted: i["rfcAccepted"],
          rfcId: i["rfcId"],
          leadComments: i["leadComments"],
          rfcComments: i["rfcComments"],
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
          projectLeadComments: i["projectLeadComments"],
        );
        setState(() {
          clusters.add(temp);
        });
      }
    } on SocketException catch (e) {
      debugPrint("SOCKETEXCEPTION CLUSTERS");
      this.clusters = <DbForm>[];
      List<DbForm> incidents = await db.getAllForms();
      setState(() {
        this.clusters = incidents;
      });
    }
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("username");
  }

  void sync() async {
    bool upstreamSync = await performSyncToServer();
    // log("performSyncToServer result: $upstreamSync");
    if (upstreamSync) {
      bool downstreamSync = await performSyncToDb();
      if (downstreamSync) {
        getClusters();
        getTemplates();
      }
    }
  }

  getTemplates() async {
    debugPrint("getTemplates() called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String email = sharedPreferences.getString("username");
    print("the username is " + email);
    String studyUrl = "http://10.0.2.2:8080/api/v1/user/$email/studies";
    print("getting studies from: $studyUrl");
    try {
      var response = await http.get(studyUrl);
      log("response code: ${response.statusCode}");
      // log("response body is: ${response.body}");
      locals = await db.getFormTemplates();
      if (response.statusCode == 200) {
        setState(() {
          template = fromJson(jsonDecode(response.body));
          count = template.length;
          // set local db to results
          for (FormTemplate f in template) {
            if (!locals.contains(f)) {
              // check if locals has an item with that id
              // if yes, then the form needs to be updated
              // else, insert as new entity
              if (existsInLocalsById(f.id)) {
                db.updateFormTemplate(f);
              } else {
                db.insertFormTemplate(f);
              }
            }
          }
        });
      }
    } on SocketException catch (e) {
      debugPrint("SOCKETEXCEPTION IN getFormTypes()");
      debugPrint(e.message);
      // if there's no internet, load templates from local storage
      locals = await db.getFormTemplates();
      setState(() {
        template = locals;
        count = template.length;
      });
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

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  @override
  void initState() {
    getInfo();
    sync();
    super.initState();
  }

  // add unsynced forms from local storage to remote server
  Future<bool> performSyncToServer() async {
    debugPrint("performSyncToServer() called");
    bool success = true;

    // add unsynced reports in db to server
    // db.getUnsyncedForms().then((value) async {
    var value = await db.getUnsyncedForms();
    // log("value is null: ${value == null}");
    // log("value is empty: ${value.isEmpty}");
    if (value.isEmpty) {
      return true;
    }
    // log("VALUES LENGTH: ${value.length}");
    for (DbForm i in value) {
      String pendingUrl = "http://10.0.2.2:8080/api/v1/entry/${i.id}";
      debugPrint("GETTING SURVEY AT: $pendingUrl");
      var head = await http.head(pendingUrl);
      // if form exists in db, run http put request
      if (head.statusCode == 200) {
        // debugPrint("status code is 200");
        var put = await Dio().put(pendingUrl, data: {
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
          "submittedToTeamLead": i.submittedToTeamLead,
          "reviewedByLead": i.reviewedByLead,
          "leadAccepted": i.leadAccepted,
          "leadId": i.leadId,
          "reviewedByRfc": i.reviewedByRfc,
          "rfcAccepted": i.rfcAccepted,
          "rfcId": i.rfcId,
          "leadComments": i.leadComments,
          "rfcComments": i.rfcComments,
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
        });
        if (put.statusCode == 200) {
          debugPrint("RESOURCE UPDATE SUCCEEDED");
          DbForm synced = new DbForm(
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
          int result = await db.updateForm(synced);
          if (result == 0) {
            success = false;
            continue;
          }
        } else {  // if update to server was not successful, set success status to false, skip to next form
          debugPrint("RESOURCE UPDATE FAILED");
          success = false;
          continue;
        }
      } else {  // else, the form doesn't exist. so run post request
        var post = await Dio().post(pendingUrl, data: {
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
          "submittedToTeamLead": i.submittedToTeamLead,
          "reviewedByLead": i.reviewedByLead,
          "leadAccepted": i.leadAccepted,
          "leadId": i.leadId,
          "reviewedByRfc": i.reviewedByRfc,
          "rfcAccepted": i.rfcAccepted,
          "rfcId": i.rfcId,
          "leadComments": i.leadComments,
          "rfcComments": i.rfcComments,
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
        });
        if (post.statusCode != 201) { // if item failed to post, set success flag to false, skip to next form
          success = false;
          continue;
        } else {
          DbForm syncedLocal = new DbForm(
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
          int syncResult = await db.updateForm(syncedLocal);
          if (syncResult == 0) {  // if form wasn't synced successfully in local db, set sync status to false, skip to next form
            success = false;
            continue;
          }
        }
      }
    }
    return success;
  }

  // check server for any new forms submitted. newly submitted/updated forms should
  // be downloaded to app for team lead to review
  Future<bool> performSyncToDb() async {
    debugPrint("performSyncToDb() called");
    List<DbForm> reports = await db.getAllForms();
    List<String> ids = <String>[];
    // create a list of ids in the databases
    for (DbForm i in reports) {
      ids.add(i.id);
      // await db.deleteForm(i);
      // return false;
    }

    // get all reports with ethics's id
    var response = await http.get("http://10.0.2.2:8080/api/v1/entry?ethicsId=$id");
    // log("performSyncToDb url: http://10.0.2.2:8080/api/v1/entry?ethicsId=$id");
    // log("${jsonDecode(response.body)}");
    var serverReports = jsonDecode(response.body);
    for (var report in serverReports) {
      DbForm temp = new DbForm(
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
        reviewedByLead: report["reviewedByLead"],
        leadAccepted: report["leadAccepted"],
        leadId: report["leadId"],
        reviewedByRfc: report["reviewedByRfc"],
        rfcAccepted: report["rfcAccepted"],
        rfcId: report["rfcId"],
        leadComments: report["leadComments"],
        rfcComments: report["rfcComments"],
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

  Icon getApprovalIcon(int approve) {
    log("approval icon: $approve");
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
    log("approval color: $status");
    return status == 1 ? Colors.green : status == 2 ? Colors.red : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) { Future.delayed(Duration.zero, () => showLoadingDialog()); }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        title: Text("Ethics Assistant Review"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () async {
            sync();
            getClusters();
          },
          child: (clusters.length == 0)? Padding(padding: EdgeInsets.all(15.0), child: Text("There are no forms to review", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),):ListView.builder(
            itemCount: clusters.length,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  title: Text(this.clusters[position].form_name),
                  leading: CircleAvatar(
                    backgroundColor: getApprovalColor(this.clusters[position].ethicsAccepted == true ? 1 : this.clusters[position].ethicsAccepted == false ? 2 : 0),
                    child: getApprovalIcon(this.clusters[position].ethicsAccepted == true ? 1 : this.clusters[position].ethicsAccepted == false ? 2 : 0),
                  ),
                  subtitle: Text(
                      "Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.clusters[position].date_updated))} by ${this.clusters[position].updated_by}"),
                  trailing: GestureDetector(
                      child: Icon(Icons.chevron_right, color: Colors.grey)),
                  onTap: () {
                    goToSummary(position);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  goToSummary(int index) async {
    debugPrint("goToSummary() called");
    // log(template.toString());
    // template.forEach((element) {log(element.form_name);});
    log(this.clusters[index].form_name);
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      // return ReportsView(this.template.firstWhere((element) => element.form_name == this.clusters[index].form_name), this.clusters[index]);
      return EthicsAssistantReportSummary(this.template.firstWhere((element) => element.form_name == this.clusters[index].form_name), this.clusters[index].form_name, this.clusters[index]);
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