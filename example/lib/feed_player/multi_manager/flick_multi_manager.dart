import 'package:pretty_video_player/pretty_video_player.dart';

class FlickMultiManager {
  List<PrettyManager> _flickManagers = [];
  PrettyManager? _activeManager;
  bool _isMute = false;

  init(PrettyManager flickManager) {
    _flickManagers.add(flickManager);
    if (_isMute) {
      flickManager.flickControlManager?.mute();
    } else {
      flickManager.flickControlManager?.unmute();
    }
    if (_flickManagers.length == 1) {
      play(flickManager);
    }
  }

  remove(PrettyManager flickManager) {
    if (_activeManager == flickManager) {
      _activeManager = null;
    }
    flickManager.dispose();
    _flickManagers.remove(flickManager);
  }

  togglePlay(PrettyManager flickManager) {
    if (_activeManager?.flickVideoManager?.isPlaying == true && flickManager == _activeManager) {
      pause();
    } else {
      play(flickManager);
    }
  }

  pause() {
    _activeManager?.flickControlManager?.pause();
  }

  play([PrettyManager? flickManager]) {
    if (flickManager != null) {
      _activeManager?.flickControlManager?.pause();
      _activeManager = flickManager;
    }

    if (_isMute) {
      _activeManager?.flickControlManager?.mute();
    } else {
      _activeManager?.flickControlManager?.unmute();
    }

    _activeManager?.flickControlManager?.play();
  }

  toggleMute() {
    _activeManager?.flickControlManager?.toggleMute();
    _isMute = _activeManager?.flickControlManager?.isMute ?? false;
    if (_isMute) {
      _flickManagers.forEach((manager) => manager.flickControlManager?.mute());
    } else {
      _flickManagers.forEach((manager) => manager.flickControlManager?.unmute());
    }
  }
}
