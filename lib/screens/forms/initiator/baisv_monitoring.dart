import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform, SocketException;
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:aims_mobile/screens/forms/utils/json_schema.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';

class FormItem {
  FormItem({this.headerValue, this.isExpanded = false, this.form, this.index, this.visible});

  String headerValue;
  bool isExpanded;
  String form;
  int index;
  bool visible;
}

// ignore: must_be_immutable
class BaisMonitor extends StatefulWidget {
  BaisMonitor(this.template, this.dbForm, this.exists);

  FormTemplate template;
  DbForm dbForm;
  bool exists;

  @override
  _BaisMonitorState createState() =>
      _BaisMonitorState(this.template, this.dbForm, this.exists);
}

List<FormItem> generateItems(
    int numberOfItems, List<String> forms, List<String> formNames) {
  return List.generate(numberOfItems, (int index) {
    return FormItem(
        headerValue: formNames[index], form: forms[index], index: index);
  });
}

class _BaisMonitorState extends State<BaisMonitor> {
  String hostUrl = "http://10.0.2.2:8080/api/v1/";
  // String hostUrl = "http://10.0.2.2:8080/api/v1/";
  //http://10.0.2.2:8080

  String token = "";
  String username = "", processType = "";
  bool isSupervisor = false, leadReviewed = false;
  String facilityName = "", userRole = "", leadId = "", rfcId = "", ethicsId = "",
      techLeadId = "", ethicsAssistantId = "", projectLeadId = "", satelliteLeadId = "";
  num totalPtsPoss = 0 , currentPts = 0;
  DateTime date = DateTime.now();
  bool isIncidentReport = false;
  Firestore fdb = Firestore.instance;

  sendSubmission() async {
    log("sendSubmission() called");

    var submission = {
      'submittedTo': leadId,
      'submitter': username,
      'date': DateTime.now(),
      'submissionId': Uuid().v4()
    };
    log("$submission");
    QuerySnapshot deviceToken = await fdb.collection('users').document(submission['submittedTo']).collection('tokens').getDocuments();
    log("${deviceToken.documents.length} documents");
    if (deviceToken.documents.length > 0) {
      await fdb.collection('submissions').document(deviceToken.documents[0].data['token']).setData(submission);
    }
  }

  @override
  void initState() {
    _addColors();
    super.initState();
    getToken();
  }

  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  List<Widget> _strokeColorWidgets;
  List<Color> _strokeColors = <Color>[];
  int _selectedPenIndex = 0;


  bool _isDark = false;
  bool _isSigned = false;
  Uint8List _signatureData;
  double _fontSizeRegular = 12;
  Color _backgroundColor;
  double _minWidth = 1.0;
  double _maxWidth = 4.0;
  Color _strokeColor;


  void _handleClearButtonPressed() {
    _signaturePadKey.currentState.clear();
    _isSigned = false;
  }

  void _handleOnSignStart() {
    _isSigned = true;
  }

  void _addColors() {
    _strokeColors = <Color>[];
    _strokeColors.add(const Color.fromRGBO(0, 0, 0, 1));
    _strokeColors.add(const Color.fromRGBO(35, 93, 217, 1));
    _strokeColors.add(const Color.fromRGBO(77, 180, 36, 1));
    _strokeColors.add(const Color.fromRGBO(228, 77, 49, 1));
  }

