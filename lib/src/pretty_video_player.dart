import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:pretty_video_player/src/utils/web_key_bindings.dart';
import 'package:universal_html/html.dart';
import 'package:wakelock/wakelock.dart';

class PrettyVideoPlayer extends StatefulWidget {
  const PrettyVideoPlayer({
    Key? key,
    required this.prettyManager,
    this.prettyVideoWithControls = const PrettyVideoWithControls(
      controls: const PrettyPortraitControls(),
    ),
    this.prettyVideoWithControlsFullscreen,
    this.systemUIOverlay = SystemUiOverlay.values,
    this.systemUIOverlayFullscreen = const [],
    this.preferredDeviceOrientation = const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    this.preferredDeviceOrientationFullscreen = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
    this.wakelockEnabled = true,
    this.wakelockEnabledFullscreen = true,
    this.webKeyDownHandler = prettyDefaultWebKeyDownHandler,
  }) : super(key: key);

  final PrettyManager prettyManager;

  /// Widget to render video and controls.
  final Widget prettyVideoWithControls;

  /// Widget to render video and controls in full-screen.
  final Widget? prettyVideoWithControlsFullscreen;

  /// SystemUIOverlay to show.
  ///
  /// SystemUIOverlay is changed in init.
  final List<SystemUiOverlay> systemUIOverlay;

  /// SystemUIOverlay to show in full-screen.
  final List<SystemUiOverlay> systemUIOverlayFullscreen;

  /// Preferred device orientation.
  ///
  /// Use [preferredDeviceOrientationFullscreen] to manage orientation for full-screen.
  final List<DeviceOrientation> preferredDeviceOrientation;

  /// Preferred device orientation in full-screen.
  final List<DeviceOrientation> preferredDeviceOrientationFullscreen;

  /// Prevents the screen from turning off automatically.
  ///
  /// Use [wakeLockEnabledFullscreen] to manage wakelock for full-screen.
  final bool wakelockEnabled;

  /// Prevents the screen from turning off automatically in full-screen.
  final bool wakelockEnabledFullscreen;

  /// Callback called on keyDown for web, used for keyboard shortcuts.
  final Function(KeyboardEvent, PrettyManager) webKeyDownHandler;

  @override
  _PrettyVideoPlayerState createState() => _PrettyVideoPlayerState();
}

class _PrettyVideoPlayerState extends State<PrettyVideoPlayer> with WidgetsBindingObserver {
  late PrettyManager prettyManager;
  bool _isFullscreen = false;
  OverlayEntry? _overlayEntry;
  double? _videoWidth;
  double? _videoHeight;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    prettyManager = widget.prettyManager;
    prettyManager.registerContext(context);
    prettyManager.prettyControlManager!.addListener(listener);
    _setSystemUIOverlays();
    _setPreferredOrientation();

    if (widget.wakelockEnabled) {
      Wakelock.enable();
    }

    if (kIsWeb) {
      document.documentElement?.onFullscreenChange.listen(_webFullscreenListener);
      document.documentElement?.onKeyDown.listen(_webKeyListener);
    }

    super.initState();
  }

  @override
  void dispose() {
    prettyManager.prettyControlManager!.removeListener(listener);
    if (widget.wakelockEnabled) {
      Wakelock.disable();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    if (_overlayEntry != null) {
      prettyManager.prettyControlManager!.exitFullscreen();
      return true;
    }
    return false;
  }

  // Listener on [prettyControlManager],
  // Pushes the full-screen if [prettyControlManager] is changed to full-screen.
  void listener() async {
    if (prettyManager.prettyControlManager!.isFullscreen && !_isFullscreen) {
      _switchToFullscreen();
    } else if (_isFullscreen && !prettyManager.prettyControlManager!.isFullscreen) {
      _exitFullscreen();
    }
  }

  _switchToFullscreen() {
    if (widget.wakelockEnabledFullscreen) {
      /// Disable previous wakelock setting.
      Wakelock.disable();
      Wakelock.enable();
    }

    _isFullscreen = true;
    _setPreferredOrientation();
    _setSystemUIOverlays();
    if (kIsWeb) {
      document.documentElement?.requestFullscreen();
      Future.delayed(Duration(milliseconds: 100), () {
        _videoHeight = MediaQuery.of(context).size.height;
        _videoWidth = MediaQuery.of(context).size.width;
        setState(() {});
      });
    } else {
      _overlayEntry = OverlayEntry(builder: (context) {
        return Scaffold(
          body: PrettyManagerBuilder(
            prettyManager: prettyManager,
            child: widget.prettyVideoWithControlsFullscreen ?? widget.prettyVideoWithControls,
          ),
        );
      });

      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  _exitFullscreen() {
    if (widget.wakelockEnabled) {
      /// Disable previous wakelock setting.
      Wakelock.disable();
      Wakelock.enable();
    }

    _isFullscreen = false;

    if (kIsWeb) {
      document.exitFullscreen();
      _videoHeight = null;
      _videoWidth = null;
      setState(() {});
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    _setPreferredOrientation();
    _setSystemUIOverlays();
  }

  _setPreferredOrientation() {
    // when aspect ratio is less than 1 , video will be played in portrait mode and orientation will not be changed.
    var aspectRatio = widget.prettyManager.prettyVideoManager!.videoPlayerValue!.aspectRatio;
    if (_isFullscreen && aspectRatio >= 1) {
      SystemChrome.setPreferredOrientations(widget.preferredDeviceOrientationFullscreen);
    } else {
      SystemChrome.setPreferredOrientations(widget.preferredDeviceOrientation);
    }
  }

  _setSystemUIOverlays() {
    if (_isFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: widget.systemUIOverlayFullscreen);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: widget.systemUIOverlay);
    }
  }

  void _webFullscreenListener(Event event) {
    final isFullscreen = (window.screenTop == 0 && window.screenY == 0);
    if (isFullscreen && !prettyManager.prettyControlManager!.isFullscreen) {
      prettyManager.prettyControlManager!.enterFullscreen();
    } else if (!isFullscreen && prettyManager.prettyControlManager!.isFullscreen) {
      prettyManager.prettyControlManager!.exitFullscreen();
    }
  }

  void _webKeyListener(KeyboardEvent event) {
    widget.webKeyDownHandler(event, prettyManager);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _videoWidth,
      height: _videoHeight,
      child: PrettyManagerBuilder(
        prettyManager: prettyManager,
        child: widget.prettyVideoWithControls,
      ),
    );
  }
}
