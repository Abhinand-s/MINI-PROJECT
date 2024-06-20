import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PLayerScreen extends StatefulWidget {
  const PLayerScreen({super.key, required this.videoId});

  final String videoId;

  @override
  State<PLayerScreen> createState() => _PLayerScreenState();
}

class _PLayerScreenState extends State<PLayerScreen> {
  late final YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    flags: const  YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
    ),
);
@override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Player")),
      body: YoutubePlayer(controller: _controller),
    );
  }
}