import 'package:flutter/material.dart';

class VoiceProvider extends ChangeNotifier {
  String selectedVoice = 'Amr Diab';
  
  final List<String> voices = [
    'Amr Diab',
    'Fayrouz',
    'Nancy Ajram',
    'Taylor Swift',
    'Drake',
  ];

  void selectVoice(String voice) {
    selectedVoice = voice;
    notifyListeners();
  }
}
