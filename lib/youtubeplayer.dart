import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeP extends StatefulWidget {
  YoutubeP({super.key, required this.youtubeUrl, required this.width});
  final String youtubeUrl;
  final double width;

  @override
  State<YoutubeP> createState() => _YoutubePState();
}

class _YoutubePState extends State<YoutubeP> {
  late YoutubePlayerController controller;
  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    controller = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: const YoutubePlayerFlags(autoPlay: false));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      width: widget.width * 0.9,
    );
  }
}
