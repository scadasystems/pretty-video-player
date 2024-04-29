import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Uses [MultiProviders] to add all the managers as providers.
class PrettyManagerBuilder extends StatelessWidget {
  const PrettyManagerBuilder({Key? key, required this.child, required this.flickManager}) : super(key: key);
  final Widget child;
  final PrettyManager flickManager;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PrettyVideoManager>.value(
          value: flickManager.flickVideoManager!,
        ),
        ChangeNotifierProvider<PrettyDisplayManager>.value(
          value: flickManager.flickDisplayManager!,
        ),
        ChangeNotifierProvider<PrettyControlManager>.value(
          value: flickManager.flickControlManager!,
        ),
      ],
      child: child,
    );
  }
}
