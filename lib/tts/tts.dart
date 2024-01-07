import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:whatmedi3/pages/settingpage.dart';

class TtsService {
  FlutterTts _flutterTts = FlutterTts();
  static bool isSpeaking = false;
  static final TtsService _instance = TtsService._internal();
  factory TtsService() {
    return _instance;
  }
  TtsService._internal() {
    _initTts();
  }
  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ko-KR');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(speechRateInt);
  }

  Future<void> speak(String text) async {
    if (!isSpeaking) {
      isSpeaking = true;
      await _flutterTts.speak(text);
      //_isSpeaking = false;
    }
  }

  Future<void> stop() async {
    if (isSpeaking) {
      await _flutterTts.stop();
      isSpeaking = false;
    }
  }
}