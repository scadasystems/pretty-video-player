import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// GestureDetector that calls [flickDisplayManager.handleVideoTap] onTap of opaque area/child.
class PrettyShowControlsActionWeb extends StatelessWidget {
  const PrettyShowControlsActionWeb({Key? key, this.child, this.behavior = HitTestBehavior.opaque, this.handleVideoTap})
      : super(key: key);

  final Widget? child;
  final HitTestBehavior behavior;

  /// Function called onTap of the opaque area/child.
  ///
  /// Default action -
  /// ``` dart
  ///    displayManager.handleVideoTap();
  /// ```
  final Function? handleVideoTap;

  @override
  Widget build(BuildContext context) {
    PrettyDisplayManager displayManager = Provider.of<PrettyDisplayManager>(context);
    return GestureDetector(
      onTap: () {
        displayManager.handleShowPlayerControls();
      },
      child: Container(
        child: MouseRegion(
          key: key,
          child: child,
          onEnter: (_) {
            displayManager.handleShowPlayerControls();
          },
          onHover: (_) {
            displayManager.handleShowPlayerControls();
          },
        ),
      ),
    );
  }
}
