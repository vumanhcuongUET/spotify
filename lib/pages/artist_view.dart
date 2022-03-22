import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify/components/album/play_button.dart';
import 'package:spotify/components/album/shuffle_button.dart';
import 'package:spotify/components/album/song_tile.dart';
import 'package:spotify/components/artist/artist_component.dart';

import '../models/song.dart';

import 'package:palette_generator/palette_generator.dart';


class ArtistView extends StatefulWidget {
  final AssetImage image;
  final String label;

  const ArtistView({Key? key, required this.image, required this.label})
      : super(key: key);

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

  Color? _color = Colors.black;

  @override
  void initState() {
    imageSize = initialImageSize;
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = initialImageSize - scrollController.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }

        // if (imageSize > MediaQuery.of(context).size.width - 10) {
        //   imageSize = MediaQuery.of(context).size.width;
        // }
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
        print(imageSize);
        setState(() {});
      });
    super.initState();
    PaletteGenerator.fromImageProvider(widget.image).then((generator) {
      setState(() {
        _color = generator.mutedColor!.color;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: containerHeight,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _color!.withOpacity(1),
                    _color!.withOpacity(0.7),
                    _color!.withOpacity(0.5),
                    _color!.withOpacity(0.3),
                    // Colors.black.withOpacity(0.1),
                    // Colors.transparent,
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(1),
                  ]
              ),
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 19,
                ),
                SafeArea(
                  child: Opacity(
                    opacity: imageOpacity.clamp(0, 1.0),
                    child: Container(

                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:Colors.black.withOpacity(.6),
                            offset: const Offset(0, 10),
                            blurRadius: 20,
                            spreadRadius: 10,
                          )
                        ],
                      ),
                      child: Image(
                        // image: widget.image,
                        image: widget.image,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
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
                              _color!.withOpacity(0),
                              _color!.withOpacity(0),
                              _color!.withOpacity(0),
                            ]
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: initialImageSize),
                            ArtistComponent(label: widget.label),
                          ],
                        ),
                      )),
                  _buildListSong(),
                ],
              ),
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color: showTopBar
                  ? _color!.withOpacity(1)
                  : _color!.withOpacity(0),
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
                      Positioned(
                        left: -5,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(CupertinoIcons.chevron_back),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: showTopBar ? 1 : 0,
                        child: Container(
                          padding: const EdgeInsets.only(left: 50, right: 50),
                          child: Text(
                            widget.label,
                            // style: Theme.of(context).textTheme.headline6,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom:
                        140 - containerHeight.clamp(170.0, double.infinity),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: const [
                            PLayButton(),
                            ShuffleButton(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
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

_buildListSong() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: songList.map((item) {
      return SongTile(
          song: Song(item['name']!, item['description']!, item['coverUrl']!));
    }).toList(),
  );
}

final songList = [
  {
    'name': "K/DA",
    'description': "Riot",
    'coverUrl': "assets/images/home/kda.jpg",
  },
  {
    'name': "Big City Boi",
    'description': "Binz",
    'coverUrl': "assets/images/home/big-city-boi.jpg",
  },
  {
    'name': "DNA",
    'description': "BTS",
    'coverUrl': "assets/images/home/dna.jpg",
  },
  {
    'name': "Latata",
    'description': "G(I)-DLE",
    'coverUrl': "assets/images/home/latata.jpg",
  },
  {
    'name': "Chilled",
    'description': "Nhạc nhẹ",
    'coverUrl': "assets/images/home/chilled.jpg",
  },
  {
    'name': "Ái nộ",
    'description': "Masew",
    'coverUrl': "assets/images/home/ai-no.jpg",
  },
  {
    'name': "Relax",
    'description': "Album2",
    'coverUrl': "assets/images/home/album2.jpg",
  },
  {
    'name': "Mang tiền về cho mẹ",
    'description': "Đen vâu",
    'coverUrl': "assets/images/den-vau.jpeg",
  },
  {
    'name': "Maroon5",
    'description': "Binz",
    'coverUrl': "assets/images/maroon5.jpeg",
  },
  {
    'name': "Cảm ơn",
    'description': "Đen",
    'coverUrl': "assets/images/cam-on.jpg",
  },
];