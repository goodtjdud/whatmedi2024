import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:whatmedi3/pages/mainpage.dart';
import 'package:animate_do/animate_do.dart';

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
  Text message = Text("설명 재생");

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
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column
            (mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30),
              FadeInUp(
                child: Center(
                  child: Container(
                      height: 250,
                    child: Image.asset(
                      'assets/images/whatmedi1.png',
                    fit: BoxFit.contain,),
                      alignment: Alignment.center,
                    ),
                )
                ),
              SizedBox(
                height: 50),
              FadeInUp(
                child: Text("무엇이약?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                ),
                )
              ),
              FadeInUp(
                duration: Duration(milliseconds: 1400),
                child: Text("손쉽게 찾는 약 정보",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade500,
                ),
                )
              ),
              SizedBox(height: 15,),
              FadeInUp(
                duration: Duration(milliseconds: 1400),
                delay: Duration(milliseconds: 200),
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  )
                )
              ),
              SizedBox(height: 20,),
          Container(
            height: 40,
            width: double.infinity,
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
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 40,
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

            ]
          )
        )


        // child: Stack(
        //   children: [
        //     Center(
        //       child: ElevatedButton(
        //         onPressed: () => setState(() {
        //           if (musicStart == 0) {
        //             player.play(
        //               AssetSource('guide.m4a'),
        //             );
        //             musicStart = 1;
        //             message = Text("오디오 정지");
        //           } else {
        //             player.stop();
        //             musicStart = 0;
        //             message = Text("오디오 재생");
        //           }
        //         }),
        //         // TODO: Implement audio playback logic
        //         child: message,
        //       ),
        //     ),
        //     Positioned(
        //       bottom: 16,
        //       right: 16,
        //       child: ElevatedButton(
        //         onPressed: () {
        //           player.stop();
        //           Navigator.pushReplacement(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => HomePage(),
        //             ),
        //           );
        //         },
        //         child: Text('홈페이지로'),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
