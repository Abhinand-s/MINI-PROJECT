import 'package:flutter/material.dart';
import 'package:signup_login/Entertainment/player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final videoUrls = [
  'https://youtu.be/hxOApe1P9dM?si=dGLnV7r3_TOBzGX-',
  'https://youtu.be/zS1KiLLYVBA?si=sNK1HT_yJYI-TaGo',
  'https://youtu.be/TtkWVhmAdn4?si=4vBC6q4tRL6yaskM',
  'https://youtu.be/AfXyOjh2vHo?si=tsMaA1me-h4EDxXV',
  'https://youtu.be/hq3yfQnllfQ?si=5pSzFrfJJaosGXD3',
  'https://youtu.be/x4kdosN-zVk?si=R57hFKKLugT_VyXn'
];

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Videos"),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          final videoID = YoutubePlayer.convertUrlToId(videoUrls[index]);

          return InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PLayerScreen(videoId: videoID)));
            },
              child:
                  Image.network(YoutubePlayer.getThumbnail(videoId: videoID!)));
        },
      ),
    );
  }

  Widget thubmNail() {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(10),
      color: Colors.blue,
      child: const Center(
        child: Text("THUMBNAIL"),
      ),
    );
  }
}
