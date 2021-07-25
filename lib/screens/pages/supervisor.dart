import 'dart:convert';

import 'package:aims_mobile/screens/forms/supervisor/incident_reports_list.dart';
import 'package:aims_mobile/utils/forms_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SuperVisorSheet extends StatefulWidget {
  @override
  _SuperVisorSheetState createState() => _SuperVisorSheetState();
}

class _SuperVisorSheetState extends State<SuperVisorSheet> {
  // Future<List> clusters;
  List<DbForm> clusters = <DbForm>[];

  void getClusters() async {
    debugPrint("supervisors getClusters() called");
    var response = await http.get('http://10.0.2.2:8080/api/v1/entry/pending-incidents');
    // debugPrint(response.body);
    var list = json.decode(response.body);
    for (var i in list) {
      DbForm temp = new DbForm(id: i["id"], data_content: i["dataContent"], form_name: i["formName"], updated_by: i["updatedBy"],
      date_updated: i["dateUpdated"], date_created: i["dateCreated"]);
      setState(() {
        clusters.add(temp);
      });

      // debugPrint("$temp");
    }
    // debugPrint("${json.decode(response.body)}");
  }

  @override
  void initState() {
    // TODO: implement initState
    getClusters();
    super.initState();
  }

  performSync() {
    debugPrint("performSync called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff392850),
        title: Text("Supervisor"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () async {
            performSync();
          },
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  title: Text("Incident Reports"),
                  subtitle: Text(
                      "Review incidents raised by research workers"),
                  trailing: GestureDetector(
                      child: Icon(Icons.chevron_right, color: Colors.grey)),
                  onTap: () {
                    debugPrint("Item tapped");
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return IncidentReportsList();
                    }));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
