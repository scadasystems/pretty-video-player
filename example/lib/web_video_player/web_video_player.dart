import 'package:example/utils/mock_data.dart';
import 'package:example/web_video_player/web_video_control.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'data_manager.dart';

class WebVideoPlayer extends StatefulWidget {
  WebVideoPlayer({Key? key}) : super(key: key);

  @override
  _WebVideoPlayerState createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late PrettyManager flickManager;
  late DataManager? dataManager;

  @override
  void initState() {
    super.initState();
    flickManager = PrettyManager(
      videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(mockData["items"][1]["trailer_url"])),
    );
    List<String> urls = (mockData["items"] as List).map<String>((item) => item["trailer_url"]).toList();

    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Container(
        child: PrettyVideoPlayer(
          flickManager: flickManager,
          flickVideoWithControls: PrettyVideoWithControls(
            controls: WebVideoControl(
              dataManager: dataManager!,
              iconSize: 30,
              fontSize: 14,
              progressBarSettings: PrettyProgressBarSettings(
                height: 5,
                handleRadius: 5.5,
              ),
            ),
            videoFit: BoxFit.contain,
            // aspectRatioWhenLoading: 4 / 3,
          ),
        ),
      ),
    );
  }
}
