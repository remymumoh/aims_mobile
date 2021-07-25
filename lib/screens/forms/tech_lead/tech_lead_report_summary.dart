import 'dart:convert';
import 'package:aims_mobile/screens/forms/tech_lead/tech_lead_reports_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
class TechLeadReportSummary extends StatefulWidget {
  TechLeadReportSummary(this.template, this.formName, this.dbForm);
  final String formName;
  final DbForm dbForm;
  final FormTemplate template;

  @override
  State<StatefulWidget> createState() => _TechLeadReportSummaryState(template, formName, dbForm);
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  dynamic expandedValue;
  String headerValue;
  bool isExpanded;
}

class _TechLeadReportSummaryState extends State<TechLeadReportSummary> {
  String formName, processType;
  DbForm dbForm;
  FormTemplate template;
  List<String> rfcFormComments = <String>[],
      leadFormComments = <String>[],
      ethicsFormComments = <String>[],
      techFormComments = <String>[],
      projectLeadComments = <String>[],
      ethicsAssistantComments = <String>[],
      satelliteComments = <String>[];
  TextEditingController commentCtrl = TextEditingController();
  List<Item> _data;
  FormsDatabase db = FormsDatabase.getInstance();
  String fullName = "";
  String hostUrl = "http://10.0.2.2:8080/api/v1";

  _TechLeadReportSummaryState(this.template, this.formName, this.dbForm);

