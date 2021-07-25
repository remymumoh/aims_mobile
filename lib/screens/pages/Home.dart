import 'package:aims_mobile/data/data.dart';
import 'package:aims_mobile/screens/widget/drawer.dart';
import 'package:aims_mobile/widgets/grid_dashboardwe.dart';
import 'package:aims_mobile/widgets/more_options_list.dart';
import 'package:aims_mobile/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'griddashboard.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();
  String username = "";

  @override
  void initState() {
    getName();
  }

  void getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    setState((){});
  }

  @override
  void dispose() {
    // TODO: implement disp
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DrawerMobile(),
        appBar: AppBar(leading: GestureDetector(onTap: () {
          scaffoldKey.currentState.openDrawer();
          setState(() {});
        },
        child: Icon(Icons.menu)),
          backgroundColor: Color(0xff392850),
          title: Text("Dashboard"),
        ),
        // backgroundColor: Color(0xff392850),
        body: Responsive(
          mobile: _HomeScreenMobile(
              scrollController: _trackingScrollController, username: username),
          desktop: _HomeScreenDesktop(
              scrollController: _trackingScrollController, username: username),
        ),
      ),
    );//);
  }
}

class _HomeScreenMobile extends StatelessWidget {
  final TrackingScrollController scrollController;
  final String username;

  const _HomeScreenMobile(
      {Key key, this.scrollController, @required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return RefreshIndicator(
    //   child: ListView(
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.only(left: 10, top: 30, right: 10),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 DateTime.now().hour >= 12 ?
    //                 DateTime.now().hour >= 18
    //                     ? Text("Good evening, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    //                     : Text("Good afternoon, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
    //                     : Text("Good morning, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //       // GridDashboard()
    //       Dashboard()
    //     ],
    //   ),
    //   onRefresh: () => setState((){});
    // );
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, top: 30, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DateTime.now().hour >= 12 ?
                  DateTime.now().hour >= 18
                  ? Text("Good evening, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      : Text("Good afternoon, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                      : Text("Good morning, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        // GridDashboard()
        Dashboard()
      ],
    );
  }
}

class _HomeScreenDesktop extends StatelessWidget {
  final String username;

  final TrackingScrollController scrollController;


  //final MyApp handleGetAccount;
  //final TrackingScrollController scrollController;final String username;


  // const _HomeScreenDesktop(
  //     {Key key,
  //     this.scrollController,
  //    // this.handleGetAccount, this.username})
  //     : super(key: key);
  const _HomeScreenDesktop(
      {Key key, this.scrollController, @required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint()
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: MoreOptionsList(username: username),
            ),
          ),
        ),
        const Spacer(),
        Container(
            height: 1000.0,
            width: 600.0,
            child: ListView(
              //controller: scrollController,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                DateTime.now().hour >= 12 ?
                DateTime.now().hour >= 18
                    ? Text("Good evening, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    : Text("Good afternoon, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    : Text("Good morning, $username", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // GridDashboardwe()
                Dashboard()
              ],
            )),
        const Spacer(),
        Flexible(
          flex: 2,
          child: Container(
            color: Color(0xff392850),
          ),
        )
      ],
    );
  }
}
