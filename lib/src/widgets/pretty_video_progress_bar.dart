import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

/// Renders progress bar for the video using custom paint.
class PrettyVideoProgressBar extends StatelessWidget {
  PrettyVideoProgressBar({
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    PrettyProgressBarSettings? prettyProgressBarSettings,
  }) : prettyProgressBarSettings =
            prettyProgressBarSettings != null ? prettyProgressBarSettings : PrettyProgressBarSettings();

  final PrettyProgressBarSettings prettyProgressBarSettings;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    PrettyControlManager controlManager = Provider.of<PrettyControlManager>(context);
    PrettyVideoManager videoManager = Provider.of<PrettyVideoManager>(context);
    VideoPlayerValue? videoPlayerValue = videoManager.videoPlayerValue;

    if (videoPlayerValue == null) return Container();

    void seekToRelativePosition(Offset globalPosition) {
      final box = context.findRenderObject() as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = videoPlayerValue.duration * relative;
      controlManager.seekTo(position);
    }

    return LayoutBuilder(builder: (context, size) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: size.maxWidth,
          padding: prettyProgressBarSettings.padding,
          child: Container(
            height: prettyProgressBarSettings.height,
            child: CustomPaint(
              painter: _ProgressBarPainter(
                videoPlayerValue,
                prettyProgressBarSettings: prettyProgressBarSettings,
              ),
            ),
          ),
        ),
        onHorizontalDragStart: (DragStartDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          // _controllerWasPlaying = prettyControlManager.isPlaying;
          if (videoManager.isPlaying) {
            controlManager.autoPause();
          }

          if (onDragStart != null) {
            onDragStart!();
          }
        },
        onHorizontalDragUpdate: (DragUpdateDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);

          if (onDragUpdate != null) {
            onDragUpdate!();
          }
        },
        onHorizontalDragEnd: (DragEndDetails details) {
          controlManager.autoResume();

          if (onDragEnd != null) {
            onDragEnd!();
          }
        },
        onTapDown: (TapDownDetails details) {
          if (!videoPlayerValue.isInitialized) {
            return;
          }
          seekToRelativePosition(details.globalPosition);
        },
      );
    });
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(this.value, {this.prettyProgressBarSettings});

  VideoPlayerValue value;
  PrettyProgressBarSettings? prettyProgressBarSettings;

  @override
  bool shouldRepaint(CustomPainter painter) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double height = prettyProgressBarSettings!.height;
    double width = size.width;
    double curveRadius = prettyProgressBarSettings!.curveRadius;
    double handleRadius = prettyProgressBarSettings!.handleRadius;
    Paint backgroundPaint = prettyProgressBarSettings!.getBackgroundPaint != null
        ? prettyProgressBarSettings!.getBackgroundPaint!(
            width: width,
            height: height,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = prettyProgressBarSettings!.backgroundColor;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, 0),
          Offset(width, height),
        ),
        Radius.circular(curveRadius),
      ),
      backgroundPaint,
    );
    if (value.isInitialized == false) {
      return;
    }

    final double playedPartPercent = value.position.inMilliseconds / value.duration.inMilliseconds;
    final double playedPart = playedPartPercent > 1 ? width : playedPartPercent * width;

    for (DurationRange range in value.buffered) {
      final double start = range.startFraction(value.duration) * width;
      final double end = range.endFraction(value.duration) * width;

      Paint bufferedPaint = prettyProgressBarSettings!.getBufferedPaint != null
          ? prettyProgressBarSettings!.getBufferedPaint!(
              width: width,
              height: height,
              playedPart: playedPart,
              handleRadius: handleRadius,
              bufferedStart: start,
              bufferedEnd: end)
          : Paint()
        ..color = prettyProgressBarSettings!.bufferedColor;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
            Offset(start, 0),
            Offset(end, height),
          ),
          Radius.circular(curveRadius),
        ),
        bufferedPaint,
      );
    }

    Paint playedPaint = prettyProgressBarSettings!.getPlayedPaint != null
        ? prettyProgressBarSettings!.getPlayedPaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = prettyProgressBarSettings!.playedColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(0.0, 0.0),
          Offset(playedPart, height),
        ),
        Radius.circular(curveRadius),
      ),
      playedPaint,
    );

    Paint handlePaint = prettyProgressBarSettings!.getHandlePaint != null
        ? prettyProgressBarSettings!.getHandlePaint!(
            width: width,
            height: height,
            playedPart: playedPart,
            handleRadius: handleRadius,
          )
        : Paint()
      ..color = prettyProgressBarSettings!.handleColor;

    canvas.drawCircle(
      Offset(playedPart, height / 2),
      handleRadius,
      handlePaint,
    );
  }
}
