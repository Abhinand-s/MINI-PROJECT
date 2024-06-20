import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:signup_login/Entertainment/player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: CategoryList(),
  ));
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Map<String, List<String>>? categoryVideos;
  String? error;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://script.google.com/macros/s/AKfycbwrCKRS_oaM6YIDPLwrFxTgr1yLenEB0u2bsYHQj7-SpIcGZg1lRKtUS7sG2brSoZ4S/exec'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body)['data'];
        setState(() {
          categoryVideos = {};
          for (var item in data) {
            String category = item['category'].toString();
            String link = item['link'].toString();
            if (!categoryVideos!.containsKey(category)) {
              categoryVideos![category] = [];
            }
            categoryVideos![category]!.add(link);
          }
          error = null;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        error = 'Failed to load data';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category List'),
        backgroundColor: const Color.fromARGB(255, 203, 183, 237), // Change the color of the AppBar
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : ListView.builder(
                  itemCount: categoryVideos!.keys.length,
                  itemBuilder: (context, index) {
                    String category = categoryVideos!.keys.elementAt(index);
                    return Card( // Wrap ListTile with a Card
                      elevation: 5, // Give some elevation to the Card
                      margin: EdgeInsets.all(10), // Add some margin to the Card
                      child: ListTile(
                        title: Text(category, style: TextStyle(fontSize: 20)), // Increase the font size
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VideoList(videos: categoryVideos![category]!)),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class VideoList extends StatelessWidget {
  final List<String> videos;

  VideoList({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PLayerScreen(videoId: YoutubePlayer.convertUrlToId(videos[index])!)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.network(
                    YoutubePlayer.getThumbnail(videoId: YoutubePlayer.convertUrlToId(videos[index])!),
                    width: 370,  // specify the width
                    height: 320, // specify the height
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
