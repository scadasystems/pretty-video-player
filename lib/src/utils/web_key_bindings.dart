import 'package:pretty_video_player/src/manager/pretty_manager.dart';
import 'package:universal_html/html.dart';

void prettyDefaultWebKeyDownHandler(KeyboardEvent event, PrettyManager prettyManager) {
  if (event.keyCode == 70) {
    prettyManager.prettyControlManager?.toggleFullscreen();
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 77) {
    prettyManager.prettyControlManager?.toggleMute();
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 39) {
    prettyManager.prettyControlManager?.seekForward(Duration(seconds: 10));
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 37) {
    prettyManager.prettyControlManager?.seekBackward(Duration(seconds: 10));
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 32) {
    prettyManager.prettyControlManager?.togglePlay();
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 38) {
    prettyManager.prettyControlManager?.increaseVolume(0.05);
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  } else if (event.keyCode == 40) {
    prettyManager.prettyControlManager?.decreaseVolume(0.05);
    prettyManager.prettyDisplayManager?.handleShowPlayerControls();
  }
}
