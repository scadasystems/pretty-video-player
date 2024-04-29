import 'package:example/animation_player/data_manager.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimationPlayerLandscapeControls extends StatelessWidget {
  const AnimationPlayerLandscapeControls({Key? key, required this.animationPlayerDataManager}) : super(key: key);

  final AnimationPlayerDataManager animationPlayerDataManager;

  @override
  Widget build(BuildContext context) {
    PrettyVideoManager flickVideoManager = Provider.of<PrettyVideoManager>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: Colors.transparent,
      child: DefaultTextStyle(
        style: TextStyle(
          color: Colors.white,
        ),
        child: IconTheme(
          data: IconThemeData(color: Colors.white, size: 40),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      (animationPlayerDataManager).playNextVideo();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PrettyShowControlsAction(
                  child: PrettySeekVideoAction(
                    child: Center(
                      child: flickVideoManager.nextVideoAutoPlayTimer != null
                          ? PrettyAutoPlayCircularProgress(
                              colors: PrettyAutoPlayTimerProgressColors(),
                            )
                          : PrettyVideoBuffer(),
                    ),
                  ),
                ),
              ),
              PrettyAutoHideChild(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (animationPlayerDataManager).getCurrentVideoTitle(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PrettyVideoProgressBar(
                      flickProgressBarSettings: PrettyProgressBarSettings(height: 5),
                    ),
                    Row(
                      children: [
                        PrettyPlayToggle(size: 30),
                        SizedBox(
                          width: 10,
                        ),
                        PrettySoundToggle(size: 30),
                        SizedBox(
                          width: 20,
                        ),
                        DefaultTextStyle(
                          style: TextStyle(color: Colors.white54),
                          child: Row(
                            children: <Widget>[
                              PrettyCurrentPosition(
                                fontSize: 16,
                              ),
                              Text('/'),
                              PrettyTotalDuration(
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        PrettyFullScreenToggle(
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
