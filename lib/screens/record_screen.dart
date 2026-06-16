import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';
import '../services/elevenlabs_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final Record _record = Record();
  final AudioPlayer _player = AudioPlayer();
  final ElevenLabsService _service = ElevenLabsService();
  bool isRecording = false;
  String? convertedPath;
  String status = 'اضغط للتسجيل';

  Future<void> _toggleRecord() async {
    if (!isRecording) {
      if (await _record.hasPermission()) {
        final path = '${(await Directory.systemTemp.createTemp()).path}/record.m4a';
        await _record.start(path: path);
        setState(() { isRecording = true; status = 'جاري التسجيل...'; });
      }
    } else {
      final path = await _record.stop();
      setState(() { isRecording = false; status = 'جاري التحويل...'; });
      if (path != null) {
        final result = await _service.convertVoice(File(path), Provider.of<VoiceProvider>(context, listen: false).selectedVoice);
        if (result != null) {
          setState(() { convertedPath = result; status = 'تم التحويل!'; });
          _player.setFilePath(result);
          _player.play();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final voice = Provider.of<VoiceProvider>(context).selectedVoice;
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل - $voice')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _toggleRecord,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isRecording ? Colors.red : Colors.deepPurple),
                child: Icon(isRecording ? Icons.stop : Icons.mic, size: 80, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
