import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

bool isTitle = true;
bool isCorp = true;
bool isIngredient = true;
bool isEffect = true;
bool isUsage = true;
bool isWarning = true;
bool isSwitched = true;
double speechRateInt = 1;
double pitchRateInt = 1;

class _SettingPageState extends State<SettingPage> {
  //이걸로 읽기 속도 조절가능
  int musicStart = 0;
  Icon play = Icon(
    Icons.play_circle,
    color: whatmedicol.medipink,
    size: 50,
  );
  final player = AudioPlayer();
//스위치 디폴트 값

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      player.stop(); // 앱이 백그라운드로 이동할 때 TTS 중지
    }
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = prefs.getBool("isSwitched")!;
      isTitle = prefs.getBool("isTitle")!;
      isCorp = prefs.getBool("isCorp")!;
      isIngredient = prefs.getBool("isIngredient")!;
      isEffect = prefs.getBool("isEffect")!;
      isUsage = prefs.getBool("isUsage")!;
      speechRateInt = prefs.getDouble("speechRateInt")!;
      pitchRateInt = prefs.getDouble("pitchRateInt")!;
    });
  }

  Future<void> _savebool() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isSwitched", isSwitched);
    await prefs.setBool("isTitle", isTitle);
    await prefs.setBool("isCorp", isCorp);
    await prefs.setBool("isIngredient", isIngredient);
    await prefs.setBool("isEffect", isEffect);
    await prefs.setBool("isUsage", isUsage);
    await prefs.setDouble("speechRateInt", speechRateInt);
    await prefs.setDouble("pitchRateInt", pitchRateInt);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 30, 10),
                      title: SizedBox(
                        child: Text(
                          "음성 안내",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      subtitle: SizedBox(
                        child: Text(
                          "인식 결과를 터치 없이 음성으로 들을 수 있습니다.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          _savebool();
                        });
                      },
                    )
                  ],
                ),
              ),
              Divider(),
              Text('data'),
              Card(
                child: Row(
                  children: [

                    SpinBox(
                      //이거는 갤럭시용 아이폰 용은 cupertinospinbox임 이거 사용한 pub dev에서 확인
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ), // 세부적인거는 일단 나중에 해도 될듯
                      min: 1,
                      max: 5,
                      enabled: true, //이아래까지 기능으로 버튼으로만 속도 조절 가능.
                      readOnly: true,
                      value: speechRateInt, //기본 초기 설정값으로 나타남. nono 보이는 값
                      onChanged: (value) {
                        setState(() {
                          speechRateInt = value;
                          _savebool();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(),
              Text('data'),
              Card(
                child: Row(
                  children: [
                    CheckboxListTile(
                        title: Text('약명'),
                        value: isTitle,
                        onChanged: (value) {
                          setState(() {
                            isTitle = value!;
                            _savebool();
                          });
                        }),
                    CheckboxListTile(
                        title: Text('제조사'),
                        value: isCorp,
                        onChanged: (value) {
                          setState(() {
                            isCorp = value!;
                            _savebool();
                          });
                        }),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    CheckboxListTile(
                        title: Text('성분'),
                        value: isIngredient,
                        onChanged: (value) {
                          setState(() {
                            isIngredient = value!;
                            _savebool();
                          });
                        }),
                    CheckboxListTile(
                        title: Text('효능'),
                        value: isEffect,
                        onChanged: (value) {
                          setState(() {
                            isEffect = value!;
                            _savebool();
                          });
                        }),
                  ],
                ),
              ),
              Card(
                child: Row(
                  children: [
                    CheckboxListTile(
                        title: Text('복용'),
                        value: isUsage,
                        onChanged: (value) {
                          setState(() {
                            isUsage = value!;
                            _savebool();
                          });
                        }),
                    CheckboxListTile(
                        title: Text('몰라'),
                        value: isUsage,
                        onChanged: (value) {
                          setState(() {
                            isUsage = value!;
                            _savebool();
                          });
                        }),
                  ],
                ),
              ),
              Divider(),
              AudioPlayerWidget(),
            ],
          ),
        ));
  }
}

class AudioPlayerWidget extends StatefulWidget {
  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  playAudio() async {
    await audioPlayer.play(AssetSource('guide.m4a'));

    setState(() {
      isPlaying = true;
    });
  }

  pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: 48.0,
            onPressed: () {
              if (isPlaying) {
                pauseAudio();
              } else {
                playAudio();
              }
            },
          ),
        ],
      ),
    );
  }
}

