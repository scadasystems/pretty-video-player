import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data_manager.dart';

class CustomOrientationControls extends StatelessWidget {
  const CustomOrientationControls({Key? key, this.iconSize = 20, this.fontSize = 12, this.dataManager})
      : super(key: key);
  final double iconSize;
  final double fontSize;
  final DataManager? dataManager;

  @override
  Widget build(BuildContext context) {
    PrettyVideoManager flickVideoManager = Provider.of<PrettyVideoManager>(context);

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: PrettyAutoHideChild(
            child: Container(color: Colors.black38),
          ),
        ),
        Positioned.fill(
          child: PrettyShowControlsAction(
            child: PrettySeekVideoAction(
              child: Center(
                child: flickVideoManager.nextVideoAutoPlayTimer != null
                    ? PrettyAutoPlayCircularProgress(
                        colors: PrettyAutoPlayTimerProgressColors(
                          backgroundColor: Colors.white30,
                          color: Colors.red,
                        ),
                      )
                    : PrettyAutoHideChild(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  dataManager!.skipToPreviousVideo();
                                },
                                child: Icon(
                                  Icons.skip_previous,
                                  color: dataManager!.hasPreviousVideo() ? Colors.white : Colors.white38,
                                  size: 35,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PrettyPlayToggle(size: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  dataManager!.skipToNextVideo();
                                },
                                child: Icon(
                                  Icons.skip_next,
                                  color: dataManager!.hasNextVideo() ? Colors.white : Colors.white38,
                                  size: 35,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: PrettyAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          PrettyCurrentPosition(
                            fontSize: fontSize,
                          ),
                          Text(
                            ' / ',
                            style: TextStyle(color: Colors.white, fontSize: fontSize),
                          ),
                          PrettyTotalDuration(
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      PrettyFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
                  ),
                  PrettyVideoProgressBar(
                    flickProgressBarSettings: PrettyProgressBarSettings(
                      height: 5,
                      handleRadius: 5,
                      curveRadius: 50,
                      backgroundColor: Colors.white24,
                      bufferedColor: Colors.white38,
                      playedColor: Colors.red,
                      handleColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
