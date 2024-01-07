// final speech = TtsService();
// final FlutterTts tts = FlutterTts();
// //double speechrateint2 = speechRateInt;
// // Future set2() async {
// //   await tts.setLanguage('ko-KR');
// //   await tts.setSpeechRate(speechRateInt);
// // }
//
// set() {
//   tts.setPitch(pitchRateInt);
//   bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
//   bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
//   tts.setSpeechRate(isAndroid ? speechRateInt / 2 : speechRateInt);
//   // await tts.setSpeechRate(Platform.isAndroid
// //     //     ? (speechRateInt == 1 ? speechRateInt : speechRateInt / 2)
// //     //     : speechRateInt);
//   tts.setLanguage('ko-KR');
// }
//
// @override
// void didChangeAppLifecycleState(AppLifecycleState state) {
//   if (state == AppLifecycleState.paused) {
//     speech.stop();
//     // 앱이 백그라운드로 이동할 때 TTS 중지
//   }
// }
//
// @override
// void initState() {
//   WidgetsBinding.instance?.addObserver(this);
//   choice();
//   //TtsService._isSpeaking = false;
//   if (isSwitched == true && TtsService.isSpeaking == false) {
//     //FlutterAccessibilityService.;
//     //FlutterAccessibility.disableAccessibility();
//     MethodChannel('flutter/accessibility')
//         .invokeMethod<void>('decreaseAccessibility');
//     Future<void>.delayed(const Duration(milliseconds: 1000));
//     play();
//     MethodChannel('flutter/accessibility')
//         .invokeMethod<void>('increaseAccessibility');
//   }
//   super.initState();
// }
//
// @override
// void dispose() {
//   WidgetsBinding.instance?.removeObserver(this);
//   //WidgetsBinding.instance?.removeObserver(this);
//   //TtsService._isSpeaking = true;
//   speech.stop();
//   setState(() {
//     TtsService.isSpeaking = false;
//   });
//   super.dispose();
// }
//
// TextStyle bold = TextStyle(
//   color: Colors.black,
//   fontSize: 20,
//   fontWeight: FontWeight.bold,
// );
//
// TextStyle regular = TextStyle(
//   color: Colors.black,
//   fontSize: 20,
// );
//
// String pummok = '';
// String upche = '';
// String sungbun = '';
// String hyoneung = '';
// String youngbup = '';
// String juyi = '';
// void choice() {
//   if (isTitle == true) {
//     pummok = ',,,품목명: ${widget.mediinfo["title"]}';
//   } else {
//     pummok = '';
//   }
//   if (isCorp == true) {
//     upche = ',,,업체명: ${widget.mediinfo["corp"]}';
//   } else {
//     upche = '';
//   }
//   if (isIngredient == true) {
//     sungbun = ',,,성분: ${widget.mediinfo["ingredient"]}';
//   } else {
//     sungbun = '';
//   }
//   if (isEffect == true) {
//     hyoneung = ',,,효능효과: ${widget.mediinfo["effect"]}';
//   } else {
//     hyoneung = '';
//   }
//   if (isUsage == true) {
//     youngbup = ',,,용법용량: ${widget.mediinfo["usage"]}';
//   } else {
//     youngbup = '';
//   }
//   if (isWarning == true) {
//     juyi = ',,,주의사항: ${widget.mediinfo["warning"]}';
//   } else {
//     juyi = '';
//   }
// }
//
// Future play() async {
//   set();
//   await speech.speak(pummok + upche + sungbun + hyoneung + youngbup + juyi);
// }
// // Future play2() async {
// //   await speech.speak(pummok + upche + sungbun + hyoneung + youngbup);
// // }
