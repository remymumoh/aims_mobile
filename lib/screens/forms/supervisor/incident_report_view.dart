import 'dart:convert';

import 'package:aims_mobile/screens/forms/supervisor/menu.dart';
import 'package:aims_mobile/screens/forms/utils/json_schema.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:device_info/device_info.dart';
// import 'package:aims_mobile/utils/formsdetailsbase.dart';
// import 'package:aims_mobile/utils/formsdetailsbase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class IncidentReportView extends StatefulWidget {
  IncidentReportView(this.template, this.dbForm);
  FormTemplate template;
  IncidentReport dbForm;
  @override
  _IncidentReportViewState createState() => _IncidentReportViewState(this.template, this.dbForm);
}

class FormDetails {
  FormDetails({this.headerValue, this.isExpanded = false, this.form, this.index});
  String headerValue;
  bool isExpanded;
  String form;
  int index;
}

List<FormDetails> generateItems(
    int numberOfItems, List<String> forms, List<String> formNames) {
  return List.generate(numberOfItems, (int index) {
    return FormDetails(
        headerValue: formNames[index], form: forms[index], index: index);
  });
}

class _IncidentReportViewState extends State<IncidentReportView> {
  List<FormDetails> details = <FormDetails>[];
  List<String> sections = <String>[];
  FormTemplate template;
  IncidentReport dbForm;
  List<bool> validSections = <bool>[];
  List<dynamic> responses = <dynamic>[];
  bool formIsValid = false;
  int count = 0;
  bool saving = false;
  String username;
  String hostUrl = "http://10.0.2.2:8080/api/v1/";
  // FormsDatabase db;
  FormsDatabase db = FormsDatabase.getInstance();
  bool approved;
  bool changesMade = false;
  _IncidentReportViewState(this.template, this.dbForm);

  @override
  void initState() {
    sections = convertToStringList(jsonDecode(template.form_sections));
    debugPrint("section length: ${sections.length}");
    // debugPrint("sections: ${sections}");
    details = generateItems(sections.length, convertToStringList(jsonDecode(dbForm.dataContent)), sections);
    count = details.length;
    for (int i = 0; i < count; i++) {
      validSections.add(dbForm.id != null ? true : false);
    }
    getInfo();
    // jsonToDetails();
    super.initState();
  }

  // @override
  // void setState(fn) {
  //   if(mounted) {
  //     super.setState(fn);
  //   }
  // }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    setState(() {
      approved = this.dbForm.approved;
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
    if (!formIsValid) {
      Navigator.pop(context);   // close saving dialog
      _showAlertDialog("Incomplete", "Please fill out all required fields before submitting");
      setState(() {
        saving = false;
      });
      return;
    }
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
        "synced": true
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
        synced: !syncFailed
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
        title: Text("Incident Report"),
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
                Text("This form ${approved == true ?
                "has been marked as approved" : approved == false ?
                "has been marked as rejected" : "is pending review"}")
              ],
            ),
          ),
          ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  details[index].isExpanded = !isExpanded;
                });
              },
              children: details.map<ExpansionPanel>((FormDetails form) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(form.headerValue),
                    );
                  },
                  body: new JsonSchema(
                    form: form.form,
                    onChanged: (dynamic response) {
                      this.responses[form.index] = response;
                      isFormValid();
                    },
                    actionSave: (data) {
                      print(data);
                    },
                    isValid: (valid) {
                      // debugPrint("valid is $valid");
                      this.validSections[form.index] = valid;
                    },
                    // onInit: (response) {
                    //   this.responses.add(response);
                    // },
                  ),
                  isExpanded: form.isExpanded,
                );
              }).toList()),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: Text("Approve", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      approveOrReject(true);
                    },
                    color: Colors.green,
                  ),
                ),
                // Expanded(
                //   child: RaisedButton(
                //     child: Text("Reject", style: TextStyle(color: Colors.white)),
                //     onPressed: () {
                //       approveOrReject(false);
                //     },
                //     color: Colors.red,
                //   ),
                // )
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
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    // create variables, then store in server
    String uuid = this.dbForm.id;
    final String id = uuid;
    final String formName = template.form_name;
    final String dateCreated = DateTime.now().toString();
    final String dateUpdated = DateTime.now().toString();
    final String dataContent = encodeResponse();
    final String updatedBy = username;
    final String userLocation = isAndroid
        ? position.latitude.toString() + ", " + position.longitude.toString()
        : "";
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

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog =
    AlertDialog(title: Text(title), content: Text(message));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  Future<void> approveOrReject(bool status) async {
    debugPrint("approveOrReject(bool) called");
    _showSavingDialog();
    // if user tries setting status twice, then show dialog and exit early
    if (status == approved) {
      Navigator.pop(context);
      _showAlertDialog("No Changes", "This form's approval status is already set to ${status ? "approved" : "rejected"}");
      return;
    }
    try {
      var response = await http.patch(hostUrl + "entry/pending-incidents/${this.dbForm.id}?approved=${status.toString()}");
      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context, true);
        _showAlertDialog("${status ? "Approved" : "Rejected"}", "This report has been marked as ${status ? "approved" : "rejected"}");
        setState(() {
          approved = status;changesMade = true;
        });
      } else {
        Navigator.pop(context);
        _showAlertDialog("Error", "Your changes could not be saved due to an error. Please try again later");
        // _showAlertDialog("Error", "${response.statusCode}");
      }
    } on SocketException catch (e) {
      isFormValid();
      _showSavingDialog();
      bool isAndroid = Platform.isAndroid;
      var position;
      var androidDeviceInfo;
      var deviceInfo;
      if (isAndroid) {
        deviceInfo = DeviceInfoPlugin();
        androidDeviceInfo = await deviceInfo.androidInfo;
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      }

      // create variables, then store in server
      String uuid = this.dbForm.id;
      final String id = uuid;
      final String formName = template.form_name;
      final String dateCreated = DateTime.now().toString();
      final String dateUpdated = DateTime.now().toString();
      final String dataContent = this.dbForm.dataContent;
      final String updatedBy = username;
      final String userLocation = isAndroid
          ? position.latitude.toString() + ", " + position.longitude.toString()
          : "";
      final String imeI = isAndroid ? androidDeviceInfo.androidId : "";
      Navigator.pop(context);
      Navigator.pop(context);
      int result = await db.updateIndicentReport(new IncidentReport(id: id, formName: formName,
      dateCreated: dateCreated, dateUpdated: dateUpdated, dataContent: dataContent,
      updatedBy: updatedBy, userLocation: userLocation,imei: imeI, approved: status,
      synced: false));
      if (result != 0) {
        Navigator.pop(context, true);
        _showAlertDialog("${status ? "Approved" : "Rejected"}", "This report has been marked as ${status ? "approved" : "rejected"}"
            ". However, these changes have not been saved to the PHIA server");
        setState(() {
          approved = status;changesMade = true;
        });
      } else {
        _showAlertDialog("Error", "This form's approval status could not be updated. Please try again later");
      }
    }
    // updateForm();
  }
}