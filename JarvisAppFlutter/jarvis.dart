// THIS IS JUST A BASIC STRUCTURE OF THE CODE...
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(JarvisApp());
}

class JarvisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => JarvisScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'JARVIS',
          style: TextStyle(
              color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class JarvisScreen extends StatefulWidget {
  @override
  _JarvisScreenState createState() => _JarvisScreenState();
}

class _JarvisScreenState extends State<JarvisScreen> {
  final String apiKey = "PUT YOUR API KEY HERE"; // eg: gpt , gemini , etc
  late GenerativeModel model;
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  String responseText = "";
  List<Content> conversationHistory = [];

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'put model name here', apiKey: apiKey); // put exact model name
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();

    flutterTts.setLanguage("en-au");
    flutterTts.setPitch(0.8);
    flutterTts.setSpeechRate(0.7);
    flutterTts.awaitSpeakCompletion(true);
    flutterTts.setEngine("com.google.android.tts");

    flutterTts.getVoices.then((voices) {
      if (voices.isNotEmpty) {
        flutterTts.setVoice(voices[0]);
      }
    });
  }

  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => isListening = true);
      speech.listen(
        onResult: (result) async {
          if (result.finalResult) {
            String userInput = result.recognizedWords.toLowerCase();
            processQuery(userInput);
          }
        },
        listenFor: Duration(minutes: 1),
        pauseFor: Duration(seconds: 30),
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  void speak(String text) async {
    if (text.isNotEmpty) {
      String cleanText = text.replaceAll(RegExp(r'\*'), '');
      await flutterTts.speak(cleanText);
    }
  }

  void processQuery(String query) async {
    try {
      if (query.contains("weather")) {
        _searchWeather();
        return;
      } else if (query.contains("time")) {
        _tellTime();
        return;
      } else if (query.contains("open")) {
        _openApp(query);
        return;
      }
      final chat = model.startChat(history: conversationHistory);
      conversationHistory.add(Content.text(query));

      String initialInstruction = '''
      From now onwards, talk like Jarvis from Iron Man.
      If asked what your name is, just say that you're Jarvis and if they ask who made you just tell that you were made by Tony Stark.
      ''';

      await chat.sendMessage(Content.text(initialInstruction));
      final response = await chat.sendMessage(Content.text(query));
      conversationHistory.add(Content.text(response.text ?? "No response"));

      setState(() => responseText = "Jarvis is responding...");
      speak(response.text ?? "I didn't get that.");
    } catch (e) {
      setState(() => responseText = "Error: $e");
      speak("Sorry, something went wrong.");
    }
  }

  void _searchWeather() async {
    final Uri url = Uri.parse("https://www.google.com/search?q=weather+today");
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      speak(
          "I couldn't open the browser. Please check your internet connection.");
    }
  }

  void _tellTime() {
    String time = DateFormat.jm().format(DateTime.now());
    speak("The current time is $time");
  }

  void _openApp(String query) async {
    Map<String, String> appMap = {
      "chrome": "com.android.chrome",
      "whatsapp": "com.whatsapp",
      "camera": "com.android.camera"
    };

    for (var entry in appMap.entries) {
      if (query.contains(entry.key)) {
        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          package: entry.value,
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );
        await intent.launch();
        speak("Opening ${entry.key}");
        return;
      }
    }

    // If the app is not found, open app settings search
    final settingsIntent = AndroidIntent(
      action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
      data: 'package:${query.replaceAll("open ", "").trim()}',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    await settingsIntent.launch();
    speak("I couldn't find that app, searching in settings.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('J.A.R.V.I.S', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(responseText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startListening,
              child: Text('Talk to Jarvis'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