  @override
  void initState() {
    processType = dbForm.processType ?? "FIELD";
    rfcFormComments = (dbForm.rfcComments != null) ? jsonDecode(dbForm.rfcComments).cast<String>() : <String>[];
    leadFormComments = (dbForm.leadComments != null) ? jsonDecode(dbForm.leadComments).cast<String>() : <String>[];
    ethicsFormComments = (dbForm.ethicsComments != null) ? jsonDecode(dbForm.ethicsComments).cast<String>() : <String>[];
    if (processType == "FIELD") {
      techFormComments = (dbForm.techLeadComments != null) ? jsonDecode(dbForm.techLeadComments).cast<String>() : <String>[];
    } else if (processType == "LAB") {
      satelliteComments = (dbForm.satelliteLeadComments != null) ? jsonDecode(dbForm.satelliteLeadComments).cast<String>() : <String>[];
    }
    ethicsAssistantComments = (dbForm.ethicsAssistantComments != null) ? jsonDecode(dbForm.ethicsAssistantComments).cast<String>() : <String>[];
    projectLeadComments = (dbForm.projectLeadComments != null) ? jsonDecode(dbForm.projectLeadComments).cast<String>() : <String>[];
    _data = generateItems();
    getInfo();
    super.initState();
  }

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fullName = prefs.getString("name");
  }

  // generates collapsible panels for lead and rfc feedback
  List<Item> generateItems() {
    processType = dbForm.processType ?? "FIELD";
    List<String> titles = [
      "Team Lead Comments",
      "RFC Comments",
      if (processType == "FIELD") "Technical Lead Comments",
      if (processType == "LAB") "Satellite Lab Lead Comments",
      "Ethics Lead Comments",
      "Ethics Assistant Comments",
      "Project Lead Comments"
    ];

    List<dynamic> panels = [
      (leadFormComments.length > 0) ? getLeadCommentList() : Padding(child: Text("No comments from lead"), padding: EdgeInsets.all(15.0)),
      (rfcFormComments.length > 0) ? getRfcCommentList() : Padding(child: Text("No comments from RFC"), padding: EdgeInsets.all(15.0)),
      if (processType == "FIELD")
        (techFormComments.length > 0) ? getTechLeadCommentList() : Padding(child: Text("No comments from technical lead"), padding: EdgeInsets.all(15.0)),
      if (processType == "LAB")
        (satelliteComments.length > 0) ? getSatelliteLeadCommentList() : Padding(child: Text("No comments from technical lead"), padding: EdgeInsets.all(15.0)),
      (ethicsFormComments.length > 0) ? getEthicsCommentList() : Padding(child: Text("No comments from ethics lead"), padding: EdgeInsets.all(15.0),),
      (ethicsAssistantComments.length > 0) ? getEthicsAssistantCommentList() : Padding(child: Text("No comments from ethics assistant"), padding: EdgeInsets.all(15.0),),
      (projectLeadComments.length > 0) ? getProjectLeadCommentList() : Padding(child: Text("No comments from project lead"), padding: EdgeInsets.all(15.0)),
    ];
    return List.generate(titles.length, (int index) {
      return Item(
        headerValue: titles[index],
        expandedValue: panels[index],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Report Summary"),
        backgroundColor: Color(0xff392850),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: Text("Summary for $formName", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          generateSummary(),
          // if (formComments.length > 0) getLeadCommentList(),
          RaisedButton(
            onPressed: () {
              goToDetails();
            },
            child: Text("Review Form"),
          ),
          Container(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter feedback here...',
                    labelText: 'Feedback'
                ),
                maxLines: 10,
                controller: commentCtrl,
              )
          ),
          RaisedButton(
            onPressed: () {
              submitComment();
            },
            child: Text("Submit"),
          ),
        ]),
      ),
    );
  }

  Widget generateSummary() {
    return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text("Title: ${this.dbForm.facility}"),
          ),
          ListTile(
            title: Text("Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.dbForm.date_updated))} by ${dbForm.updated_by}"),
          ),
          ListTile(
            title: Text("Initiated by ${dbForm.initiator}"),
          ),
          ListTile(
            title: Text("Submission status: ${this.dbForm.rfcAccepted == true ? "Submitted by the RFC" : "Not Submitted"}"),
          ),
          ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _data[index].isExpanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[0].headerValue)
                      );
                    },
                    body: _data[0].expandedValue,
                    isExpanded: _data[0].isExpanded
                ),
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[1].headerValue)
                      );
                    },
                    isExpanded: _data[1].isExpanded,
                    body: _data[1].expandedValue
                ),
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[2].headerValue)
                      );
                    },
                    isExpanded: _data[2].isExpanded,
                    body: _data[2].expandedValue
                ),
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[3].headerValue)
                      );
                    },
                    isExpanded: _data[3].isExpanded,
                    body: _data[3].expandedValue
                ),
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[4].headerValue)
                      );
                    },
                    isExpanded: _data[4].isExpanded,
                    body: _data[4].expandedValue
                ),
                if (_data.length < 5)
                ExpansionPanel(
                    canTapOnHeader: true,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                          title: Text(_data[5].headerValue)
                      );
                    },
                    isExpanded: _data[5].isExpanded,
                    body: _data[5].expandedValue
                ),
              ]
          ),
          // if (dbForm.techLeadAccepted == false) Container(
          //   margin: EdgeInsets.all(15.0),
          //   child: Text("This report was rejected by you", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
          // ),
          if (dbForm.ethicsAccepted == false) Container(
            margin: EdgeInsets.all(15.0),
            child: Text("This report was rejected by the ethics lead", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
          )
        ]
    );
  }

  Widget getLeadCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: leadFormComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(leadFormComments[position]),
            subtitle: Text(dbForm.leadId),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                deleteComment(position);
              },
            ),
          ),
        );
      },
    );
  }

  Widget getRfcCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: rfcFormComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(rfcFormComments[position]),
            subtitle: Text(dbForm.rfcId),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                deleteComment(position);
              },
            ),
          ),
        );
      },
    );
  }

  void goToDetails() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return TechLeadReportsView(this.template, this.dbForm);
    }));
    log("popping back with value $result");
    if (result == true) {
      DbForm temp = await db.getFormById(dbForm.id);
      setState(() {
        dbForm = temp;
        _data = generateItems();
        generateSummary();
      });
    }
  }

  void submitComment() {
    debugPrint("submitComment() called");
    if (commentCtrl.text.isEmpty) {
      return;
    }
    // if there are no comments added, create a new list to store into db. else, add to decoded list and encode again
    String commentToStore = "";
    if (techFormComments.length == 0) {
      List<String> tempList = <String>[commentCtrl.text];
      var temp = jsonEncode(tempList);
      commentToStore = temp;
    } else {
      debugPrint("${jsonDecode(dbForm.rfcComments)}");
      techFormComments.add(commentCtrl.text);
      debugPrint("${techFormComments.toString()}");
      commentToStore = jsonEncode(techFormComments);
    }
    updateComments(commentToStore, true);
  }

  void deleteComment(int index) {
    techFormComments.removeAt(index);
    updateComments(jsonEncode(techFormComments), false);
  }

  void updateComments(String newComments, bool submitted) async {
    var body = jsonEncode({
      "id": dbForm.id,
      "formName": dbForm.form_name,
      "dateCreated": dbForm.date_created,
      "dataContent": dbForm.data_content,
      "dateUpdated": dbForm.date_updated,
      "userLocation": dbForm.user_location,
      "imeI": dbForm.imei,
      "updatedBy": dbForm.updated_by,
      "synced": "true",
      "facility": dbForm.facility,
      "dateInSurvey": dbForm.dateOfSurvey,
      "initiator": dbForm.initiator,
      "processType": dbForm.processType,
      "reviewedByLead": dbForm.reviewedByLead,
      "leadAccepted": dbForm.leadAccepted,
      "leadId": dbForm.leadId,
      "reviewedByRfc": dbForm.reviewedByRfc,
      "rfcAccepted": dbForm.rfcAccepted,
      "rfcId": dbForm.rfcId,
      "leadComments": dbForm.leadComments,
      "rfcComments": dbForm.rfcComments,
      "satelliteLeadId": dbForm.satelliteLeadId,
      "reviewedBySatelliteLead": dbForm.reviewedBySatelliteLead,
      "satelliteLeadAccepted": dbForm.satelliteLeadAccepted,
      "satelliteLeadComments": dbForm.satelliteLeadComments,
      "ethicsId": dbForm.ethicsId,
      "reviewedByEthics": dbForm.reviewedByEthics,
      "ethicsAccepted": dbForm.ethicsAccepted,
      "ethicsComments": dbForm.ethicsComments,
      "techLeadId": dbForm.techLeadId,
      "reviewedByTechLead": dbForm.reviewedByTechLead,
      "techLeadAccepted": dbForm.techLeadAccepted,
      "techLeadComments": newComments,
      "submittedToTeamLead": dbForm.submittedToTeamLead,
      "ethicsAssistantId": dbForm.ethicsAssistantId,
      "reviewedByEthicsAssistant": dbForm.reviewedByEthicsAssistant,
      "ethicsAssistantAccepted": dbForm.ethicsAssistantAccepted,
      "ethicsAssistantComments": dbForm.ethicsAssistantComments,
      "projectLeadId": dbForm.projectLeadId,
      "reviewedByProjectLead": dbForm.reviewedByProjectLead,
      "projectLeadReturned": dbForm.projectLeadReturned,
      "projectLeadComments": dbForm.projectLeadComments,
    });
    var response = await http.put("$hostUrl/entry/${dbForm.id}", body: body, headers: {"Content-Type": "application/json"});
    debugPrint("status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      var form = DbForm(
        id: dbForm.id,
        form_name: formName,
        data_content: dbForm.data_content,
        date_created: dbForm.date_created,
        date_updated: dbForm.date_updated,
        updated_by: dbForm.updated_by,
        user_location: dbForm.user_location,
        imei: dbForm.imei,
        synced: true,
        dateOfSurvey: dbForm.dateOfSurvey,
        facility: dbForm.facility,
        initiator: dbForm.initiator,
        processType: dbForm.processType,
        reviewedByLead: dbForm.reviewedByLead,
        leadAccepted: dbForm.reviewedByLead,
        leadId: dbForm.leadId,
        reviewedByRfc: dbForm.reviewedByRfc,
        rfcAccepted: dbForm.rfcAccepted,
        rfcId: dbForm.rfcId,
        leadComments: dbForm.leadComments,
        rfcComments: dbForm.rfcComments,
        satelliteLeadId: dbForm.satelliteLeadId,
        reviewedBySatelliteLead: dbForm.reviewedBySatelliteLead,
        satelliteLeadAccepted: dbForm.satelliteLeadAccepted,
        satelliteLeadComments: dbForm.satelliteLeadComments,
        ethicsId: dbForm.ethicsId,
        reviewedByEthics: dbForm.reviewedByEthics,
        ethicsAccepted: dbForm.ethicsAccepted,
        ethicsComments: dbForm.ethicsComments,
        techLeadId: dbForm.techLeadId,
        reviewedByTechLead: dbForm.reviewedByTechLead,
        techLeadAccepted: dbForm.techLeadAccepted,
        techLeadComments: newComments,
        submittedToTeamLead: dbForm.submittedToTeamLead,
        ethicsAssistantId: dbForm.ethicsAssistantId,
        reviewedByEthicsAssistant: dbForm.reviewedByEthicsAssistant,
        ethicsAssistantAccepted: dbForm.ethicsAssistantAccepted,
        ethicsAssistantComments: dbForm.ethicsAssistantComments,
        projectLeadId: dbForm.projectLeadId,
        reviewedByProjectLead: dbForm.reviewedByProjectLead,
        projectLeadReturned: dbForm.projectLeadReturned,
        projectLeadComments: dbForm.projectLeadComments,
      );
      int result = await db.updateForm(form);
      if (result != 0) {
        setState(() {
          dbForm = form;
          techFormComments = jsonDecode(jsonDecode(response.body)["techLeadComments"]).cast<String>();
          _data = generateItems();
          generateSummary();
          commentCtrl.clear();
        });

        final snackBar = SnackBar(
          content: Text('Your comment was ${submitted?"submitted":"deleted"}.'),
          action: SnackBarAction(
            label: 'Done',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text('Sorry, your comment could not be ${submitted ? "submitted" : "deleted"}. Please try again later.'),
          action: SnackBarAction(
            label: 'Done',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {  // show snackbar with fail message
      final snackBar = SnackBar(
        content: Text('Sorry, your comment could not be ${submitted ? "submitted" : "deleted"}. Please try again later.'),
        action: SnackBarAction(
          label: 'Done',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget getEthicsCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ethicsFormComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(ethicsFormComments[position]),
            subtitle: Text(dbForm.ethicsId),
          ),
        );
      },
    );
  }

  Widget getTechLeadCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: techFormComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(techFormComments[position]),
            subtitle: Text(dbForm.techLeadId),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                deleteComment(position);
              },
            ),
          ),
        );
      },
    );
  }

  Widget getProjectLeadCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: projectLeadComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(projectLeadComments[position]),
            subtitle: Text(dbForm.projectLeadId),
          ),
        );
      },
    );
  }

  Widget getEthicsAssistantCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ethicsAssistantComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(ethicsAssistantComments[position]),
            subtitle: Text(dbForm.ethicsAssistantId),
          ),
        );
      },
    );
  }

  Widget getSatelliteLeadCommentList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: satelliteComments.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 0.0,
          child: ListTile(
            title: Text(satelliteComments[position]),
            subtitle: Text(dbForm.satelliteLeadId),
          ),
        );
      },
    );
  }
}