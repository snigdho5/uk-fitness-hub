import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  const YoutubePlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    debugPrint('init youtube player');
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl) ?? "",
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: false,
        showControls: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: YoutubePlayer(
        controller: _controller,
        enableFullScreenOnVerticalDrag: false,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class YoutubeeFullScreenPage extends StatefulWidget {
  final YoutubePlayerController controller;
  const YoutubeeFullScreenPage({super.key, required this.controller});

  @override
  State<YoutubeeFullScreenPage> createState() => _YoutubeeFullScreenPageState();
}

class _YoutubeeFullScreenPageState extends State<YoutubeeFullScreenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: YoutubePlayerControllerProvider(
      controller: widget.controller,
      child: YoutubePlayer(
        controller: widget.controller,
        enableFullScreenOnVerticalDrag: false,
        backgroundColor: Colors.transparent,
      ),
    ));
  }
}
