import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/song.dart';
import '../../providers/data_provider.dart';

class PlaylistComponent extends StatelessWidget {
  const PlaylistComponent({
    Key? key,
    required this.label,
    required this.id,
    this.onTap,
    required this.type,
    required this.songList,
    this.addSong,
  }) : super(key: key);

  final String label;
  final String id;
  final void Function()? onTap;
  final void Function()? addSong;
  final String type;
  final List<Song> songList;
  @override
  Widget build(BuildContext context) {
    final favoritePlaylistList =
        context.watch<DataProvider>().favoritePlaylists;

    final isUserPlayLists = type == 'user';

    final isFavorite = favoritePlaylistList.any((element) => element.id == id);
    final user = context.watch<DataProvider>().user;
    // final image = getImageFromUrl(user.coverImageUrl);
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 20, top: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Image(
                image: AssetImage('assets/images/logo_spotify.png'),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 7),
              if (isUserPlayLists)
                const Text('My playlist',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
              else
                const Text('Spotify',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            if (!isUserPlayLists)
              GestureDetector(
                onTap: addSong,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    size: 22,
                    color: isFavorite ? Colors.green : Colors.white,
                  ),
                ),
              ),
            const Icon(Icons.more_horiz, size: 22),
            if (isUserPlayLists && user.id != id)
              GestureDetector(
                onTap: addSong,
                child: const Padding(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
          ],
        )
      ]),
    );
  }
}
