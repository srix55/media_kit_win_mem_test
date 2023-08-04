import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoView extends StatefulWidget {
  const VideoView({Key? key, required this.assetName, required this.onComplete}) : super(key: key);
  final String assetName;
  final void Function() onComplete;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final Player player;
  late final VideoController controller;
  late final StreamSubscription<bool> onComplete;

  @override
  Widget build(BuildContext context) {
    return Center(child: Video(controller: controller, fit: BoxFit.fitWidth, alignment: Alignment.center,));
  }

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    player.open(Media('asset://assets/${widget.assetName}'));
    onComplete = player.stream.completed.listen((event) {
      if (event == true)
        widget.onComplete();
    });
  }

  @override
  void dispose() {
    player.dispose();
    onComplete.cancel();
    super.dispose();
  }
}
