import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Returns a text widget with total duration of the video.
class PrettyTotalDuration extends StatelessWidget {
  const PrettyTotalDuration({
    Key? key,
    this.fontSize,
    this.color,
  }) : super(key: key);

  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    PrettyVideoManager videoManager = Provider.of<PrettyVideoManager>(context);

    Duration? duration = videoManager.videoPlayerValue?.duration;

    String? durationInSeconds = duration != null
        ? (duration - Duration(minutes: duration.inMinutes)).inSeconds.toString().padLeft(2, '0')
        : null;

    String textDuration = duration != null ? '${duration.inMinutes}:$durationInSeconds' : '0:00';

    return Text(
      textDuration,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}
