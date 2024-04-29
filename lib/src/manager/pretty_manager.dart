library pretty_manager;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

part 'client_channels.dart';
part 'control_manager.dart';
part 'display_manager.dart';
part 'video_manager.dart';

/// Manages [VideoPlayerController] and operations on it.
class PrettyManager {
  PrettyManager({
    this.onVideoEnd,
    GetPlayerControlsTimeout? getPlayerControlsTimeout,
    required VideoPlayerController videoPlayerController,

    /// Auto initialize the video.
    bool autoInitialize = true,

    /// Auto-play video once initialized.
    bool autoPlay = true,
  }) : this.getPlayerControlsTimeout = getPlayerControlsTimeout ?? getPlayerControlsTimeoutDefault {
    _prettyControlManager = PrettyControlManager(
      prettyManager: this,
    );
    _prettyVideoManager = PrettyVideoManager(prettyManager: this, autoPlay: autoPlay, autoInitialize: autoInitialize);
    _prettyDisplayManager = PrettyDisplayManager(
      prettyManager: this,
    );
    _prettyVideoManager!._handleChangeVideo(videoPlayerController);
  }

  PrettyVideoManager? _prettyVideoManager;
  PrettyControlManager? _prettyControlManager;
  PrettyDisplayManager? _prettyDisplayManager;
  BuildContext? _context;

  /// Video end callback, change the video in this callback.
  Function? onVideoEnd;

  /// Player controls auto-hide timeout callback, called when player state changes.
  ///
  /// Duration returned by this function is used to auto-hide controls.
  /// Defaults to if (errorInVideo || !isVideoInitialized || !isPlaying || isVideoEnded) - timeout is infinite
  /// else timeout is 3 seconds.
  GetPlayerControlsTimeout getPlayerControlsTimeout;

  PrettyVideoManager? get prettyVideoManager => _prettyVideoManager;
  PrettyDisplayManager? get prettyDisplayManager => _prettyDisplayManager;
  PrettyControlManager? get prettyControlManager => _prettyControlManager;
  BuildContext? get context => _context;

  registerContext(BuildContext context) {
    this._context = context;
  }

  /// Change the video.
  ///
  /// Current playing video will be paused and disposed,
  /// if [videoChangeDuration] is passed video change will happen after that duration.
  handleChangeVideo(VideoPlayerController videoPlayerController,
      {Duration? videoChangeDuration, TimerCancelCallback? timerCancelCallback}) {
    _prettyVideoManager!._handleChangeVideo(videoPlayerController,
        videoChangeDuration: videoChangeDuration, timerCancelCallback: timerCancelCallback);
  }

  _handleToggleFullscreen() {
    _prettyDisplayManager!._handleToggleFullscreen();
  }

  _handleVideoEnd() {
    if (onVideoEnd != null) {
      onVideoEnd!();
    }
    _prettyDisplayManager!._handleVideoEnd();
  }

  _handleErrorInVideo() {
    _prettyDisplayManager!._handleErrorInVideo();
  }

  _handleVideoSeek({required bool forward}) {
    // assert(forward != null);
    _prettyDisplayManager!._handleVideoSeek(forward: forward);
  }

  _handleVolumeChange({required double volume}) {
    // assert(forward != null);
    _prettyDisplayManager!._handleVolumeChange(volume);
  }

  /// Dispose the pretty manager.
  ///
  /// This internally disposes all the supporting managers.
  dispose() {
    _prettyControlManager!.dispose();
    _prettyDisplayManager!.dispose();
    _prettyVideoManager!.dispose();
  }
}
