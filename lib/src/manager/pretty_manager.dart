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
    _flickControlManager = PrettyControlManager(
      flickManager: this,
    );
    _flickVideoManager = PrettyVideoManager(flickManager: this, autoPlay: autoPlay, autoInitialize: autoInitialize);
    _flickDisplayManager = PrettyDisplayManager(
      flickManager: this,
    );
    _flickVideoManager!._handleChangeVideo(videoPlayerController);
  }

  PrettyVideoManager? _flickVideoManager;
  PrettyControlManager? _flickControlManager;
  PrettyDisplayManager? _flickDisplayManager;
  BuildContext? _context;

  /// Video end callback, change the video in this callback.
  Function? onVideoEnd;

  /// Player controls auto-hide timeout callback, called when player state changes.
  ///
  /// Duration returned by this function is used to auto-hide controls.
  /// Defaults to if (errorInVideo || !isVideoInitialized || !isPlaying || isVideoEnded) - timeout is infinite
  /// else timeout is 3 seconds.
  GetPlayerControlsTimeout getPlayerControlsTimeout;

  PrettyVideoManager? get flickVideoManager => _flickVideoManager;
  PrettyDisplayManager? get flickDisplayManager => _flickDisplayManager;
  PrettyControlManager? get flickControlManager => _flickControlManager;
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
    _flickVideoManager!._handleChangeVideo(videoPlayerController,
        videoChangeDuration: videoChangeDuration, timerCancelCallback: timerCancelCallback);
  }

  _handleToggleFullscreen() {
    _flickDisplayManager!._handleToggleFullscreen();
  }

  _handleVideoEnd() {
    if (onVideoEnd != null) {
      onVideoEnd!();
    }
    _flickDisplayManager!._handleVideoEnd();
  }

  _handleErrorInVideo() {
    _flickDisplayManager!._handleErrorInVideo();
  }

  _handleVideoSeek({required bool forward}) {
    // assert(forward != null);
    _flickDisplayManager!._handleVideoSeek(forward: forward);
  }

  _handleVolumeChange({required double volume}) {
    // assert(forward != null);
    _flickDisplayManager!._handleVolumeChange(volume);
  }

  /// Dispose the flick manager.
  ///
  /// This internally disposes all the supporting managers.
  dispose() {
    _flickControlManager!.dispose();
    _flickDisplayManager!.dispose();
    _flickVideoManager!.dispose();
  }
}
