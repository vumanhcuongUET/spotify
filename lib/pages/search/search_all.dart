import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/components/search/recent_search_item.dart';
import 'package:spotify/components/search/search_item.dart';
import 'package:spotify/components/search/song_search.dart';
import 'package:spotify/pages/music/playlist/playlist_view.dart';
import 'package:spotify/pages/music/song_action.dart';
import 'package:spotify/providers/data_provider.dart';

import '../../components/actions/action_button.dart';
import '../../components/library/close_button.dart';
import '../../components/library/filter_button.dart';
import '../../utils/helper.dart';
import '../music/album/album_view.dart';
import '../music/artist/artist_view.dart';

class SearchAll extends StatefulWidget {
  const SearchAll({Key? key}) : super(key: key);

  @override
  State<SearchAll> createState() => _SearchAllState();
}

class _SearchAllState extends State<SearchAll> {
  final filterOptions = ['Top', 'Playlists', 'Songs', 'Artists', 'Albums'];
  int _currentFilterOption = 0;
  List playlists = [];
  List recentSearch = [];
  List searchResult = [];
  bool isSearch = false;

  @override
  void initState() {
    isSearch = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    playlists = [
      ...context.watch<DataProvider>().albums,
      ...context.watch<DataProvider>().artists,
      ...context.watch<DataProvider>().songs,
      ...context.watch<DataProvider>().systemPlaylists,
      ...context.watch<DataProvider>().customizedPlaylists,
    ];
    recentSearch = [
      ...context.watch<DataProvider>().recentSearchList,
    ];

    final filteredList = searchResult
        .where((element) =>
            _currentFilterOption == 0 ||
            filterOptions[_currentFilterOption]
                .toLowerCase()
                .contains('${element.runtimeType.toString().toLowerCase()}s'))
        .toList();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 38,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      textAlign: TextAlign.left,
                      onChanged: _runSearch,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        fillColor: const Color.fromRGBO(36, 36, 36, 1),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20,
                        ),
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      cursorColor: const Color(0xff57b660),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (isSearch)
                _buildFiltersSection()
              else
                const Padding(
                  padding: EdgeInsets.only(bottom: 10, right: 10, top: 20),
                  child: Text(
                    'Recent searches',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: isSearch
                    ? _buildListView(filteredList)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ..._buildRecentSearchList(recentSearch),
                            if (!isSearch && recentSearch.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, right: 10, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<DataProvider>()
                                        .clearRecentSearchList();
                                  },
                                  child: const Text(
                                    'Clear recent searches',
                                    style: TextStyle(
                                      color: Colors.white38,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
        child: Row(
          children: _currentFilterOption == 0
              ? filterOptions
                  .map((option) => GestureDetector(
                        child: FilterButton(
                          title: option,
                          active: false,
                        ),
                        onTap: () => setState(() {
                          _currentFilterOption = filterOptions.indexOf(option);
                        }),
                      ))
                  .toList()
              : [
                  GestureDetector(
                    child: const CustomCloseButton(),
                    onTap: () => setState(() {
                      _currentFilterOption = 0;
                    }),
                  ),
                  GestureDetector(
                    child: FilterButton(
                      title: filterOptions[_currentFilterOption],
                      active: true,
                    ),
                    onTap: () => setState(() {
                      _currentFilterOption = 0;
                    }),
                  ),
                ],
        ),
      ),
    );
  }

  void _runSearch(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        isSearch = false;
      });
    } else {
      playlists.sort((a, b) => a.name.compareTo(b.name));

      final subListOne = playlists
          .where((element) =>
              element.name.toLowerCase().contains(keyword.toLowerCase()) &&
              !element.name.toLowerCase().startsWith(keyword))
          .toList();

      final subListTwo = playlists
          .where((element) => element.name.toLowerCase().startsWith(keyword))
          .toList();

      final results = [...subListTwo, ...subListOne];

      setState(() {
        isSearch = true;
        searchResult = results;
      });
    }
  }

  Widget _buildListView(List list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return item.runtimeType.toString() == 'Song'
            ? SongSearch(
                song: item,
                trailing: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ActionButton(
                    song: item,
                    size: 20,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => SongAction(song: item),
                        ),
                      );
                    },
                  ),
                ),
              )
            : GestureDetector(
                child: SearchItem(
                  title: item.name,
                  subtitle: item.runtimeType.toString(),
                  coverUrl: item.coverImageUrl,
                  isSquareCover: item.runtimeType.toString() != 'Artist',
                ),
                onTap: () => onTap(item),
              );
      },
    );
  }

  List<Widget> _buildRecentSearchList(List list) {
    return list.map((item) {
      return item.runtimeType.toString() == 'Song'
          ? SongSearch(
              song: item,
              trailing: IconButton(
                onPressed: () {
                  context.read<DataProvider>().deleteFromRecentSearchList(item);
                },
                icon: const Icon(Icons.close),
              ),
            )
          : GestureDetector(
              child: RecentSearchItem(
                id: item.id,
                title: item.name,
                subtitle: item.runtimeType.toString(),
                coverUrl: item.coverImageUrl,
                isSquareCover: item.runtimeType.toString() != 'Artist',
                onPressed: () {
                  context.read<DataProvider>().deleteFromRecentSearchList(item);
                },
              ),
              onTap: () => onTap(item),
            );
    }).toList();
  }

  void onTap(item) {
    context.read<DataProvider>().addToRecentSearchList(item);
    final image = getImageFromUrl(item.coverImageUrl);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (item.runtimeType.toString()) {
            case 'Playlist':
              return PlaylistView(playlist: item, image: image);

            case 'Album':
              return AlbumView(
                album: item,
                image: image,
                description: item.description,
              );

            default:
              return ArtistView(artist: item, image: image);
          }
        },
      ),
    );
  }
}
