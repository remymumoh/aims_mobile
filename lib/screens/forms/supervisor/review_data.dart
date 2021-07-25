import 'package:flutter/material.dart';

class ReviewData extends StatelessWidget {
  List<String> _listViewData = [
    "Household #01",
    "Address Household 1 Address",
    "HH head Name: John Smith",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assign Households'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 250,
            child: Card(
              elevation: 3.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                //map List of our data to the ListView
                children: _listViewData
                    .map((data) => ListTile(title: Text(data)))
                    .toList(),
              ),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            height: 250,
            child: Card(
              elevation: 3.0,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                //map List of our data to the ListView
                children: _listViewData
                    .map((data) => ListTile(title: Text(data)))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}