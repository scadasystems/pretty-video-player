import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shows a widget when the video is buffering (and video is playing).
class PrettyVideoBuffer extends StatelessWidget {
  const PrettyVideoBuffer({
    Key? key,
    this.bufferingChild = const CircularProgressIndicator(),
    this.child,
  }) : super(key: key);

  /// Widget to be shown when the video is buffering.
  final Widget bufferingChild;

  /// Widget to be shown when the video is not buffering.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    PrettyVideoManager videoManager = Provider.of<PrettyVideoManager>(context);

    return Container(
      child: (videoManager.isBuffering && videoManager.isPlaying) ? bufferingChild : child,
    );
  }
}