  List<Widget> _addStrokeColorPalettes(StateSetter stateChanged) {
    _strokeColorWidgets = <Widget>[];
    for (int i = 0; i < _strokeColors.length; i++) {
      _strokeColorWidgets.add(
        Material(
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: InkWell(
                onTap: () => stateChanged(
                      () {
                    _strokeColor = _strokeColors[i];
                    _selectedPenIndex = i;
                  },
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Icon(Icons.brightness_1,
                          size: 25.0, color: _strokeColors[i]),
                      _selectedPenIndex != null && _selectedPenIndex == i
                          ? Padding(
                        child: Icon(Icons.check,
                            size: 15.0,
                            color: _isDark ? Colors.black : Colors.white),
                        padding: EdgeInsets.all(5),
                      )
                          : SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            color: Colors.transparent),
      );
    }
    return _strokeColorWidgets;
  }

  void _showPopup() {
    _isSigned = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final Color backgroundColor = _backgroundColor;
            final Color textColor = _isDark ? Colors.white : Colors.black87;

            return AlertDialog(
              insetPadding: EdgeInsets.all(12.0),
              backgroundColor: backgroundColor,
              title: Row(children: [
                Text('Draw your signature',
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto-Medium')),
                InkWell(
                  child: Icon(Icons.clear,
                      color: _isDark
                          ? Colors.grey[400]
                          : Color.fromRGBO(0, 0, 0, 0.54),
                      size: 24.0),
                  //ignore: sdk_version_set_literal
                  onTap: () => {Navigator.of(context).pop()},
                )
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              titlePadding: EdgeInsets.all(16.0),
              content: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
                      Container(
                        child: SfSignaturePad(
                            minimumStrokeWidth: _minWidth,
                            maximumStrokeWidth: _maxWidth,
                            strokeColor: _strokeColor,
                            backgroundColor: _backgroundColor,
                            onDrawStart: _handleOnSignStart,
                            key: _signaturePadKey),
                        width: MediaQuery.of(context).size.width < 306
                            ? MediaQuery.of(context).size.width
                            : 306,
                        height: 172,
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: _getBorderColor(), width: 1),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(children: <Widget>[
                        Text(
                          'Pen Color',
                          style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto-Regular'),
                        ),
                        Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: _addStrokeColorPalettes(setState),
                            ),
                            width: 124)
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                    ], mainAxisAlignment: MainAxisAlignment.center),
                    width: MediaQuery.of(context).size.width < 306
                        ? MediaQuery.of(context).size.width
                        : 306),
              ),
              contentPadding:
              EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
              actionsPadding: EdgeInsets.all(8.0),
              buttonPadding: EdgeInsets.zero,
              actions: [
                FlatButton(
                    onPressed: _handleClearButtonPressed,
                    child: const Text(
                      'CLEAR',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Medium'),
                    ),
                    textColor: Color.fromRGBO(0, 116, 227, 1)),
                SizedBox(width: 8.0),
                FlatButton(
                    onPressed: () {
                      _handleSaveButtonPressed();
                      Navigator.of(context).pop();
                    },
                    child: const Text('SAVE',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto-Medium')),
                    textColor: Color.fromRGBO(0, 116, 227, 1))
              ],
            );
          },
        );
      },
    );
  }

  void _handleSaveButtonPressed() async {
    Uint8List data;
    final imageData =
    await _signaturePadKey.currentState.toImage(pixelRatio: 3.0);
    if (imageData != null) {
      final bytes =
      await imageData.toByteData(format: ui.ImageByteFormat.png);
      data = bytes.buffer.asUint8List();
    }
    setState(
          () {
        _signatureData = data;
      },
    );
  }

  Color _getBorderColor() => _isDark ? Colors.grey[500] : Colors.grey[350];
  Color _getTextColor() => _isDark ? Colors.grey[400] : Colors.grey[700];

  int getNonSupervisorSecCount() {
    int count = 0;
    for (FormItem form in _data) {
      if (JsonSchema.sectionIsSupervisorOnly(form.form)) {
        count++;
      }
    }
    return count;
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    username = prefs.getString("username");
    leadId = prefs.getString("leadId");
    rfcId = prefs.getString("rfcId");
    ethicsId = prefs.getString("ethicsId");
    techLeadId = prefs.getString("techLeadId");
    ethicsAssistantId = prefs.getString("ethicsAssistantId");
    projectLeadId = prefs.getString("projectLeadId");
    isSupervisor = prefs.getString("role") != "ROLE_USER";
    sections = convertToStringList(jsonDecode(template.form_sections));
    _data = generateItems(sections.length,
        convertToStringList(jsonDecode(dbForm.data_content)), sections);
    count = getNonSupervisorSecCount();

    for (int i = 0; i < _data.length; i++) {
      // if form exists, initialize as valid
      // else, initialize to invalid
      if (i < _data.length - count) {
        validSections.add(dbForm.id != null ? true : false);
      }

      this.responses.add(json.decode(_data[i].form));
    }
    setState(() {});
  }

  Future<void> createEntry(String id, String formName, String dataContent, String dateCreated,
      String dateUpdated, String userLocation, String imeI, String updatedBy, bool submit, bool isNew) async {
    debugPrint("createEntry called");
    // String apiUrl = hostUrl + "entry";
    // debugPrint("sending form to $apiUrl");
    bool syncFailed = false;
    if (!formIsValid) {
      Navigator.pop(context);   // close saving dialog
      _showAlertDialog("Incomplete", "Please fill out all required fields before submitting");
      setState(() {
        saving = false;
        submitting = false;
      });
      return;
    }
    if (isNew) {  // creating new record
      try {
        // store locally in db
        form = DbForm(
          id: id,
          form_name: formName,
          data_content: dataContent,
          date_created: dateCreated,
          date_updated: dateUpdated,
          updated_by: updatedBy,
          user_location: userLocation,
          imei: imeI,
          server_id: id,
          synced: false,
          facility: facilityName,
          dateOfSurvey: date.toString(),
          initiator: updatedBy,
          processType: processType,
          submittedToTeamLead: submit,
          reviewedByLead: null,
          leadAccepted: null,
          leadId: leadId,
          reviewedByRfc: null,
          rfcAccepted: null,
          rfcId: rfcId,
          leadComments: null,
          rfcComments: null,
          satelliteLeadId: satelliteLeadId,
          reviewedBySatelliteLead: null,
          satelliteLeadAccepted: null,
          satelliteLeadComments: null,
          ethicsId: ethicsId,
          reviewedByEthics: null,
          ethicsAccepted: null,
          ethicsComments: null,
          techLeadId: techLeadId,
          reviewedByTechLead: null,
          techLeadAccepted: null,
          techLeadComments: null,
          ethicsAssistantId: ethicsAssistantId,
          reviewedByEthicsAssistant: null,
          ethicsAssistantAccepted: null,
          ethicsAssistantComments: null,
          projectLeadId: projectLeadId,
          reviewedByProjectLead: null,
          projectLeadReturned: null,
          projectLeadComments: null,
        );
        int result = await db.insertForm(form);
        if (result != 0) {
          if (!syncFailed) {  // if form gets saved to db AND saves to server successfully
            Navigator.pop(context);   // close saving dialog
            Navigator.pop(context, true);  // move back and set state
            _showAlertDialog(submit?"Submitted":"Saved", "Your form has been ${submit?"submitted to the team lead":"saved"}");
            if (formName == "ZAMPHIA Incident Report" && submit) {
              sendSubmission();
            }
          }
        } else {  // if form does not get saved successfully anywhere, show error message
          Navigator.pop(context);   // close saving dialog
          Navigator.pop(context, false);   // move back but don't set state
          _showAlertDialog("Error", "Your form could not be saved due to an error");
        }
      } on DioError catch (e) {    // no internet connection to submit to server
        debugPrint("$e");
        debugPrint(e.message);
        var body = {
          "id": id,
          "formName": formName,
          "dateCreated": dateCreated,
          "dataContent": dataContent,
          "dateUpdated": dateUpdated,
          "userLocation": userLocation,
          "imeI": imeI,
          "updatedBy": updatedBy,
          "synced": true,
          "facility": facilityName,
          "dateInSurvey": date.toString(),
          "initiator": updatedBy,
          "processType": processType,
          "submittedToTeamLead": submit,
          "reviewedByLead": null,
          "leadAccepted": null,
          "leadId": leadId,
          "reviewedByRfc": null,
          "rfcAccepted": null,
          "rfcId": rfcId,
          "leadComments": null,
          "rfcComments": null,
          "satelliteLeadId": satelliteLeadId,
          "reviewedBySatelliteLead": null,
          "satelliteLeadAccepted": null,
          "satelliteLeadComments": null,
          "ethicsId": ethicsId,
          "reviewedByEthics": null,
          "ethicsAccepted": null,
          "ethicsComments": null,
          "techLeadId": techLeadId,
          "reviewedByTechLead": null,
          "techLeadAccepted": null,
          "techLeadComments": null,
          "ethicsAssistantId": ethicsAssistantId,
          "reviewedByEthicsAssistant": null,
          "ethicsAssistantAccepted": null,
          "ethicsAssistantComments": null,
          "projectLeadId": projectLeadId,
          "reviewedByProjectLead": null,
          "projectLeadReturned": null,
          "projectLeadComments": null,
        };
        var resp = await Dio().post(hostUrl + "entry", data: body, options: Options(contentType: "application/json"));
        // log(resp.statusCode == 200 ? "FORM SUBMITTED (node)" : "FORM NOT SUBMITTED, STATUS CODE ${resp.statusCode} (node)");
        log(resp.statusCode == 201 ? "FORM SUBMITTED (spring)" : "FORM NOT SUBMITTED, STATUS CODE ${resp.statusCode} (spring)");
        // syncFailed = resp.statusCode != 200;  // returns 200 for post (node), 201 (spring boot)
        syncFailed = resp.statusCode != 201;  // returns 200 for post (node), 201 (spring boot)
        // exception caught here when offline
        form = DbForm(
          id: id,
          form_name: formName,
          data_content: dataContent,
          date_created: dateCreated,
          date_updated: dateUpdated,
          updated_by: updatedBy,
          user_location: userLocation,
          imei: imeI,
          server_id: id,
          synced: true,
          facility: facilityName,
          dateOfSurvey: date.toString(),
          initiator: updatedBy,
          processType: processType,
          submittedToTeamLead: submit,
          reviewedByLead: null,
          leadAccepted: null,
          leadId: leadId,
          reviewedByRfc: null,
          rfcAccepted: null,
          rfcId: rfcId,
          leadComments: null,
          rfcComments: null,
          satelliteLeadId: satelliteLeadId,
          reviewedBySatelliteLead: null,
          satelliteLeadAccepted: null,
          satelliteLeadComments: null,
          ethicsId: ethicsId,
          reviewedByEthics: null,
          ethicsAccepted: null,
          ethicsComments: null,
          techLeadId: techLeadId,
          reviewedByTechLead: null,
          techLeadAccepted: null,
          techLeadComments: null,
          ethicsAssistantId: ethicsAssistantId,
          reviewedByEthicsAssistant: null,
          ethicsAssistantAccepted: null,
          ethicsAssistantComments: null,
          projectLeadId: projectLeadId,
          reviewedByProjectLead: null,
          projectLeadReturned: null,
          projectLeadComments: null,
        );
        int result = await db.insertForm(form);
        if (result != 0) {
          Navigator.pop(context);   // close saving dialog
          Navigator.pop(context, true); // move back and set state
          _showAlertDialog("Success", "Your form has been saved. "
              "However, it hasn't been synced with the online server.");
        } else {
          Navigator.pop(context);   // close saving dialog
          Navigator.pop(context, false);   // move back but don't set state
          _showAlertDialog("Error", "Your form could not be saved due to an error");
        }
      } finally {
        saving = false; // change buttons back to original text
        submitting = false;
      }
    } else {  // updating record
      try {
        var body = json.encode({
          "id": id,
          "formName": formName,
          "dateCreated": dateCreated,
          "dataContent": dataContent,
          "dateUpdated": dateUpdated,
          "userLocation": userLocation,
          "imeI": imeI,
          "updatedBy": updatedBy,
          "synced": true,
          "facility": facilityName,
          "dateInSurvey": date.toString(),
          "initiator": dbForm.initiator,
          "processType": dbForm.processType,
          "submittedToTeamLead": submit?"true":dbForm.submittedToTeamLead.toString(),
          "reviewedByLead": submit?null:leadReviewed.toString(),
          "leadAccepted": submit?null:dbForm.leadAccepted,  // if a form is being submitted eithre for the 1st time or again, the lead must review it
          "leadId": dbForm.leadId,
          "reviewedByRfc": dbForm.reviewedByRfc.toString(),
          "rfcAccepted": dbForm.rfcAccepted.toString(),
          "rfcId": dbForm.rfcId,
          "leadComments": dbForm.leadComments,
          "rfcComments": dbForm.rfcComments,
          "satelliteLeadId": dbForm.satelliteLeadId,
          "reviewedBySatelliteLead": dbForm.reviewedBySatelliteLead,
          "satelliteLeadAccepted": dbForm.satelliteLeadAccepted,
          "satelliteLeadComments": dbForm.satelliteLeadComments,
          "ethicsId": dbForm.ethicsId,
          "reviewedByEthics": dbForm.reviewedByEthics.toString(),
          "ethicsAccepted": dbForm.ethicsAccepted.toString(),
          "ethicsComments": dbForm.ethicsComments,
          "techLeadId": dbForm.techLeadId,
          "reviewedByTechLead": dbForm.reviewedByTechLead.toString(),
          "techLeadAccepted": dbForm.techLeadAccepted.toString(),
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
        // even though this may exist in the local db, it may need to be POSTed to server
        var existsInServer = await http.get(hostUrl + "entry/$id");
        bool exists = existsInServer.body.length > 0;
        var response = exists ?
        await http.put(hostUrl + "entry/$id", body: body, headers: {"Content-Type": "application/json"})
        : await http.post(hostUrl + "entry", body: body, headers: {"Content-Type": "application/json"});
        // in the event that a form was created and updated offline, it won't be
        // found in the remote server with the put request. run a post request instead
        debugPrint("status: ${response.statusCode}");
        if (response.statusCode != 200 && response.statusCode != 201) {
          syncFailed = true;
        }
      } on SocketException catch (e) {
        debugPrint("SYNC FAILED IN BAISV MONITORING");
        debugPrint("$e");
        debugPrintStack();
        syncFailed = true;
      } finally {
        form = DbForm(
          id: id,
          form_name: formName,
          data_content: dataContent,
          date_created: dateCreated,
          date_updated: dateUpdated,
          updated_by: updatedBy,
          user_location: userLocation,
          imei: imeI,
          synced: !syncFailed,
          dateOfSurvey: date.toString(),
          initiator: dbForm.initiator,
          processType: processType,
          submittedToTeamLead: submit?true:dbForm.submittedToTeamLead,  // if the user's resubmitting or submitting to team lead for the first time, set submit to true. else, use stored value
          facility: facilityName,
          reviewedByLead: submit?null:dbForm.reviewedByLead,
          leadAccepted: submit?null:dbForm.leadAccepted,
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
          _showAlertDialog(submit?"Submitted":"Updated", "Your form has been ${submit?"submitted to the team lead":"updated"}");
          if (formName == "ZAMPHIA Incident Report") {
            sendSubmission();
          }
        } else if (result != 0 && syncFailed) {
          Navigator.pop(context);   // close saving dialog
          Navigator.pop(context, true);   // move back and set state
          _showAlertDialog("Success", "Your form has been updated. "
              "However, it hasn't been synced with the online server");
        } else {
          Navigator.pop(context);   // close saving dialog
          Navigator.pop(context, false);   // move back but don't set state
          _showAlertDialog("Error", "Your form could not be updated due to an error");
        }
        saving = false; // change save button back to "save"
        submitting = false;
      }
    }
  }

  // converts items in rawDecoded to String types
  List<String> convertToStringList(dynamic rawDecoded) {
    List<String> listStr = <String>[];
    for (var s in rawDecoded) {
      listStr.add(s);
    }
    return listStr;
  }

  FormsDatabase db = FormsDatabase.getInstance();

  int count = 0;

  FormTemplate template;
  DbForm dbForm;
  final bool exists;
  bool saving = false, submitting = false;

  DbForm form;
  List<FormItem> _data = <FormItem>[];

  // for tracking responses
  List<dynamic> responses = new List<dynamic>();
  List<int> validResponses = new List<int>();
  List<int> numQsPerSection = new List<int>();
  List<bool> validSections = <bool>[];

  List<String> sections = <String>[];
  bool formIsValid = false;
  _BaisMonitorState(this.template, this.dbForm, this.exists);

  // copy used to display form, with or without hidden supervisor-only sections
  List<ExpansionPanel> schemaExpansions = <ExpansionPanel>[];
  List<int> hiddenIndices = <int>[];
  Map<int, num> scores = new Map<int, num>();
  num scorePercentage = 0;

  List<ExpansionPanel> getSchemas() {
    int value = 0;
    schemaExpansions = [];
    for (FormItem form in _data) {
      if (JsonSchema.sectionIsSupervisorOnly(form.form) && !isSupervisor) {
        hiddenIndices.add(value);
        continue;
      }
      // expanded.add(false);
      schemaExpansions.add(ExpansionPanel(
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text(form.headerValue),
          );
        },
        body: new JsonSchema(
          form: form.form,
          exists: this.exists,
          onChanged: (dynamic response) {
            this.responses[form.index] = response;
            // isFormValid();
          },
          isSupervisor: this.isSupervisor,
          sectionIndex: value,
          currentPts: (num current, int index) {
            log("currentPts callback called with value: $current");
            setState(() {
              scores[index] = current;
              currentPts = _getCurrentFormScore();
              log("score is now: $currentPts/$totalPtsPoss");
              scorePercentage = (currentPts / totalPtsPoss) * 100;
              log("$scorePercentage%");
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
        ),
        isExpanded: form.isExpanded,
      ));
      value++;
    }
    // log("hidden indices: $hiddenIndices");
    return schemaExpansions;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async {
      final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Are you sure you want to quit filling the form?'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes, exit'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
      );
      return value == true;
    },
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(template.form_name),
          backgroundColor: Color(0xff392850),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _data[index].isExpanded = !isExpanded;
                  });
                },
              children: getSchemas()),
            // if this is the SPI-RT Form, add scoring calculation at end of form
            if (dbForm.form_name == "Stepwise Process for Improving the Quality of HIV Rapid Testing (SPI-RT) Checklist")
              Container(
                margin: EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Text("Overall Score", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // CircleAvatar(
                        //   backgroundColor: spirtPerformanceColor(),
                        //   child: spirtPerformanceIcon(),
                        // ),
                        Padding(
                          child: CircularPercentIndicator(
                            radius: 60.0,
                            lineWidth: 5.0,
                            percent: scorePercentage / 100,
                            center: Text("${getPercentageString()}%"),
                            progressColor: spirtPerformanceColor(),
                          ),
                          padding: EdgeInsets.all(5.0)
                        ),
                        Container(width: 10.0,),
                        // Text(
                        //   "Level ${spirtPerformanceLevel()}: ${scorePercentage.toStringAsFixed(2)}%",
                        //   style: TextStyle(fontSize: 18.0),)
                      ],
                    ),
                    Container(height: 10.0,),
                    Text(
                      "Level ${spirtPerformanceLevel()}",
                      style: TextStyle(fontSize: 18.0),),
                    Container(height: 10.0,),
                    Text(spirtDescription(), style: TextStyle(fontSize: 15.0))
                  ],
                ),
              ),
            if (dbForm.form_name == "ZAMPHIA Incident Report")
            Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: RaisedButton(
                        child: Text(submitting ? "Submitting to Team Lead..." : "Submit to Team Lead",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (!submitting) {
                            setState(() {
                              _showSubmitConfirmDialog();
                            });
                          }
                        },
                        color: Colors.green,
                        disabledColor: Colors.grey,
                      )),
                ])),
            Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                        child: Text(saving ? "Saving Changes..." : "Save Changes",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (!saving) {
                            setState(() {
                              // debugPrint("Saving item...");
                              _save(false);
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff392850),
                        ),
                      )),
                ])),

          ]),
        ),
      ),
    );
  }

  String getPercentageString() {
    debugPrint("getPercentageString() called");
    if (scorePercentage % 1 == 0.0) { // if number is an int, return it as is
      return scorePercentage.truncate().toString();
    } else if (scorePercentage % 10 == 0.0) {  // else if num comes out to an even tenth (ex 0.1), return with 1 decimal
      return scorePercentage.toStringAsFixed(1);
    } else {
      return scorePercentage.toStringAsFixed(2);
    }
  }


  String spirtDescription() {
    if (scorePercentage < 40.0) {
      return "Needs improvement in all areas and immediate remediation";
    } else if (scorePercentage < 60.0) {
      return "Needs improvement in specific areas";
    } else if (scorePercentage < 80.0) {
      return "Partially eligible";
    } else if (scorePercentage < 90.0) {
      return "Close to national site certification";
    } else {
      return "Eligible to national site certification";
    }
  }

  Color spirtPerformanceColor() {
    if (scorePercentage < 40.0) {
      return Colors.red;
    } else if (scorePercentage < 60.0) {
      return Colors.orange;
    } else if (scorePercentage < 80.0) {
      return Colors.yellow[600];
    } else if (scorePercentage < 90.0) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }

  int spirtPerformanceLevel() {
    if (scorePercentage < 40.0) {
      return 0;
    } else if (scorePercentage < 60.0) {
      return 1;
    } else if (scorePercentage < 80.0) {
      return 2;
    } else if (scorePercentage < 90.0) {
      return 3;
    } else {
      return 4;
    }
  }

  void isFormValid() {
    debugPrint("checkValid() called");
    // for (bool b in validSections) {
    //   if (b == false) {
    //     setState(() {
    //       formIsValid = false;
    //     });
    //     return;
    //   }
    // }
    setState(() {
      formIsValid = true;
    });
  }

  void _showSubmitConfirmDialog() {
    if (dbForm.submittedToTeamLead == true) {
      AlertDialog dialog = AlertDialog(
        content: Text('This form has already been submitted to the team lead. Would you like to resubmit this form?'),
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
              _save(true);
            },
          ),
        ],
      );
      showDialog(context: context, builder: (_) => dialog, barrierDismissible: false);
    } else {
      AlertDialog dialog = AlertDialog(
        content: Text("Are you sure you want to submit this report to the team lead? "
            "The team lead will review your report and provide feedback on your submission."),
        actions: <Widget>[
          ElevatedButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop();
              _save(true);
            },
          ),
        ],
      );
      showDialog(context: context, builder: (_) => dialog, barrierDismissible: false);
    }
  }

  num _getCurrentFormScore() {
    num currentScore = 0;
    this.scores.forEach((key, value) { /*log("scores[$key]: $value pts");*/ currentScore += value; });
    if (currentScore == currentScore.roundToDouble())
      return currentScore.truncate();
    return currentScore;
  }

  void _save(bool submit) async {
    debugPrint("_save($submit) called");
    submit ? submitting = true : saving = true;  // switch save button to display "saving..."
    setFacility();
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

    String uuid = this.dbForm.id == null ? Uuid().v4() : this.dbForm.id;
    String op = this.dbForm.id == null ? "insert" : "update";
    // create variables, then store in server
    final String id = uuid;
    final String formName = template.form_name;
    final String dateCreated = DateTime.now().toString();
    final String dateUpdated = DateTime.now().toString();
    final String dataContent = encodeResponse();
    final String updatedBy = username;
    final String userLocation = "";
    final String imeI = isAndroid ? androidDeviceInfo.androidId : "";

    // List<Future> futures = <Future>[];
    if (op == "insert") {
      await createEntry(id, formName, dataContent,
          dateCreated, dateUpdated, userLocation, imeI, updatedBy, submit, true);
    } else {
      await createEntry(id, formName, dataContent,
          dateCreated, dateUpdated, userLocation, imeI, updatedBy, submit, false);
    }
  }

  String encodeResponse() {
    List<String> strResp = <String>[];
    strResp.clear();
    // check if user is a supervisor or not. if true, then continue. else, add
    // empty sections to responses, for supervisor-only sections to load for supervisors
    if (!isSupervisor) {
      // copy form from truncated template (no supervisor sections)
      int index = 0;
      int responseCount = 0;
      for (int i = 0; i < _data.length; i++) {
        // if the current index at data is not an index removed because it was a section
        // for supervisors, then overwrite
        if (hiddenIndices.isNotEmpty && hiddenIndices[index] != i) {
          // _data = responses[i];
          responses[i] = responses[responseCount];
          responseCount++;
        } else {
          // if the current index at data is an index removed because it was a section
          // for supervisors, then do not overwrite, and increment hiddenIndices counter
          index++;
        }
      }
    }
    for (var response in responses) {
      strResp.add(json.encode(response));
    }
    return jsonEncode(strResp);
  }

  void setFacility() {
    debugPrint("setFacility() called");
    String formName = dbForm.form_name;
    debugPrint(formName);
    // responses[0]['fields'].forEach((element) { log("$element"); });

    switch (formName) {
      case "Incident Reports":
        isIncidentReport = true;
        facilityName = responses[0]['fields'][0]['value'];
        date = DateTime.parse(responses[0]['fields'][2]['value']);
        log("${responses[0]['fields'][2]['label']}, ${responses[0]['fields'][2]['value']}");
        log("${responses[0]['fields'][0]['label']}, ${responses[0]['fields'][0]['value']}");
        break;
      case "BAISV Monitoring":
        facilityName = responses[0]['fields'][0]['value'];
        // facilityName = "";
        date = DateTime.parse(responses[0]['fields'][11]['value']);
        // date = DateTime.parse("2021-04-07 00:10:12.926923");
        log("${responses[0]['fields'][11]['label']}, ${responses[0]['fields'][11]['value']}");
        log("${responses[0]['fields'][0]['label']}, ${responses[0]['fields'][0]['value']}");
        break;
      case "TB Laboratory Quality Management Systems Towards Accreditation Harmonized Checklist":
        date = DateTime.parse(responses[0]['fields'][0]['value']);
        facilityName = responses[0]['fields'][4]['value'];
        log("${responses[0]['fields'][0]['label']}, ${responses[0]['fields'][0]['value']}");
        log("${responses[0]['fields'][4]['label']}, ${responses[0]['fields'][4]['value']}");
        break;
      case "Stepwise Laboratory Quality Improvement Process Towards Accreditation (SLIPTA) Checklist Version 2:2015":
        date = DateTime.parse(responses[0]['fields'][0]['value']);
        facilityName = responses[0]['fields'][4]['value'];
        log("${responses[0]['fields'][0]['label']}, ${responses[0]['fields'][0]['value']}");
        log("${responses[0]['fields'][4]['label']}, ${responses[0]['fields'][4]['value']}");
        break;
      case "HIV Viral Load and Infant Virological Testing Scorecard":
        date = DateTime.parse(responses[0]['fields'][8]['value']);
        facilityName = responses[0]['fields'][2]['value'];
        log("${responses[0]['fields'][8]['label']}, ${responses[0]['fields'][8]['value']}");
        log("${responses[0]['fields'][8]['label']}Var, $date");
        // log("${responses[0]['fields'][2]['label']}, ${responses[0]['fields'][2]['value']}");
        // log(date);
        break;
      case "Stepwise Process for Improving the Quality of HIV Rapid Testing (SPI-RT) Checklist":
        date = DateTime.parse(responses[0]['fields'][0]['value']);
        facilityName = responses[0]['fields'][2]['value'];
        log("${responses[0]['fields'][0]['label']}: ${responses[0]['fields'][0]['value']}");
        log("${responses[0]['fields'][2]['label']}: ${responses[0]['fields'][2]['value']}");
        break;
      case "ZAMPHIA Incident Report":
        isIncidentReport = true;
        date = responses[0]['fields'][10]['value'] != null
            ? DateTime.parse(responses[0]['fields'][11]['value'])
            : DateTime.now();
        facilityName = responses[0]['fields'][1]['value'] ?? "No Title Specified";
        int proc = responses[0]['fields'][0]['value'] ?? 1;
        processType = proc == 1 ? "FIELD" : "LAB";
        // log("${responses[0]['fields'][0]['label']}: ${responses[0]['fields'][0]['value']}");
        // log("${responses[0]['fields'][2]['label']}: ${responses[0]['fields'][2]['value']}");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));

    showDialog(context: context, builder: (_) => alertDialog);
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
}
