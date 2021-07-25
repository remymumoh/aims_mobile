import 'package:aims_mobile/data/data.dart';
import 'package:aims_mobile/screens/authentication/signin.dart';
import 'package:aims_mobile/screens/pages/camera.dart';
import 'package:aims_mobile/screens/pages/screen.dart';
import 'package:aims_mobile/widgets/custom_app_bar.dart';
import 'package:aims_mobile/widgets/custom_tab_bar.dart';
import 'package:aims_mobile/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


class NavScreen extends StatefulWidget {
  const NavScreen({Key key, UserDetails detailsUser}) : super(key: key);

  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [];

  @override
  void initState() {
    _screens.add(Home());
    _screens.addAll([
      Settings(),
      Home(),
      // AudioRecorder(),
      CameraExampleHome()]);
    super.initState();
  }

  final List<IconData> _icons = const [
    Icons.home,
    Icons.settings,
    MdiIcons.accountCircleOutline,
    MdiIcons.accountGroupOutline,
    Icons.menu,
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        // upper navbar for tablet/desktop
        // appBar: Responsive.isDesktop(context)
            // ? PreferredSize(
          // preferredSize: Size(screenSize.width, 100.0),
          // child: CustomAppBar(
          //   currentUser: currentUser,
          //   icons: _icons,
          //   selectedIndex: _selectedIndex,
          //   onTap: (index) => setState(() => _selectedIndex = index),
          // ),
        // )
            // : null,
        body: IndexedStack(index: _selectedIndex, children: _screens),
        // bottom navbar for mobile
        // bottomNavigationBar: !Responsive.isDesktop(context)
        //     ? Container(
        //   padding: const EdgeInsets.only(bottom: 8.0),
        //   child: CustomTabBar(
        //     icons: _icons,
        //     selectedIndex: _selectedIndex,
        //     onTap: (index) => setState(() => _selectedIndex = index),
        //   ),
        // ) : const SizedBox.shrink(),
      )
    );
  }
}
