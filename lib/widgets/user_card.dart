import 'package:aims_mobile/models/user_model.dart';
import 'package:aims_mobile/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({Key key,
    @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          user.imageUrl != null ? ProfileAvatar(imageUrl: user.imageUrl) : ProfileAvatar(imageUrl: "https://www.nicepng.com/png/detail/856-8561030_silhouette-gender-neutral-head-silhouette.png"),
          const SizedBox(width: 6.0),
          Flexible(
            child: Text(user.name,
              style: const TextStyle(fontSize: 16.0),
              overflow: TextOverflow.ellipsis,),
          )
        ],
      ),
    );
  }
}
