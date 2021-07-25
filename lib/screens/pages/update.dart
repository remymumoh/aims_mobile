import 'package:flutter/material.dart';

class Updates extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Now we need multiple widgets into a parent = "Container" widget
    Widget titleSection = new Container(
      padding: const EdgeInsets.all(10.0),//Top, Right, Bottom, Left
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text("No Updates",
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      )),
                ),
                //Need to add space below this Text ?
                new Text("App "
                    "Updates",
                  style: new TextStyle(
                      color: Colors.grey[850],
                      fontSize: 16.0
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final bottomTextSection = new Container(
      padding: const EdgeInsets.all(20.0),
      //How to show long text ?
      child: new Text('Sync forms',
          style: new TextStyle(
              color: Colors.grey[850],
              fontSize: 16.0
          )
      ),
    );
    //build function returns a "Widget"
        return Scaffold(
            appBar: new AppBar(
              backgroundColor: Color(0xff392850),
              title: new Text('Monitoring Tool'),
            ),
            body: new ListView(
              children: <Widget>[
                Container(
                  height: 150.0,
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50.0),
                    child: new Text("Forms Updates",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  ),
                ),
                //You can add more widget bellow
                titleSection,
                bottomTextSection
              ],
            )
    );//Widget with "Material design"
  }
}
