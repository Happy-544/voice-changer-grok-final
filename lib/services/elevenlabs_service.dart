import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ElevenLabsService {
  static const String modelId = 'eleven_multilingual_sts_v2';

  static const Map<String, String> voices = {
    'Amr Diab': 'pNInz6obpgDQGcFmaJgB',
    'Fayrouz': 'EXAVITQu4vr4xnSDxMaL',
    'Nancy Ajram': '21m00Tcm4TlvDq8ikWAM',
    'Taylor Swift': 'EXAVITQu4vr4xnSDxMaL',
    'Drake': 'pNInz6obpgDQGcFmaJgB',
  };

  Future<String?> convertVoice(File audioFile, String voiceName) async {
    final voiceId = voices[voiceName] ?? voices['Amr Diab']!;

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$elevenLabsBaseUrl/speech-to-speech/$voiceId'),
      );

      request.headers['xi-api-key'] = elevenLabsApiKey;
      request.fields['model_id'] = modelId;
      request.fields['stability'] = '0.5';
      request.fields['similarity_boost'] = '0.75';

      request.files.add(await http.MultipartFile.fromPath('audio', audioFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final bytes = await response.stream.toBytes();
        final tempDir = await Directory.systemTemp.createTemp('converted_');
        final outputFile = File('${tempDir.path}/converted_${DateTime.now().millisecondsSinceEpoch}.mp3');
        await outputFile.writeAsBytes(bytes);
        return outputFile.path;
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
