import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video player',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _PlayerVideoAndPopPage(),
    );
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage>
    with TickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.asset('assets/video/clip_.mp4');
    _videoPlayerController.addListener(() {
      setState(() {});
    });
    _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
          onTap: () {
            _videoPlayerController.value.isPlaying
                ? _videoPlayerController.pause()
                : _videoPlayerController.play();
            Future.delayed(const Duration(milliseconds: 100),
                () => startedPlaying = _videoPlayerController.value.isPlaying);
          },
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_videoPlayerController),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 5500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: _videoPlayerController.value.isPlaying &&
                          startedPlaying
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Операция "Ы" и другие приключения Шурика',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                                textAlign: TextAlign.left,
                              ),
                              const Spacer(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: VideoProgressIndicator(
                                    _videoPlayerController,
                                    allowScrubbing: true),
                              ),
                              _ControlsOverlay(
                                controller: _videoPlayerController,
                                hide: startedPlaying,
                              ),
                            ],
                          ),
                        ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  reverseDuration: const Duration(milliseconds: 500),
                  child: _videoPlayerController.value.isPlaying
                      ? const SizedBox.shrink()
                      : Container(
                          color: Colors.black38,
                          child: const Center(
                            child: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 40.0,
                              semanticLabel: 'Play',
                            ),
                          ),
                        ),
                ),
              ],
            ),
          )),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller, this.hide = false});

  final VideoPlayerController controller;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 50),
            reverseDuration: const Duration(milliseconds: 200),
            child: !hide
                ? Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 20.0,
                        semanticLabel: 'Pause',
                      ),
                    ),
                  )
                : Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 20.0,
                        semanticLabel: 'Play',
                      ),
                    ),
                  ),
          ),
        ),
        Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: const Center(
            child: Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 25.0,
              semanticLabel: 'Next',
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: const Center(
            child: Icon(
              Icons.volume_up,
              color: Colors.white,
              size: 20.0,
              semanticLabel: 'Volume',
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          color: Colors.transparent,
          child: const Center(
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 20.0,
              semanticLabel: 'Settings',
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          child: const Center(
            child: Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 20.0,
              semanticLabel: 'Fullscreen',
            ),
          ),
        ),
      ],
    );
  }
}
