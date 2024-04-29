import 'package:flutter/material.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:provider/provider.dart';

/// GestureDetector that calls [prettyDisplayManager.handleVideoTap] onTap of opaque area/child.
class PrettyShowControlsAction extends StatelessWidget {
  const PrettyShowControlsAction({Key? key, this.child, this.behavior = HitTestBehavior.opaque, this.handleVideoTap})
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
    return Container(
      child: GestureDetector(
        key: key,
        child: child,
        behavior: behavior,
        onTap: () {
          if (handleVideoTap != null) {
            handleVideoTap!();
          } else {
            displayManager.handleVideoTap();
          }
        },
      ),
    );
  }
}
