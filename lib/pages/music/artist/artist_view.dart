import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/components/album/play_button.dart';
import 'package:spotify/components/album/song_tile.dart';
import 'package:spotify/components/artist/artist_component.dart';
import 'package:spotify/components/artist/back_button.dart';
import 'package:spotify/models/artist.dart';
import 'package:spotify/providers/data_provider.dart';

import '../../../components/album/animate_label.dart';
import '../../../components/album/opacity_image.dart';
import '../../../models/song.dart';
import '../../../providers/music_provider.dart';
import '../../../utils/db.dart';
import '../../../utils/helper.dart';
import '../../others/loading.dart';

class ArtistView extends StatefulWidget {
  const ArtistView({
    Key? key,
    required this.artist,
    required this.image,
  }) : super(key: key);

  final Artist artist;
  final ImageProvider image;

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  late ScrollController scrollController;
  double imageSize = 0;
  double initialImageSize = 250;
  double containerHeight = 500;
  double containerInitialHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;

  Color _color = Colors.black;
  List<Song> songList = [];
  bool _loading = true;

  @override
  void initState() {
    imageSize = initialImageSize;
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = initialImageSize - scrollController.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }
        containerHeight = containerInitialHeight - scrollController.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialImageSize;
        if (scrollController.offset > 100) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
        // print(imageSize);
        setState(() {});
      });
    super.initState();

    fetchSongs();
  }

  Future<void> fetchSongs() async {
    if (widget.artist.songIdList.isNotEmpty) {
      Future.wait(
        widget.artist.songIdList.map((id) => Database.getSongById(id)),
      ).then((songs) {
        setState(() {
          songList = songs;
          _loading = false;
        });
      });
    }
  }

  Future loadPlaylist() async {
    final currentPlaylistId =
        Provider.of<MusicProvider>(context, listen: false).currentPlaylistId;

    if (songList.isNotEmpty && currentPlaylistId != widget.artist.id) {
      await context.read<MusicProvider>().loadPlaylist(songList);

      context
          .read<MusicProvider>()
          .updateCurrentPlaylist(widget.artist.id, widget.artist.name);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_color == Colors.black) {
      getColorFromImage(widget.image).then((color) {
        if (color != null) {
          setState(() {
            _color = color;
          });
        }
      });
    }

    if (_loading || songList.isEmpty) {
      return const LoadingScreen();
    }
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: containerHeight,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _color.withOpacity(1),
                    _color.withOpacity(0.7),
                    _color.withOpacity(0.5),
                    _color.withOpacity(0.3),
                    // Colors.black.withOpacity(0.1),
                    // Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(1),
                  ],
                ),
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 19,
                  ),
                  SafeArea(
                    child: OpacityImage(
                      imageOpacity: imageOpacity,
                      imageSize: imageSize,
                      image: widget.image,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _color.withOpacity(0),
                          _color.withOpacity(0),
                          _color.withOpacity(0),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          SizedBox(height: initialImageSize),
                          ArtistComponent(
                              artist: widget.artist,
                              onTap: () {
                                context
                                    .read<DataProvider>()
                                    .toggleFavoriteArtist(widget.artist);
                              })
                        ],
                      ),
                    ),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: songList.map((item) {
                            return GestureDetector(
                              onTap: () async {
                                await loadPlaylist();
                                context.read<MusicProvider>().playNewSong(item);
                                context
                                    .read<DataProvider>()
                                    .addToRecentlyPlayedList(widget.artist);
                              },
                              child: SongTile(song: item),
                            );
                          }).toList(),
                        ),
                      ]),
                  if (songList.length == 3) const SizedBox(height: 20),
                  if (songList.length == 2) const SizedBox(height: 80),
                  if (songList.length == 1) const SizedBox(height: 140)
                ],
              ),
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: showTopBar ? _color.withOpacity(1) : _color.withOpacity(0),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              child: SafeArea(
                child: SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  // alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const Positioned(
                        left: -5,
                        child: BackIconButton(),
                      ),
                      AnimateLabel(
                        label: widget.artist.name,
                        isShow: showTopBar,
                      ),
                      // Positioned(
                      //   right: 5,
                      //   bottom:
                      //   140 - containerHeight.clamp(170.0, double.infinity),
                      //   child: Stack(
                      //     alignment: Alignment.bottomRight,
                      //     children:  [
                      //       PLayButton(onTap: () {
                      //         loadPlaylist();
                      //       }),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(children: [
              Positioned(
                right: 12,
                top: containerHeight < containerInitialHeight
                    ? containerHeight.clamp(170, containerInitialHeight) - 140
                    : containerHeight.clamp(170, containerHeight) - 140,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    PLayButton(onTap: () async {
                      await loadPlaylist();
                      context.read<MusicProvider>().playWithIndex(0);
                      context
                          .read<DataProvider>()
                          .addToRecentlyPlayedList(widget.artist);
                    }),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// class ArtistView extends StatefulWidget {
//   final AssetImage image;
//   final String label;
//
//   const ArtistView({Key? key, required this.image, required this.label})
//       : super(key: key);
//
//   @override
//   State<ArtistView> createState() => _ArtistViewState();
// }
//
// class _ArtistViewState extends State<ArtistView> {
//   late ScrollController scrollController;
//   double imageSize = 300;
//   double containerHeight = 300;
//   double imageOpacity = 1;
//   bool showTopBar = false;
//
//   @override
//   void initState() {
//
//     scrollController = ScrollController()
//       ..addListener(() {
//         containerHeight = imageSize - scrollController.offset;
//         if (containerHeight < 0) {
//           containerHeight = 0;
//         }
//         imageOpacity = containerHeight  / imageSize;
//
//         if (scrollController.offset > 100) {
//           showTopBar = true;
//         } else {
//           showTopBar = false;
//         }
//         print(containerHeight);
//         setState(() {});
//       });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width,
//             // color: Colors.blue,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.white.withOpacity(0),
//                   Colors.white.withOpacity(0.2),
//                   Colors.white.withOpacity(0.5),
//                 ],
//               ),
//             ),
//             alignment: Alignment.center,
//             child: Column(
//               children: [
//                 SafeArea(
//                   child: Opacity(
//                     opacity: imageOpacity.clamp(0.2, 1.0),
//                     child: Image(
//                       image: widget.image,
//                       width: imageSize,
//                       height: imageSize,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SafeArea(
//             child: SingleChildScrollView(
//               controller: scrollController,
//               scrollDirection: Axis.vertical,
//               // physics: const BouncingScrollPhysics(),
//               child: Column(
//                 children: [
//                   Container(
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.black.withOpacity(0.1),
//                             Colors.black.withOpacity(0.2),
//                             Colors.black.withOpacity(0.3),
//                             Colors.black.withOpacity(0.5),
//                             Colors.black.withOpacity(1),
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SizedBox(height: imageSize - 100),
//                             ArtistComponent(label: widget.label),
//                           ],
//                         ),
//                       )),
//                   _buildListSong(),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               color: showTopBar
//                   ? const Color.fromARGB(251, 82, 71, 71).withOpacity(1)
//                   : const Color(0xffc858585).withOpacity(0),
//               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
//               child: SafeArea(
//                 child: SizedBox(
//                   height: 40,
//                   width: MediaQuery.of(context).size.width,
//                   // alignment: Alignment.center,
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: -5,
//                         child: IconButton(
//                           splashColor: Colors.transparent,
//                           highlightColor: Colors.transparent,
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(CupertinoIcons.chevron_back),
//                         ),
//                       ),
//                       AnimatedOpacity(
//                         duration: const Duration(milliseconds: 200),
//                         opacity: showTopBar ? 1 : 0,
//                         child: Container(
//                           padding: const EdgeInsets.only(left: 50, right: 50),
//                           child: Text(
//                             widget.label,
//                             // style: Theme.of(context).textTheme.headline6,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.4,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 5,
//                         bottom:
//                         0 - containerHeight.clamp(30.0, double.infinity),
//                         child: Stack(
//                           alignment: Alignment.bottomRight,
//                           children: const [
//                             PLayButton(),
//                             ShuffleButton(),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
