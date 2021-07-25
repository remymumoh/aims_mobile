import 'dart:convert';
import 'package:aims_mobile/screens/forms/team_lead/reports_view.dart';
import 'package:flutter/cupertino.dart';

import 'package:aims_mobile/screens/forms/utils/json_schema.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:device_info/device_info.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'baisv_monitoring.dart';
class BaisvSummary extends StatefulWidget {
  BaisvSummary(this.template, this.formName, this.dbForm);
  final String formName;
  final DbForm dbForm;
  final FormTemplate template;

  @override
  State<StatefulWidget> createState() => _BaisvSummaryState(template, formName, dbForm);
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

class _BaisvSummaryState extends State<BaisvSummary> {
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

  _BaisvSummaryState(this.template, this.formName, this.dbForm);

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
    techFormComments = (dbForm.techLeadComments != null) ? jsonDecode(dbForm.techLeadComments).cast<String>() : <String>[];
    ethicsAssistantComments = (dbForm.ethicsAssistantComments != null) ? jsonDecode(dbForm.ethicsAssistantComments).cast<String>() : <String>[];
    projectLeadComments = (dbForm.projectLeadComments != null) ? jsonDecode(dbForm.projectLeadComments).cast<String>() : <String>[];
    _data = generateItems();
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
        ]),
      ),
    );
  }

  Widget generateSummary() {
    return ListView(
        shrinkWrap: true,
        children: <Widget>[
          ListTile(
            title: Text("Title: ${dbForm.facility}"),
          ),
          ListTile(
            title: Text("Updated on ${DateFormat.yMMMd("en_US").format(DateTime.parse(this.dbForm.date_updated))} by ${dbForm.updated_by}"),
          ),
          ListTile(
            title: Text("Initiated by ${dbForm.initiator}"),
          ),
          ListTile(
            title: Text("Submission status: ${this.dbForm.submittedToTeamLead == true ? "Submitted" : "Not submitted"}"),
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
          ),
        );
      },
    );
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

  void goToDetails() async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      // return ReportsView(this.template.firstWhere((element) => element.form_name == this.clusters[index].form_name), this.clusters[index]);
      // return ReportSummary(this.clusters[index].form_name, this.clusters[index]);
      return BaisMonitor(this.template, this.dbForm);
    }));
    if (result == true) {
      this.dbForm = await db.getFormById(dbForm.id);
      setState(() {
        generateSummary();
      });
    }
  }
}