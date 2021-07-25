import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:uuid/uuid.dart';

import 'package:shared_preferences/shared_preferences.dart';
class FormItem {
  FormItem({this.headerValue, this.isExpanded = false, this.form, this.index, this.visible});

  String headerValue;
  bool isExpanded;
  String form;
  int index;
  bool visible;
}
class ProjectLeadReportsView extends StatefulWidget {
  ProjectLeadReportsView(this.template, this.dbForm);
  final FormTemplate template;
  final DbForm dbForm;

  @override
  State<StatefulWidget> createState() => _ProjectLeadReportViewState(template, dbForm);
}

class FormDetails {
  FormDetails({this.headerValue, this.isExpanded = false, this.form, this.index});
  String headerValue;
  bool isExpanded;
  String form;
  int index;
}

class _ProjectLeadReportViewState extends State<ProjectLeadReportsView> {
  List<FormDetails> details = <FormDetails>[];
  List<String> sections = <String>[];
  FormTemplate template;
  DbForm dbForm;
  List<bool> validSections = <bool>[];
  List<dynamic> responses = <dynamic>[];
  bool formIsValid = false;
  int count = 0;
  bool saving = false;
  String username, ethicsLead;
  // String hostUrl = "http://10.0.2.2:8080/api/v1/";
  String hostUrl = "http://10.0.2.2:8080/api/v1/";
  // FormsDatabase db;
  FormsDatabase db = FormsDatabase.getInstance();
  bool approved;
  bool changesMade = false;
  DbForm form;
  // String data;
  List<FormItem> _data = <FormItem>[];
  num totalPtsPoss = 0, currentPts = 0;

  // for tracking responses
  List<int> validResponses = new List<int>();
  List<int> numQsPerSection = new List<int>();
  Firestore fdb = Firestore.instance;


  // copy used to display form, with or without hidden supervisor-only sections
  List<ExpansionPanel> schemaExpansions = <ExpansionPanel>[];
  List<int> hiddenIndices = <int>[];
  Map<int, num> scores = new Map<int, num>();
  num scorePercentage = 0;
  _ProjectLeadReportViewState(this.template, this.dbForm);

