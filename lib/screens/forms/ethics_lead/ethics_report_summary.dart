import 'dart:convert';
import 'dart:typed_data';
import 'package:aims_mobile/screens/forms/rfc/rfc_reports_view.dart';
import 'package:aims_mobile/screens/forms/team_lead/reports_view.dart';
import 'package:flutter/cupertino.dart';

import 'package:aims_mobile/screens/forms/utils/json_schema.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:device_info/device_info.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'ethics_reports_view.dart';
class EthicsReportSummary extends StatefulWidget {
  EthicsReportSummary(this.template, this.formName, this.dbForm);
  final String formName;
  final DbForm dbForm;
  final FormTemplate template;

  @override
  State<StatefulWidget> createState() => _EthicsReportSummaryState(template, formName, dbForm);
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

class _EthicsReportSummaryState extends State<EthicsReportSummary> {
  String formName, role, processType;
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
  String hostUrl = "http://10.0.2.2:8080/api/v1";

  _EthicsReportSummaryState(this.template, this.formName, this.dbForm);

  @override
  void initState() {
    getInfo();
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
    converted = convertToStringList(jsonDecode(dbForm.data_content));
    super.initState();
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

  getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString("role");
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
      // body: Column(children: <Widget>[
      //     Container(
      //       margin: EdgeInsets.all(15.0),
      //       child: Text("Summary for $formName", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
      //     ),
      //     Expanded(
      //       child: generateSummary(), // ListView
      //
      //     ),
      //
      //     RaisedButton(
      //       onPressed: () {
      //         goToDetails();
      //       },
      //       child: Text("Review Form"),
      //     ),
      //     RaisedButton(
      //       onPressed: () {
      //         _showSubmitConfirmDialog();
      //       },
      //       child: Text("Generate PDF"),
      //     ),
      //     Container(
      //         child: TextField(
      //           decoration: InputDecoration(
      //               border: OutlineInputBorder(),
      //               hintText: 'Enter feedback here...',
      //               labelText: 'Feedback'
      //           ),
      //           maxLines: 10,
      //           controller: commentCtrl,
      //         )
      //     ),
      //     RaisedButton(
      //       onPressed: () {
      //         submitComment();
      //       },
      //       child: Text("Submit"),
      //     ),
      //   ]),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: Text("Summary for $formName", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ),
          generateSummary(),
          RaisedButton(
            onPressed: () {
              goToDetails();
            },
            child: Text("Review Form"),
          ),
          RaisedButton(
            onPressed: () {
              _showSubmitConfirmDialog();
            },
            child: Text("Generate PDF"),
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
    // return SingleChildScrollView(
    //   child: ListView(
    //     // shrinkWrap: true,
    //     children: <Widget>[
    //       ListTile(
    //         title: Text("Title: ${this.dbForm.facility}"),
    //       ),
    //       ListTile(
    //         title: Text("Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.dbForm.date_updated))} by ${dbForm.updated_by}"),
    //       ),
    //       ListTile(
    //         title: Text("Accepted: ${this.dbForm.ethicsAccepted == true ? "Yes" : "No"}"),
    //       ),
    //       ExpansionPanelList(
    //           expansionCallback: (int index, bool isExpanded) {
    //             setState(() {
    //               _data[index].isExpanded = !isExpanded;
    //             });
    //           },
    //           children: [
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[0].headerValue)
    //                   );
    //                 },
    //                 body: _data[0].expandedValue,
    //                 isExpanded: _data[0].isExpanded
    //             ),
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[1].headerValue)
    //                   );
    //                 },
    //                 isExpanded: _data[1].isExpanded,
    //                 body: _data[1].expandedValue
    //             ),
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[2].headerValue)
    //                   );
    //                 },
    //                 isExpanded: _data[2].isExpanded,
    //                 body: _data[2].expandedValue
    //             ),
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[3].headerValue)
    //                   );
    //                 },
    //                 isExpanded: _data[3].isExpanded,
    //                 body: _data[3].expandedValue
    //             ),
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[4].headerValue)
    //                   );
    //                 },
    //                 isExpanded: _data[4].isExpanded,
    //                 body: _data[4].expandedValue
    //             ),
    //             ExpansionPanel(
    //                 canTapOnHeader: true,
    //                 headerBuilder: (BuildContext context, bool isExpanded) {
    //                   return ListTile(
    //                       title: Text(_data[5].headerValue)
    //                   );
    //                 },
    //                 isExpanded: _data[5].isExpanded,
    //                 body: _data[5].expandedValue
    //             ),
    //           ]
    //       ),
    //       getRejectMessages()
    //     ]
    // ));
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
            title: Text("Accepted: ${this.dbForm.ethicsAccepted == true ? "Yes" : "No"}"),
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
          getRejectMessages()
        ]
    );
  }

  Widget getRejectMessages() {
    log("ethic assistant accepted: ${dbForm.ethicsAssistantAccepted}");
    log("role: $role");
    log('${dbForm.ethicsAssistantAccepted == false && role == "ROLE_ETHICS_LEAD"}');
    if (dbForm.ethicsAccepted == false && role == "ROLE_ETHICS_LEAD") {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Text("This report was rejected by you",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          textAlign: TextAlign.center,),
      );
    }
    if (dbForm.ethicsAccepted == false && role == "ROLE_ETHICS_ASSISTANT") {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Text("This report was rejected by the ethics lead", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
      );
    }
    if (dbForm.ethicsAssistantAccepted == false && role == "ROLE_ETHICS_LEAD") {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Text("This report was rejected by the ethics assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,),
      );
    }
    if (dbForm.ethicsAssistantAccepted == false && role == "ROLE_ETHICS_ASSISTANT") {
      return Container(
        margin: EdgeInsets.all(15.0),
        child: Text("This report was rejected by you", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0), textAlign: TextAlign.center,));
    }
    return Container();
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
      // return ReportsView(this.template.firstWhere((element) => element.form_name == this.clusters[index].form_name), this.clusters[index]);
      // return ReportSummary(this.clusters[index].form_name, this.clusters[index]);
      return EthicsReportsView(this.template, this.dbForm);
    }));
    if (result == true) {
      dbForm = await db.getFormById(dbForm.id);
      setState(() {
        generateItems();
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
    if (role == "ROLE_ETHICS_LEAD") {
      if (ethicsFormComments.length == 0) {
        List<String> tempList = <String>[commentCtrl.text];
        var temp = jsonEncode(tempList);
        commentToStore = temp;
      } else {
        debugPrint("${jsonDecode(dbForm.ethicsComments)}");
        ethicsFormComments.add(commentCtrl.text);
        debugPrint("${ethicsFormComments.toString()}");
        commentToStore = jsonEncode(ethicsFormComments);
      }
      updateComments(commentToStore, true);
    } else if (role == "ROLE_ETHICS_ASSISTANT") {
      if (ethicsAssistantComments.length == 0) {
        List<String> tempList = <String>[commentCtrl.text];
        var temp = jsonEncode(tempList);
        commentToStore = temp;
      } else {
        debugPrint("${jsonDecode(dbForm.ethicsAssistantComments)}");
        ethicsAssistantComments.add(commentCtrl.text);
        debugPrint("${ethicsAssistantComments.toString()}");
        commentToStore = jsonEncode(ethicsAssistantComments);
      }
      updateComments(commentToStore, true);
    }
  }

  void deleteComment(int index) {
    debugPrint("deleteComment(int) called");
    if (role == "ROLE_ETHICS_LEAD") {
      ethicsFormComments.removeAt(index);
      debugPrint("comments after removal: ${jsonEncode(ethicsFormComments)}");

      updateComments(jsonEncode(ethicsFormComments), false);
    } else if (role == "ROLE_ETHICS_ASSISTANT") {
      ethicsAssistantComments.removeAt(index);
      debugPrint("comments after removal: ${jsonEncode(ethicsAssistantComments)}");

      updateComments(jsonEncode(ethicsAssistantComments), false);
    }
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
      "submittedToTeamLead": dbForm.submittedToTeamLead,
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
      "techLeadId": dbForm.techLeadId,
      "reviewedByTechLead": dbForm.reviewedByTechLead,
      "techLeadAccepted": dbForm.techLeadAccepted,
      "techLeadComments": dbForm.techLeadComments,
      "ethicsId": dbForm.ethicsId,
      "reviewedByEthics": dbForm.reviewedByEthics,
      "ethicsAccepted": dbForm.ethicsAccepted,
      "ethicsComments": role == "ROLE_ETHICS_LEAD"?newComments:dbForm.ethicsComments,
      "ethicsAssistantId": dbForm.ethicsAssistantId,
      "reviewedByEthicsAssistant": dbForm.reviewedByEthicsAssistant,
      "ethicsAssistantAccepted": dbForm.ethicsAssistantAccepted,
      "ethicsAssistantComments": role == "ROLE_ETHICS_ASSISTANT"?newComments:dbForm.ethicsAssistantComments,
      "projectLeadId": dbForm.projectLeadId,
      "reviewedByProjectLead": dbForm.reviewedByProjectLead,
      "projectLeadReturned": dbForm.projectLeadReturned,
      "projectLeadComments": dbForm.projectLeadComments,
    });
    var response = await http.put("$hostUrl/entry/${dbForm.id}", body: body, headers: {"Content-Type": "application/json"});
    debugPrint("status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      // save to db
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
        ethicsComments: role == "ROLE_ETHICS_LEAD"?newComments:dbForm.ethicsComments,
        techLeadId: dbForm.techLeadId,
        reviewedByTechLead: dbForm.reviewedByTechLead,
        techLeadAccepted: dbForm.techLeadAccepted,
        techLeadComments: dbForm.techLeadComments,
        submittedToTeamLead: dbForm.submittedToTeamLead,
        ethicsAssistantId: dbForm.ethicsAssistantId,
        reviewedByEthicsAssistant: dbForm.reviewedByEthicsAssistant,
        ethicsAssistantAccepted: dbForm.ethicsAssistantAccepted,
        ethicsAssistantComments: role == "ROLE_ETHICS_ASSISTANT"?newComments:dbForm.ethicsAssistantComments,
        projectLeadId: dbForm.projectLeadId,
        reviewedByProjectLead: dbForm.reviewedByProjectLead,
        projectLeadReturned: dbForm.projectLeadReturned,
        projectLeadComments: dbForm.projectLeadComments,
      );
      int result = await db.updateForm(form);
      if (result != 0) {
        // update comment list and clear comment box
        setState(() {
          if (role == "ROLE_ETHICS_LEAD") {
            ethicsFormComments = jsonDecode(jsonDecode(response.body)["ethicsComments"]).cast<String>();
          } else if (role == "ROLE_ETHICS_ASSISTANT") {
            ethicsAssistantComments = jsonDecode(jsonDecode(response.body)["ethicsAssistantComments"]).cast<String>();
          }
          _data = generateItems();
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

  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    // zamphia png
    page.graphics.drawImage(
        PdfBitmap(await _readImageData('assets/Picture1.png')),
        Rect.fromLTWH(70, 0, 360, 226));

    // divider
    page.graphics.drawRectangle(
      pen: PdfPen(PdfColor(128,128,128)),
      brush: PdfSolidBrush(PdfColor(160,160,160)),
      bounds: Rect.fromLTWH(0, 250, page.getClientSize().width, 25)
    );

    // summary/preamble
    String preamble = createPdfSectionString(-1);
    final PdfLayoutResult layoutResult = PdfTextElement(
        text: preamble,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfSolidBrush(PdfColor(160,160,160))).draw(
        page: page,
        bounds: Rect.fromLTWH(0, 285, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    document.pages[document.pages.count - 1].graphics.drawLine(
        PdfPen(PdfColor(128,128,128)),
        Offset(0, layoutResult.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult.bounds.bottom + 10));

    document.pages[document.pages.count - 1].graphics.drawString("Incident Report", PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 25, page.getClientSize().width, page.getClientSize().height),);

    String sec0 = createPdfSectionString(0);
    final PdfLayoutResult layoutResult2 = PdfTextElement(
        text: sec0,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfSolidBrush(PdfColor(160,160,160))).draw(
        page: document.pages[document.pages.count - 1],
        bounds: Rect.fromLTWH(0, layoutResult.bounds.bottom + 50, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    document.pages[document.pages.count - 1].graphics.drawLine(
        PdfPen(PdfColor(128,128,128)),
        Offset(0, layoutResult2.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult2.bounds.bottom + 10));

    log("${layoutResult.bounds.bottom}");
    log("${layoutResult2.bounds.height}");
    log("${page.getClientSize().height}");

    document.pages[document.pages.count - 1].graphics.drawString("1. Description of Incident", PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, layoutResult2.bounds.bottom + 25, page.getClientSize().width, page.getClientSize().height),);

    String sec1 = createPdfSectionString(1);
    final PdfLayoutResult layoutResult3 = PdfTextElement(
        text: sec1,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfSolidBrush(PdfColor(160,160,160))).draw(
        page: document.pages[document.pages.count - 1],
        bounds: Rect.fromLTWH(0, layoutResult2.bounds.bottom + 50, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));

    document.pages[document.pages.count - 1].graphics.drawLine(
        PdfPen(PdfColor(128,128,128)),
        Offset(0, layoutResult3.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult3.bounds.bottom + 10));

    document.pages[document.pages.count - 1].graphics.drawString("2. Incident Cause and Corrective/Preventive Actions", PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, layoutResult3.bounds.bottom + 25, page.getClientSize().width, page.getClientSize().height),);
    String sec2 = createPdfSectionString(2);
    final PdfLayoutResult layoutResult4 = PdfTextElement(
        text: sec2,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfSolidBrush(PdfColor(160,160,160))).draw(
        page: document.pages[document.pages.count - 1],
        bounds: Rect.fromLTWH(0, layoutResult3.bounds.bottom + 50, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    document.pages[document.pages.count - 1].graphics.drawLine(
        PdfPen(PdfColor(128,128,128)),
        Offset(0, layoutResult4.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult4.bounds.bottom + 10));

    document.pages[document.pages.count - 1].graphics.drawString("3. Supervisor Review and Incident Referral", PdfStandardFont(PdfFontFamily.timesRoman, 16, style: PdfFontStyle.bold),
      bounds: Rect.fromLTWH(0, layoutResult4.bounds.bottom + 25, page.getClientSize().width, page.getClientSize().height),);
    String sec3 = createPdfSectionString(3);
    final PdfLayoutResult layoutResult5 = PdfTextElement(
        text: sec3,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfSolidBrush(PdfColor(160,160,160))).draw(
        page: document.pages[document.pages.count - 1],
        bounds: Rect.fromLTWH(0, layoutResult4.bounds.bottom + 50, page.getClientSize().width, page.getClientSize().height),
        format: PdfLayoutFormat(layoutType: PdfLayoutType.paginate));
    document.pages[document.pages.count - 1].graphics.drawLine(
        PdfPen(PdfColor(128,128,128)),
        Offset(0, layoutResult5.bounds.bottom + 10),
        Offset(page.getClientSize().width, layoutResult5.bounds.bottom + 10));

    List<int> bytes = document.save();
    document.dispose();

    DateTime now = DateTime.now();

    saveAndLaunchFile(bytes, '${now.year}-${now.month}-${now.day}-${dbForm.facility}-Incident.pdf');
  }

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final path = (await getExternalStorageDirectory()).path;
    final file = File('$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');
  }

  void _showSubmitConfirmDialog() {
    AlertDialog dialog = AlertDialog(
      content: Text('Are you sure you want to generate a PDF of this report?'),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(false);
            _createPDF();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog, barrierDismissible: false);
  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  List<String> converted = <String>[];
  // List<PdfItem> items = <PdfItem>[];
  Map<int, List<PdfItem>> items = new Map<int, List<PdfItem>>();
  // converts items in rawDecoded to String types
  List<String> convertToStringList(dynamic rawDecoded) {
    List<String> listStr = <String>[];
    int index = 0;  // corresponds to form section nums
    for (var s in rawDecoded) {
      listStr.add(s);
      var temp = jsonDecode(s)['fields'];
      List<PdfItem> tempItems = <PdfItem>[];
      for (var str in temp) {
        tempItems.add(PdfItem(str['label'], (str['value'] == null) ? "" : "${str['value']}", str['type'] == "Checkbox"));
      }
      items[index] = tempItems;
      index++;
    }
    return listStr;
  }

  String createPdfSectionString(int key) {
    log("createPdfSectionString($key) called");
    // if key is set to -1, then get the first half of basic info
    bool firstHalfOfBasicInfo = key == -1;
    List<PdfItem> section = items[key == -1 ? 0 : key];
    String tempStr = "", ans = "";
    int count = 0;
    for (PdfItem i in section) {
      // split basic info into different pdf sections
      if (count < 10 && key == 0) {
        count++;
        continue;
      }
      if (count >= 10 && firstHalfOfBasicInfo) {
        break;
      }
      if (i.hasMultipleAnswers) { // if this is a checkbox question, extract selected values
        ans = "";
        if (i.answer == null || i.answer == "") {
          ans = "None specified";
        } else {
          var decodedAnswers = jsonDecode(i.answer);
          for (var j in decodedAnswers) {
            ans += j + "\n";
          }
        }
      } else {
        ans = i.answer;
      }
      tempStr += i.question + "\n" + ans + "\n\n";
    }
    return tempStr;
  }
}

class PdfItem {
  final String question;
  final String answer;
  final bool hasMultipleAnswers;

  PdfItem(this.question, this.answer, this.hasMultipleAnswers);
}