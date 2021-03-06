import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/components/actions/action_button.dart';
import 'package:spotify/utils/helper.dart';

import '../../models/song.dart';
import '../../pages/music/song_action.dart';
import '../../providers/music_provider.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    Key? key,
    required this.song,
  }) : super(key: key);
  final Song song;

  @override
  Widget build(BuildContext context) {
    final currentSong = context.watch<MusicProvider>().currentSong;

    final isCurrent =
        (currentSong != null ? currentSong.name : '') == song.name;

    final image = getImageFromUrl(song.coverImageUrl);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      color: Colors.black,
      child: ListTile(
        title: Text(
          song.name,
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
            color: isCurrent ? Colors.green : Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          song.description,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: Image(
          image: image,
          fit: BoxFit.cover,
        ),
        trailing: Padding(
          padding: const EdgeInsets.all(10),
          child: ActionButton(
            song: song,
            size: 20,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => SongAction(song: song),
                ),
              );
            },
          ),
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.standard,
        horizontalTitleGap: 12,
      ),
    );
  }
}
