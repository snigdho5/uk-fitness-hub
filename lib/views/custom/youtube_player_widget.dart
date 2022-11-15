import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;
  const YoutubePlayerWidget({
    Key? key,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    debugPrint('init youtube player');

    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    )..onInit = () async {
        await _controller
            .loadVideoById(
                videoId:
                    YoutubePlayerController.convertUrlToId(widget.videoUrl) ??
                        "")
            .onError((error, stackTrace) {
          debugPrint('error: $error');
          debugPrint('stackTrace: $stackTrace');
        });
      };
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
