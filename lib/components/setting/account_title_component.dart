import 'package:flutter/material.dart';
import 'package:spotify/pages/profile.dart';
import '../../models/user.dart';
class AccountTitle extends StatelessWidget {
  const AccountTitle({Key? key, required this.user, required this.label}) : super(key: key);
  final User user;
  final String label;
  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    late String title;
    final url = user.coverImageUrl;
    if (url.startsWith('https')) {
      image = NetworkImage(url);
    } else {
      image = AssetImage(url);
    }
    if(label == 'UserName'){
      title = user.name;
    }
    if(label == 'Id'){
      title = user.id;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      color: Colors.black,
      child: ListTile(
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.standard,
        horizontalTitleGap: 12,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              //return const SearchPlayList();
              return ProfilePage(
                  image: image, label: user.name);
            }),
          );
        },
      ),
    );
  }
}