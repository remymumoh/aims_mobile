import 'dart:convert';
import 'dart:developer';

import 'package:aims_mobile/screens/forms/initiator/baisv_summary.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'initiator/baisv_monitoring.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aims_mobile/locator.dart';

class FormList extends StatefulWidget {
  final FormTemplate template;
  FormList(this.template);
  @override
  State<StatefulWidget> createState() {
    return FormListState(this.template);
  }
}

class FormListState extends State {
  String hostUrl = "http://10.0.2.2:8080/api/v1";

  FormsDatabase db = FormsDatabase.getInstance();
  Firestore fdb = Firestore.instance;
  List<DbForm> dbForms;
  // List<BaisJsonContentData> savedForms;
  List<String> formNames = <String>[];
  final FormTemplate template;
  String formStr = "", formSecStr = "";
  var decodedForms;

  // final PushNotificationService _pushNotificationService = locator<PushNotificationService>();

  FormListState(this.template);
  int count = 0;

  // Future handleStartUpLogic() async {
  //   _pushNotificationService.initialize();
  // }
  @override
  Widget build(BuildContext context) {
    if (dbForms == null) {
      dbForms = new List<DbForm>();
      // newForms = new List<NewForm>();
      setForms();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        title: Text(this.template.form_name),
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff392850),
        onPressed: () {
          goToDetails(false);
        },
        tooltip: "Add new form data",
        child: Icon(Icons.add),
      ),
    );
  }

  void goToDetails(bool exists, [int index]) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      // if the form does not exist in the db, it's a new entry, so pass predefined strings
      if (!exists) {
        return BaisMonitor(this.template, new DbForm(id: null, form_name: this.template.form_name, data_content: this.template.form_content, section_names: this.template.form_sections), false);
      }
      // if 'exists' is true, the form exists in the db, so access the saved data instead
      // return BaisMonitor(this.template, dbForms[index]);
      // FIXME if this is zamphia, go to the summary screen. else edit forms normally
      if (template.form_name == "ZAMPHIA Incident Report") {
        return BaisvSummary(template, template.form_name, dbForms[index]);
      } else {
        return BaisMonitor(this.template, dbForms[index], true);
      }
    }));
    // if the result's not null (user hits back button) and if it's true (save
    // succeeded), then update the UI
    if (result != null && result) {
      setForms();
    }
  }

  void setForms() async {
    if (!kIsWeb) {
      // db = mobile.constructDb();
      db = FormsDatabase.getInstance();
      if(db !=null){
        Future<List<DbForm>> list = db.getFormByName(this.template.form_name);
        list.then((value) {
          setState(() {
            this.dbForms = value;
            this.count = value.length;
          });
        });
      }else if(db ==null || db != null){
        debugPrint("setForms() async called");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String name = prefs.getString("username");
        debugPrint("FormTypes() called ${this.template.form_name}");
        debugPrint("getting forms from $hostUrl/entry?initiator=$name&formName=${this.template.form_name}");
        var response = await http.get("$hostUrl/entry?initiator=$name&formName=${this.template.form_name}");
        if (response.statusCode == 200) {
          setState(() {
            dbForms = fromJson(jsonDecode(response.body));
            count = dbForms.length;
            log("templates is now:");
            dbForms.forEach((element) {log("${element.id}, ${element.form_name}, ${element.facility}");});
          });
        }
      }
    }
  }

  Widget getListView() {
    if (count > 0) {
      return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(this.dbForms[position].facility ?? "No Title"),
              subtitle: Text(
                  "Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.dbForms[position].date_updated))}"),
              trailing: GestureDetector(
                  child: Icon(Icons.chevron_right, color: Colors.grey)),
              onTap: () {
                goToDetails(true, position);
              },
            ),
          );
        },
      );
    } else {
      return Center(
        child: Container(
          width: 500.0,
          padding: EdgeInsets.all(15.0),
          child: Text("No forms have been completed. Your forms will appear here as you complete them.", textAlign: TextAlign.center, textScaleFactor: 2.0)
        )
      );
    }
  }
  List<DbForm> fromJson(dynamic data) {
    List<DbForm> list = <DbForm>[];
    for (var i in data) {
      list.add(DbForm(
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
        projectLeadComments: i["projectLeadComments"],));
    }
    return list;

  }
}
