import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xff392850),
          title: new Text('Encuesta V3.0'),
        ),
        body: new ListView(
          children: <Widget>[
            Container(
              height: 150.0,
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: new Text("Messages",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              ),
            ),
            //You can add more widget bellow
          ],
        )
    );
  }
}
