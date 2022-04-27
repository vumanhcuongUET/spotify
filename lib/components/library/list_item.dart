import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.coverUrl,
    required this.isSquareCover,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String coverUrl;
  final bool isSquareCover;

  @override
  Widget build(BuildContext context) {
    final ImageProvider image;

    if (coverUrl.startsWith('https')) {
      image = NetworkImage(coverUrl);
    } else {
      image = AssetImage(coverUrl);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        leading: isSquareCover
            ? Image(image: image)
            : CircleAvatar(foregroundImage: image, radius: 28),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
