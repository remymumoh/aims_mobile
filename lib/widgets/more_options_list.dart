import 'package:aims_mobile/config/palette.dart';
import 'package:aims_mobile/models/user_model.dart';
import 'package:aims_mobile/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MoreOptionsList extends StatelessWidget {
  final List<List> _moreOptionsList = [

    // [MdiIcons.shieldAccount, Colors.deepPurple, Text('Household Entry', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
    // [MdiIcons.post, Colors.pinkAccent, Text('Community Mobilization', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
    // [MdiIcons.flag, Colors.orange, Text('Individual Interview', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
    // [MdiIcons.storefront, Colors.lightBlue, Text('Child Processes', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
    // [MdiIcons.video, Colors.green, Text('Pre and Post Counselling', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
    // [MdiIcons.calendarStar, Colors.red, Text('HouseHold Exit', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))],
  ];
  final User currentUser;
  final String username;

  MoreOptionsList({Key key,
    this.currentUser, this.username}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 280.0),
      child: ListView.builder(
        itemCount: 1 +  _moreOptionsList.length,
        itemBuilder: (BuildContext context, int index){
          if(index == 0) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: UserCard(user: User(name: username)),
            );
          }
          final List option = _moreOptionsList [index-1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: _Option(icon: option[0], color: option[1], label: option[2]),
          );
        },
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Text label;

  const _Option({Key key,
    @required this.icon,
    @required this.color,
    @required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print(label),
      child: Row(
        children: [
          Icon(icon, size:38.0, color: color,),
          const SizedBox(width: 6.0),
          Flexible(child: label)
        ],
      ),
    );
  }
}