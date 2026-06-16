import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/voice_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoiceProvider(),
      child: MaterialApp(
        title: 'Voice Changer Grok',
        theme: ThemeData.dark().copyWith(primaryColor: Colors.deepPurple),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
