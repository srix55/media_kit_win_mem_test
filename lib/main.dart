import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_win_mem_test/video_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(const MyApp2());
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediaKit Win Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage2(),
    );
  }
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

class MyHomePage2 extends StatefulWidget {
  const MyHomePage2({Key? key}) : super(key: key);

  @override
  State<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends State<MyHomePage2> {
  static final List<String> videos = [
    'amazon_dog.mp4', 'bulgari.mp4', 'cocacola_one.mp4', 'cocacola_two.mp4', 'hersheys.mp4',
    'kwality_walls.mp4', 'pepsi_peeps.mp4', 'pepsi_three.mp4', 'pepsi_two.mp4', 'tiffanyco.mp4',
    'tiffanyco_two.mp4', 'uniqlo.mp4'
  ];


  @override
  void initState() {
    super.initState();
    videoIterationA = 0;
    videoIterationB = 3;
    videoIterationC = 6;
    videoIterationD = 1;
    videoIterationE = 2;
    videoIterationF = 5;
  }

  late int videoIterationA;
  late int videoIterationB;
  late int videoIterationC;
  late int videoIterationD;
  late int videoIterationE;
  late int videoIterationF;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(width: double.infinity, height: 400, child: Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationA), assetName: videos[videoIterationA], onComplete: () { videoIterationA = (videoIterationA + 1) % videos.length; setState(() {}); },)),
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationB), assetName: videos[videoIterationB], onComplete: () { videoIterationB = (videoIterationB + 1) % videos.length; setState(() {}); },)),
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationC), assetName: videos[videoIterationC], onComplete: () { videoIterationC = (videoIterationC + 1) % videos.length; setState(() {}); },)),
          ]),),
          SizedBox(width: double.infinity, height: 400, child: Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationD), assetName: videos[videoIterationD], onComplete: () { videoIterationD = (videoIterationD + 1) % videos.length; setState(() {}); },)),
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationE), assetName: videos[videoIterationE], onComplete: () { videoIterationE = (videoIterationE + 1) % videos.length; setState(() {}); },)),
            Expanded(child: VideoView(key: ValueKey<int>(videoIterationF), assetName: videos[videoIterationF], onComplete: () { videoIterationF = (videoIterationF + 1) % videos.length; setState(() {}); },)),
          ]),)
        ],
      ),
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
  static List<String> videos = [
    'amazon_dog.mp4', 'bulgari.mp4', 'cocacola_one.mp4', 'cocacola_two.mp4', 'hersheys.mp4',
    'kwality_walls.mp4', 'pepsi_peeps.mp4', 'pepsi_three.mp4', 'pepsi_two.mp4', 'tiffanyco.mp4',
    'tiffanyco_two.mp4', 'uniqlo.mp4'
  ];
  late int videoIteration;
  Player? player;
  VideoController? videoController;


  @override
  void initState() {
    super.initState();
    videoIteration = 0;
  }

  Future<void> initializePlayer() async {
    player = Player(configuration: const PlayerConfiguration(logLevel: MPVLogLevel.warn));
    videoController = VideoController(player!);
    if(mounted) setState(() {});
  }

  Future<void> disposePlayer() async {
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
              await playVideo(++videoIteration % videos.length);
              await Future.delayed(const Duration(seconds: 5));
              await player!.stop();
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

  Future<void> playVideo(int num) async {
    await player!.open(
      Playlist(
        [
          Media('asset://assets/${videos[num]}'),
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
          child: videoController != null ? Video(
            controller: videoController!,
          ) : const SizedBox.shrink(),
        ),
      ),
      // TracksSelector(player: player),
      // SeekBar(player: player),
      const SizedBox(height: 32.0),
    ],
  );
}
