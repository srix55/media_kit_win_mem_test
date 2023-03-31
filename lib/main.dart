import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaKit Win Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MediaKit Win Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Player? player;
  VideoController? videoController;

  Future<void> initializePlayer() async {
    player = Player(configuration: const PlayerConfiguration(logLevel: MPVLogLevel.warn));
    videoController = await VideoController.create(player!.handle);
    if(mounted) setState(() {});
  }

  Future<void> disposePlayer() async {
    await videoController?.dispose();
    await player?.dispose();
    if(mounted) setState(() {});
  }


  @override
  void dispose() {
    disposePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontal =
        MediaQuery.of(context).size.width > MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text('package:media_kit'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Start loop',
          child: const Icon(Icons.play_arrow),
          onPressed: () async {
            while (true) {
              await initializePlayer();
              await playVideo();
              await Future.delayed(const Duration(seconds: 5));
              await disposePlayer();
              await Future.delayed(const Duration(seconds: 1));
            }
          },
        ),
        body: SizedBox.expand(
          child: horizontal
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  child: video,
                ),
              ),
              const VerticalDivider(width: 1.0, thickness: 1.0),
              /*Expanded(
                flex: 1,
                child: ListView(
                  children: [...assets],
                ),
              ),*/
            ],
          )
              : ListView(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 12.0 / 16.0,
                child: video,
              ),
              const Divider(height: 1.0, thickness: 1.0),
              // ...assets,
            ],
          ),
        ));
  }

  Future<void> playVideo() async {
    await player!.open(
      Playlist(
        [
          Media('asset://assets/video_0.mp4'),
        ],
      ), play: true,
    );
  }

  Widget get video => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: Card(
          elevation: 8.0,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.all(32.0),
          child: Video(
            controller: videoController,
          ),
        ),
      ),
      // TracksSelector(player: player),
      // SeekBar(player: player),
      const SizedBox(height: 32.0),
    ],
  );
}
