import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../providers/music_provider.dart';
import '../../utils/helper.dart';

class SongInQueue extends StatelessWidget {
  const SongInQueue({
    Key? key,
    required this.song,
    required this.index,
  }) : super(key: key);
  final Song song;
  final int index;

  @override
  Widget build(BuildContext context) {
    final image = getImageFromUrl(song.coverImageUrl);

    return Container(
      color: Colors.black,
      child: ListTile(
        title: Text(
          song.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          song.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: Image(image: image),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Icon(CupertinoIcons.line_horizontal_3, size: 30),
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.standard,
        horizontalTitleGap: 12,
        onTap: () {
          context.read<MusicProvider>().playNewSong(song);
        },
      ),
    );
  }
}
