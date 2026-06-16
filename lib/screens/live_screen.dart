import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';
import '../services/elevenlabs_service.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final Record _record = Record();
  final AudioPlayer _player = AudioPlayer();
  final ElevenLabsService _service = ElevenLabsService();
  bool isLive = false;
  Timer? _timer;
  String status = 'جاهز للـ Live';

  Future<void> _toggleLive() async {
    if (!isLive) {
      await _record.start(encoder: AudioEncoder.aac);
      setState(() { isLive = true; status = '🎤 Live جاري...'; });

      _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
        final path = await _record.stop();
        if (path != null) {
          final converted = await _service.convertVoice(File(path), Provider.of<VoiceProvider>(context, listen: false).selectedVoice);
          if (converted != null) {
            await _player.setFilePath(converted);
            await _player.play();
          }
        }
        await _record.start(encoder: AudioEncoder.aac);
      });
    } else {
      _timer?.cancel();
      await _record.stop();
      setState(() { isLive = false; status = 'Stopped'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Voice Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: _toggleLive,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLive ? Colors.red : Colors.deepPurple,
                ),
                child: Icon(isLive ? Icons.stop : Icons.mic, size: 90, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
