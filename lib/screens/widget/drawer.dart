import 'package:aims_mobile/screens/authentication/signin.dart';
import 'package:aims_mobile/screens/forms/forms_dashboard.dart';
import 'package:aims_mobile/screens/forms/supervisor/incident_reports_list.dart';
import 'package:aims_mobile/screens/pages/nav_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class DrawerMobile extends StatefulWidget {
  @override
  _DrawerMobileState createState() => _DrawerMobileState();
}

class _DrawerMobileState extends State<DrawerMobile> {
  String username = "";
  String appVersion;
  String firstName = "", lastName = "";
  int id = 0;
  Image photo;
  bool isAdmin = false;
  var roleStr;
  // MsalMobile msal;
  static String authority = "https://login.microsoftonline.com/organizations";

  // @override
  // void initState() {
  // }

  @override
  void initState() {
    super.initState();
    getName();
    // msal = SignIn().getMsal;
  }

  void getName() async {
    debugPrint("drawer getName() called");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    firstName = prefs.getString("firstname");
    lastName = prefs.getString("surname");
    id = prefs.getInt("id");
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    roleStr = prefs.getString("roles");
    isAdmin = roleStr == "ROLE_ADMIN";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // isAdmin = true;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          SizedBox(height: 20),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Dashboard',
              // onTap: () => Navigator.pushReplacementNamed(context, '/home')),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return NavScreen();
                }));
              }
          ),

          _createDrawerItem(
              icon: Icons.assignment_rounded,
              text: 'Forms',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return FormsDashboard();
                }));
              }),

          Visibility(
            visible: isAdmin,
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.rate_review_rounded),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Manage Incident Reports"),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return IncidentReportsList();
                }));
              },
            ),
          ),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () => showAlertDialog(context)),
          Divider(),
          ListTile(
            title: Text("$appVersion"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', null);
        await prefs.clear();
        await SignIn().getMsal.signOut();
        // msal = null;
        Navigator.pushNamedAndRemoveUntil(
            context, "/", (Route<dynamic> route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you would like to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Hi, $username",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
