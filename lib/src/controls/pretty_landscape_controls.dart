import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';

/// Default landscape controls.
class PrettyLandscapeControls extends StatelessWidget {
  const PrettyLandscapeControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrettyPortraitControls(
      fontSize: 14,
      iconSize: 30,
      progressBarSettings: PrettyProgressBarSettings(
        height: 5,
      ),
    );
  }
}
