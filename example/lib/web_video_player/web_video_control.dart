import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';

import 'data_manager.dart';

/// Default portrait controls.
class WebVideoControl extends StatelessWidget {
  const WebVideoControl({Key? key, this.iconSize = 20, this.fontSize = 12, this.progressBarSettings, this.dataManager})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// [dataManager] is used to handle video controls.
  final DataManager? dataManager;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [PrettyProgressBarSettings] settings.
  final PrettyProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return PrettyShowControlsActionWeb(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: PrettyAnimatedVolumeLevel(
                decoration: BoxDecoration(
                  color: Colors.black26,
                ),
                textStyle: TextStyle(color: Colors.white, fontSize: 20),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
            ),
          ),
          Positioned.fill(
            child: PrettySeekVideoAction(
              child: Center(
                child: PrettyVideoBuffer(
                  child: PrettyAutoHideChild(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    PrettyVideoProgressBar(
                      flickProgressBarSettings: progressBarSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          PrettyPlayToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          PrettySoundToggle(
                            size: iconSize,
                          ),
                          SizedBox(
                            width: iconSize / 2,
                          ),
                          Row(
                            children: <Widget>[
                              PrettyCurrentPosition(
                                fontSize: fontSize,
                              ),
                              PrettyAutoHideChild(
                                child: Text(
                                  ' / ',
                                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                                ),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
