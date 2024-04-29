import 'package:flutter/material.dart';
import 'package:pretty_video_player/pretty_video_player.dart';
import 'package:provider/provider.dart';

/// Uses [MultiProviders] to add all the managers as providers.
class PrettyManagerBuilder extends StatelessWidget {
  const PrettyManagerBuilder({Key? key, required this.child, required this.prettyManager}) : super(key: key);
  final Widget child;
  final PrettyManager prettyManager;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PrettyVideoManager>.value(
          value: prettyManager.prettyVideoManager!,
        ),
        ChangeNotifierProvider<PrettyDisplayManager>.value(
          value: prettyManager.prettyDisplayManager!,
        ),
        ChangeNotifierProvider<PrettyControlManager>.value(
          value: prettyManager.prettyControlManager!,
        ),
      ],
      child: child,
    );
  }
}
