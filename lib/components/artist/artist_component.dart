import 'package:flutter/material.dart';

class ArtistComponent extends StatelessWidget {
  final String label;

  const ArtistComponent({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 13, right: 25, top: 20, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 20, top: 10),
        child: Text(
          "3 999 999 followers",
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, right: 20, top: 10),
        child: Row(
          children: const [
            Icon(
              Icons.favorite_outline_rounded,
              size: 22,
            ),
            SizedBox(width: 15),
            Icon(
              Icons.more_horiz,
              size: 22,
            ),
          ],
        ),
      )
    ]);
  }
}
