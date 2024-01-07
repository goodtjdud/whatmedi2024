import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatmedi3/pages/mainpage.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with WidgetsBindingObserver {
  int musicStart = 0;
  Icon play = Icon(
    Icons.play_circle,
    color: Colors.black,
    size: 40,
  );
  final player = AudioPlayer();
  Text message = Text("오디오 재생");

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      player.stop(); // 앱이 백그라운드로 이동할 때 TTS 중지
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('앱 사용 설명 페이지',
      //       style: TextStyle(fontWeight: FontWeight.bold)),
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => setState(() {
                  if (musicStart == 0) {
                    player.play(
                      AssetSource('guide.m4a'),
                    );
                    musicStart = 1;
                    message = Text("오디오 정지");
                  } else {
                    player.stop();
                    musicStart = 0;
                    message = Text("오디오 재생");
                  }
                }),
                // TODO: Implement audio playback logic
                child: message,
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  player.stop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: Text('홈페이지로'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
