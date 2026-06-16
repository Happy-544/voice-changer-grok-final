import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';
import 'record_screen.dart';
import 'live_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VoiceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Voice Changer Grok')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('اختر الصوت', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                ),
                itemCount: provider.voices.length,
                itemBuilder: (context, index) {
                  final voice = provider.voices[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        provider.selectVoice(voice);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RecordScreen()));
                      },
                      child: Center(child: Text(voice, style: const TextStyle(fontSize: 20))),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveScreen()));
              },
              child: const Text('Live Mode (مباشر)'),
            ),
          ],
        ),
      ),
    );
  }
}
