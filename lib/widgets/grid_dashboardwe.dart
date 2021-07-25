import 'package:aims_mobile/screens/pages/Home.dart';
import 'package:aims_mobile/screens/pages/appupdates.dart';
// import 'package:aims_mobile/screens/pages/audio_recorder.dart';
import 'package:aims_mobile/screens/pages/bluetooth.dart';
import 'package:aims_mobile/screens/pages/camera.dart';
import 'package:aims_mobile/screens/pages/messages.dart';
import 'package:aims_mobile/screens/pages/supervisor.dart';
import 'package:aims_mobile/screens/forms/forms_dashboard.dart';
import 'package:aims_mobile/screens/pages/settings.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class GridDashboardwe extends StatelessWidget {

  Items home = new Items(screen: Home());
  Items update = new Items(screen: CameraExampleHome());
  Items bluetooth = new Items(screen: BluetoothApp());
  Items forms = new Items(screen: FormsDashboard());
  Items supervisor = new Items(screen: SuperVisorSheet());
  Items messages = new Items(screen: Messages());
  Items settings = new Items(screen: Settings());
  Items check = new Items(screen: AppUpdates());
  // Items logout = new Items(screen: AudioRecorder());

  var services = [
    "Home",
    "Capture",
    "Bluetooth",
    "Forms",
    "Supervisor",
    "Messages",
    "Settings",
    "App updates",
    "Audio",
  ];

  var images = [
    "assets/home.png",
    "assets/camera.png",
    "assets/bluetooth.png",
    "assets/todo.png",
    "assets/supervisor.png",
    "assets/message.png",
    "assets/setting.png",
    "assets/update.ico",
    "assets/audio.png",
  ];

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [home, update, bluetooth, forms, supervisor, messages, settings, check/*, logout*/];
    var color = 0xff453658;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 600,
        // margin: EdgeInsets.only(top: 10),
        // padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            height: 600,
            child: GridView.builder(
              // add this
              shrinkWrap: true,
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 0.5),
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, new MaterialPageRoute<Widget>(
                        builder: (BuildContext context) {
                          if(myList != null){
                            return myList[index].screen;
                          }else{
                            return null;
                          }

                        }));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Card(
                      elevation: 200,
                      child: ListView(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          Image.asset(
                            images[index],
                            height: 50.0,
                            width: 50.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              services[index],
                              style: TextStyle(
                                  fontSize: 16.0,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      color: Color(color),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  final Widget screen;

  Items({this.title, this.subtitle, this.event, this.img, this.screen});
}
