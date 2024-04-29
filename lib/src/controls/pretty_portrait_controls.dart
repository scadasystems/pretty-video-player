import 'package:flutter/material.dart';
import 'package:pretty_video_player/pretty_video_player.dart';

/// Default portrait controls.
class PrettyPortraitControls extends StatelessWidget {
  const PrettyPortraitControls({Key? key, this.iconSize = 20, this.fontSize = 12, this.progressBarSettings})
      : super(key: key);

  /// Icon size.
  ///
  /// This size is used for all the player icons.
  final double iconSize;

  /// Font size.
  ///
  /// This size is used for all the text.
  final double fontSize;

  /// [PrettyProgressBarSettings] settings.
  final PrettyProgressBarSettings? progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: PrettyShowControlsAction(
            child: PrettySeekVideoAction(
              child: Center(
                child: PrettyVideoBuffer(
                  child: PrettyAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: PrettyPlayToggle(
                      size: 30,
                      color: Colors.black,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
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
                    prettyProgressBarSettings: progressBarSettings,
                  ),
                  Row(
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
                      PrettySubtitleToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      PrettyFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
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