  sendSubmission() async {
    log("sendSubmission() called");

    var submission = {
      'submittedTo': ethicsLead,
      'submitter': dbForm.updated_by ?? username,
      'date': DateTime.now(),
      'submissionId': Uuid().v4()
    };
    QuerySnapshot deviceTokens = await fdb.collection('users').document(submission['submittedTo']).collection('tokens').getDocuments();
    log("${deviceTokens.documents.length} documents");
    if (deviceTokens.documents.length > 0) {
      await fdb.collection('submissions').document(deviceTokens.documents[0].data['token']).setData(submission);
      Navigator.pop(context);
      Navigator.pop(context);
      // UI kept crashing when a form rejected by a higher rank was resubmitted
      // because it kept going back too far? weird
      Navigator.pop(context, true);
      Navigator.pop(context, true);
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    sections = convertToStringList(jsonDecode(template.form_sections));
    // debugPrint("section length: ${sections.length}");
    // debugPrint("sections: ${sections}");
    _data = generateItems(sections.length, convertToStringList(jsonDecode(dbForm.data_content)), sections);
    // _parent = generateParentAndCommentItems();
    count = _data.length;
    for (int i = 0; i < count; i++) {
      validSections.add(dbForm.id != null ? true : false);
      this.responses.add(json.decode(_data[i].form));
    }
    getInfo();
    super.initState();
  }

  List<FormItem> generateItems(
      int numberOfItems, List<String> forms, List<String> formNames) {
    return List.generate(numberOfItems, (int index) {
      return FormItem(
          headerValue: formNames[index], form: forms[index], index: index);
    });
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    var response = await http.get("${hostUrl}user-records?email=${dbForm.updated_by}");
    var records = jsonDecode(response.body);
    log("$records");
    ethicsLead = records['ethicsId'];
    log("ethics lead: $ethicsLead");
    setState(() {
      approved = this.dbForm.projectLeadReturned;
    });
  }
  // converts items in rawDecoded to String types
  List<String> convertToStringList(dynamic rawDecoded) {
    List<String> listStr = <String>[];
    for (var s in rawDecoded) {
      listStr.add(s);
    }
    return listStr;
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

  Future<void> updateReport(
      String id,
      String formName,
      String dataContent,
      String dateCreated,
      String dateUpdated,
      String userLocation,
      String imeI,
      String updatedBy) async {
    String apiUrl = hostUrl + "entry";
    bool syncFailed = false;
    try {
      await Dio().put(apiUrl + "/" + id, data: {
        "id": id,
        "formName": formName,
        "dateCreated": dateCreated,
        "dataContent": dataContent,
        "dateUpdated": dateUpdated,
        "userLocation": userLocation,
        "imeI": imeI,
        "updatedBy": updatedBy,
        "synced": true,
        "facility": dbForm.facility,
        "dateInSurvey": dbForm.dateOfSurvey,
        "initiator": dbForm.initiator,
        "processType": dbForm.processType,
        "submittedToTeamLead": dbForm.submittedToTeamLead,
        "reviewedByLead": dbForm.leadAccepted,
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
        "techLeadComments": dbForm.techLeadComments,
        "ethicsAssistantId": dbForm.ethicsAssistantId,
        "reviewedByEthicsAssistant": dbForm.reviewedByEthicsAssistant,
        "ethicsAssistantAccepted": dbForm.ethicsAssistantAccepted,
        "ethicsAssistantComments": dbForm.ethicsAssistantComments,
        "projectLeadId": dbForm.projectLeadId,
        "reviewedByProjectLead": dbForm.reviewedByProjectLead,
        "projectLeadReturned": dbForm.projectLeadReturned,
        "projectLeadComments": dbForm.projectLeadComments,
      });
    } on DioError catch (e) {
      debugPrint("INCIDENT REPORT UPDATE FAILED");
      debugPrint(e.message);
      debugPrintStack();
      syncFailed = true;
    } finally {
      var form = DbForm(
        id: id,
        form_name: formName,
        data_content: dataContent,
        date_created: dateCreated,
        date_updated: dateUpdated,
        updated_by: updatedBy,
        user_location: userLocation,
        imei: imeI,
        synced: !syncFailed,
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
        techLeadComments: dbForm.techLeadComments,
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
      if (result != 0 && !syncFailed) {
        Navigator.pop(context);   // close saving dialog
        Navigator.pop(context, true);   // move back and set state
        _showAlertDialog("Success", "Your changes have been saved");
      } else if (result != 0 && syncFailed) {
        Navigator.pop(context);   // close saving dialog
        Navigator.pop(context, true);   // move back and set state
        _showAlertDialog("Success", "Your changes have been saved. However, it hasn't been synced with the online server");
      } else {
        Navigator.pop(context);   // close saving dialog
        Navigator.pop(context, false);   // move back but don't set state
        _showAlertDialog("Error", "Your changes could not be saved due to an error");
      }
      saving = false; // change save button back to "save"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Project Director Review Report"),
        backgroundColor: Color(0xff392850),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: getApprovalColor(approved == true ? 1 : approved == false ? 2 : 0),
                  child: getApprovalIcon(approved == true ? 1 : approved == false ? 2 : 0),
                ),
                Container(padding: EdgeInsets.only(left: 5.0, right: 15.0),),
                Text("${approved == true ?
                "You accepted this form and returned it to the ethics lead" : approved == false ?
                "You rejected this form" : "This form has not been reviewed yet"}")
              ],
            ),
          ),
          getFormPanel(),
          Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("Send Back to Ethics Lead", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          _showSubmitConfirmDialog(true);
                        },
                        color: Colors.green,
                      ),
                    ),
                  ]
              )
          ),
          Row(children: <Widget>[
            Expanded(
                child: RaisedButton(
                  child: Text(saving?"Saving Changes...":"Save Changes",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    updateForm();
                  },
                  color: Color(0xff392850),
                  disabledColor: Colors.grey,
                )),
          ]),
        ]),
      ),
    );
  }

  List<ExpansionPanel> getSchemas() {
    int value = 0;
    schemaExpansions = [];
    for (FormItem form in _data) {
      schemaExpansions.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(form.headerValue),
          );
        },
        body: new JsonSchema(
          form: form.form,
          onChanged: (dynamic response) {
            this.responses[form.index] = response;
            // isFormValid();
          },
          sectionIndex: value,
          currentPts: (num current, int index) {
            log("currentPts callback called with value: $current");
            setState(() {
              scores[index] = current;
              currentPts = _getCurrentFormScore();
              log("score is now: $currentPts/$totalPtsPoss");
              scorePercentage = (currentPts / totalPtsPoss) * 100;
              log("${scorePercentage.toStringAsFixed(2)}%");
            });
          },
          actionSave: (data) {
            print(data);
          },
          isValid: (valid) {
            // this.validSections[form.index] = valid;
          },
          ptsPoss: (num total, int index) {
            log("ptsPoss callback called with value: $total");
            totalPtsPoss += total;
            log("totalPtsPoss is now: $totalPtsPoss");
          },
          isSupervisor: true,
        ),
        isExpanded: form.isExpanded,
      ));
      value++;
    }
    // log("hidden indices: $hiddenIndices");
    return schemaExpansions;
  }

  ExpansionPanelList getFormPanel() {
    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _data[index].isExpanded = !isExpanded;
          });
        },
        children: getSchemas());
  }

  void isFormValid() {
    debugPrint("checkValid() called");
    for (bool b in validSections) {
      if (b == false) {
        setState(() {
          formIsValid = false;
        });
        return;
      }
    }
    setState(() {
      formIsValid = true;
    });
  }

  void updateForm() async {
    debugPrint("updateForm() called");
    saving = true;  // switch save button to display "saving..."
    isFormValid();
    _showSavingDialog();
    bool isAndroid = Platform.isAndroid;
    var position;
    var androidDeviceInfo;
    var deviceInfo;
    if (isAndroid) {
      deviceInfo = DeviceInfoPlugin();
      androidDeviceInfo = await deviceInfo.androidInfo;
      // position = await Geolocator.getCurrentPosition(
      //     desiredAccuracy: LocationAccuracy.high);
    }

    // create variables, then store in server
    String uuid = this.dbForm.id;
    final String id = uuid;
    final String formName = template.form_name;
    final String dateCreated = DateTime.now().toString();
    final String dateUpdated = DateTime.now().toString();
    final String dataContent = encodeResponse();
    final String updatedBy = username;
    final String userLocation = "";
    final String imeI = isAndroid ? androidDeviceInfo.androidId : "";

    await updateReport(id, formName, dataContent, dateCreated, dateUpdated, userLocation, imeI, updatedBy);
  }

  void _showSavingDialog() {
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
            "Saving...",
            style: TextStyle(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.all(15.0),
        ),
      ],
    ));
    showDialog(context: context, builder: (_) => saveDialog, barrierDismissible: false);
  }

  String encodeResponse() {
    List<String> strResp = <String>[];
    strResp.clear();
    for (var response in responses) {
      strResp.add(json.encode(response));
    }
    return jsonEncode(strResp);
  }

  num _getCurrentFormScore() {
    num currentScore = 0;
    this.scores.forEach((key, value) { /*log("scores[$key]: $value pts");*/ currentScore += value; });
    if (currentScore == currentScore.roundToDouble())
      return currentScore.truncate();
    return currentScore;
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> approveOrReject(bool status) async {
    debugPrint("approveOrReject(bool) called");
    _showSavingDialog();
    String resp = encodeResponse();
    bool successfullySynced = true;
    // if user tries setting status twice, then show dialog and exit early
    if (status == approved) {
      Navigator.pop(context);
      _showAlertDialog("No Changes", "This form's approval status is already set to ${status ? "accepted" : "rejected"}");
      return;
    }
    try {
      var body = jsonEncode({
        "id": dbForm.id,
        "formName": dbForm.form_name,
        "dateCreated": dbForm.date_created,
        "dataContent": resp,
        "dateUpdated": dbForm.date_updated,
        "userLocation": dbForm.user_location,
        "imeI": dbForm.imei,
        "updatedBy": dbForm.updated_by,
        "synced": successfullySynced.toString(),
        "initiator": dbForm.initiator,
        "processType": dbForm.processType,
        "dateOfSurvey": responses[0]['fields'][11]['value']!=null?DateTime.parse(responses[0]['fields'][11]['value']).toString():dbForm.dateOfSurvey,
        "facility": responses[0]['fields'][1]['value']??dbForm.facility,
        "reviewedByLead": "true",
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
        "ethicsId": ethicsLead,
        "reviewedByEthics": null,
        "ethicsAccepted": null,
        "ethicsComments": dbForm.ethicsComments,
        "techLeadId": dbForm.techLeadId,
        "reviewedByTechLead": dbForm.reviewedByTechLead,
        "techLeadAccepted": dbForm.techLeadAccepted,
        "techLeadComments": dbForm.techLeadComments,
        "submittedToTeamLead": dbForm.submittedToTeamLead,
        "ethicsAssistantId": dbForm.ethicsAssistantId,
        "reviewedByEthicsAssistant": null,
        "ethicsAssistantAccepted": null,
        "ethicsAssistantComments": dbForm.ethicsAssistantComments,
        "projectLeadId": dbForm.projectLeadId,
        "reviewedByProjectLead": dbForm.reviewedByProjectLead,
        "projectLeadReturned": "true",
        "projectLeadComments": dbForm.projectLeadComments,
      });
      var response = await http.put(hostUrl + "entry/${this.dbForm.id}", body: body, headers: {"Content-Type": "application/json"});
      if (response.statusCode != 200 && response.statusCode != 201) {
        successfullySynced = false;
      }
    } on SocketException catch (e) {
      successfullySynced = false;
    } finally {
      bool isAndroid = Platform.isAndroid;
      var position;
      var androidDeviceInfo;
      var deviceInfo;
      if (isAndroid) {
        deviceInfo = DeviceInfoPlugin();
        androidDeviceInfo = await deviceInfo.androidInfo;
        // position = await Geolocator.getCurrentPosition(
        //     desiredAccuracy: LocationAccuracy.high);
      }

      // create variables, then store in server
      String uuid = this.dbForm.id;
      final String id = uuid;
      final String formName = template.form_name;
      final String dateCreated = DateTime.now().toString();
      final String dateUpdated = DateTime.now().toString();
      final String dataContent = this.dbForm.data_content;
      final String updatedBy = username;
      final String userLocation = "";
      final String imeI = isAndroid ? androidDeviceInfo.androidId : "";
      DbForm newForm = DbForm(
        id: id,
        form_name: formName,
        data_content: dataContent,
        date_created: dateCreated,
        date_updated: dateUpdated,
        updated_by: updatedBy,
        user_location: userLocation,
        imei: imeI,
        synced: false,
        dateOfSurvey: dbForm.dateOfSurvey,
        initiator: dbForm.initiator,
        processType: dbForm.processType,
        facility: dbForm.facility,
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
        techLeadId: dbForm.techLeadId,
        reviewedByTechLead: dbForm.reviewedByTechLead,
        techLeadAccepted: dbForm.techLeadAccepted,
        techLeadComments: dbForm.techLeadComments,
        submittedToTeamLead: dbForm.submittedToTeamLead,
        ethicsId: ethicsLead,
        reviewedByEthics: null,
        ethicsAccepted: null,
        ethicsComments: dbForm.ethicsComments,
        ethicsAssistantId: dbForm.ethicsAssistantId,
        reviewedByEthicsAssistant: null,    // if form gets rejected, set review status of previous roles to null. else, leave it alone
        ethicsAssistantAccepted: null,
        ethicsAssistantComments: dbForm.ethicsAssistantComments,
        projectLeadId: dbForm.projectLeadId,
        reviewedByProjectLead: dbForm.reviewedByProjectLead,
        projectLeadReturned: true,
        projectLeadComments: dbForm.projectLeadComments,
      );
      int result = await db.updateForm(newForm);
      if (result != 0 && successfullySynced) {
        sendSubmission();
        _showAlertDialog("${status == true ? "Accepted" : status == false ? "Rejected" : "Undo Rejection"}",
            "This report${status == true ? " has been submitted to the project director" : status == false? " has been rejected": " is no longer rejected by you"}");
        setState(() {
          approved = status;
          dbForm = newForm;
        });
      } else if (result != 0 && !successfullySynced) {
        successfullySynced = false;
        Navigator.pop(context);
        Navigator.pop(context);
        _showAlertDialog("${status == true ? "Accepted" : status == false ? "Rejected" : "Undo Rejection"}",
            "This report${status == true ? " has been accepted" : status == false? " has been rejected": "'s rejection has been undone"} by you. However, these changes have not been saved to the PHIA server");
      } else {
        successfullySynced = false;
        Navigator.pop(context);
        Navigator.pop(context);
        _showAlertDialog("Error", "Your changes could not be saved due to an error. Please try again later");
      }
    }
  }

  void _showSubmitConfirmDialog(bool accept) {
    if (dbForm.projectLeadReturned == true) {
      AlertDialog dialog = AlertDialog(
        content: Text('This form has already been sent back to the ethics lead.'),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
      showDialog(context: context, builder: (_) => dialog, barrierDismissible: false);
    } else {
      AlertDialog dialog = AlertDialog(
        content: Text('Are you sure you want to accept this form and send it back to the ethics lead?'),
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
              approveOrReject(true);
            },
          ),
        ],
      );
      showDialog(context: context, builder: (_) => dialog, barrierDismissible: false);
    }
  }
}