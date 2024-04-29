import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Returns a text widget with current position of the video.
class PrettyCurrentPosition extends StatelessWidget {
  const PrettyCurrentPosition({
    Key? key,
    this.fontSize,
    this.color,
  }) : super(key: key);

  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    PrettyVideoManager videoManager = Provider.of<PrettyVideoManager>(context);

    Duration? position = videoManager.videoPlayerValue?.position;

    String? positionInSeconds = position != null
        ? (position - Duration(minutes: position.inMinutes)).inSeconds.toString().padLeft(2, '0')
        : null;

    String textPosition = position != null ? '${position.inMinutes}:$positionInSeconds' : '0:00';

    return Text(
      textPosition,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}
