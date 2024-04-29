import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './multi_manager/flick_multi_manager.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls({Key? key, this.flickMultiManager, this.flickManager}) : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final PrettyManager? flickManager;

  @override
  Widget build(BuildContext context) {
    PrettyDisplayManager displayManager = Provider.of<PrettyDisplayManager>(context);
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          PrettyAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PrettyLeftDuration(),
              ),
            ),
          ),
          Expanded(
            child: PrettyToggleSoundAction(
              toggleMute: () {
                flickMultiManager?.toggleMute();
                displayManager.handleShowPlayerControls();
              },
              child: PrettySeekVideoAction(
                child: Center(child: PrettyVideoBuffer()),
              ),
            ),
          ),
          PrettyAutoHideChild(
            autoHide: true,
            showIfVideoNotInitialized: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: PrettySoundToggle(
                    toggleMute: () => flickMultiManager?.toggleMute(),
                    color: Colors.white,
                  ),
                ),
                // FlickFullScreenToggle(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
