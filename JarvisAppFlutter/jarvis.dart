import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();

    _playStartupSound();

    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => JarvisScreen()));
    });
  }

  Future<void> _playStartupSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/startup.mp3'));
    } catch (e) {
      print('Error playing startup sound: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitPatternPainter(),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.blue.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    radius: 1.2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'J.A.R.V.I.S',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.blue.withOpacity(0.9),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 30,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.4),
                            Colors.blue.withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.power_settings_new,
                          size: 70,
                          color: Colors.blue.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircuitPatternPainter extends CustomPainter {
  final bool isIdleState;

  CircuitPatternPainter({this.isIdleState = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final random = Random();
    final numberOfLines = 120;
    final numberOfNodes = 25;

    final seedRandom = isIdleState ? Random(DateTime.now().millisecondsSinceEpoch ~/ (isIdleState ? 10000 : 1000)) : random;

    final nodes = List.generate(numberOfNodes, (index) {
      return Offset(
        seedRandom.nextDouble() * size.width,
        seedRandom.nextDouble() * size.height,
      );
    });

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        if (seedRandom.nextDouble() < 0.35) {
          final path = Path();
          path.moveTo(nodes[i].dx, nodes[i].dy);
          path.lineTo(nodes[j].dx, nodes[j].dy);
          canvas.drawPath(path, paint);
        }
      }
    }

    for (var i = 0; i < numberOfLines; i++) {
      final startX = seedRandom.nextDouble() * size.width;
      final startY = seedRandom.nextDouble() * size.height;
      final path = Path();
      path.moveTo(startX, startY);

      var currentX = startX;
      var currentY = startY;
      var segments = seedRandom.nextInt(5) + 3; 

      for (var j = 0; j < segments; j++) {
        if (seedRandom.nextBool()) {
          currentX +=
              seedRandom.nextDouble() * 150 - 75; 
        } else {
          currentY += seedRandom.nextDouble() * 150 - 75;
        }
        path.lineTo(currentX, currentY);
      }

      if (seedRandom.nextDouble() < 0.3) {
        final controlPoint = Offset(
          (startX + currentX) / 2 + seedRandom.nextDouble() * 50 - 25,
          (startY + currentY) / 2 + seedRandom.nextDouble() * 50 - 25,
        );
        path.quadraticBezierTo(
          controlPoint.dx,
          controlPoint.dy,
          currentX,
          currentY,
        );
      }

      canvas.drawPath(path, paint);
    }

    final dotPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var node in nodes) {
      canvas.drawCircle(node, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      true; 
}

class JarvisScreen extends StatefulWidget {
  @override
  _JarvisScreenState createState() => _JarvisScreenState();
}

class _JarvisScreenState extends State<JarvisScreen>
    with SingleTickerProviderStateMixin {
  final String apiKey = "get your api";

  late GenerativeModel model;
  late stt.SpeechToText speech;
  late FlutterTts flutterTts;
  bool isListening = false;
  bool isSpeaking = false;
  String responseText = "";
  List<Content> conversationHistory = [];
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  Timer? _timer;
  int? _remainingSeconds;
  bool _isTimerActive = false;
  bool _isWakeWordDetected = false;
  Timer? _wakeWordTimer;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isBackgroundListening = false;
  bool _isInConversationMode =
      false; 

  late AnimationController _colorAnimationController;
  late Animation<Color?> _colorAnimation;
  int _currentColorIndex = 0;
  final List<Color> _ironManColors = [
    Colors.red,
    Colors.blue,
    Color(0xFF00B8D4), // greenish blue (cyan)
    Color(0xFFE91E63), // reddish blue (pink)
    Color(0xFFFFA000), // amber (gold)
  ];

  Timer? _backgroundAnimationTimer;
  int _backgroundAnimationCounter = 0;

  @override
  void initState() {
    super.initState();
    model = GenerativeModel(model: 'put-exact-model-name-here', apiKey: apiKey);
    speech = stt.SpeechToText();
    flutterTts = FlutterTts();

    flutterTts.setLanguage("en-au");
    flutterTts.setPitch(0.8);
    flutterTts.setSpeechRate(0.6);
    flutterTts.awaitSpeakCompletion(true);
    flutterTts.setEngine("com.google.android.tts");

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;

        if (_isInConversationMode) {
          _continueConversation();
        }
      });
    });

    flutterTts.getVoices.then((voices) {
      if (voices.isNotEmpty) {
        flutterTts.setVoice(voices[0]);
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    _setupColorAnimation();

    _colorAnimationController.forward();
    _colorAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _currentColorIndex = (_currentColorIndex + 1) % _ironManColors.length;
        _setupColorAnimation();
        _colorAnimationController.reset();
        _colorAnimationController.forward();
      }
    });

    _startWakeWordDetection();

    _wakeWordTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_isBackgroundListening &&
          !speech.isListening &&
          !_isWakeWordDetected &&
          !isSpeaking &&
          !_isInConversationMode) {
        print("Wake word detection not active, restarting...");
        _startWakeWordDetection();
      }
    });

    _startBackgroundAnimationTimer();
  }

  void _startBackgroundAnimationTimer() {
    _backgroundAnimationTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!_isWakeWordDetected && !isSpeaking && !_isInConversationMode) {
        setState(() {
          _backgroundAnimationCounter++;
        });
      }
    });
  }

  void _setupColorAnimation() {
    final nextColorIndex = (_currentColorIndex + 1) % _ironManColors.length;
    _colorAnimation = ColorTween(
      begin: _ironManColors[_currentColorIndex],
      end: _ironManColors[nextColorIndex],
    ).animate(_colorAnimationController);
  }

  void _startWakeWordDetection() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => _isBackgroundListening = true);

      speech.statusListener = (status) {
        if (status == stt.SpeechToText.doneStatus ||
            status == stt.SpeechToText.notListeningStatus) {
          if (_isBackgroundListening &&
              !_isWakeWordDetected &&
              !_isInConversationMode) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted &&
                  _isBackgroundListening &&
                  !_isWakeWordDetected &&
                  !_isInConversationMode) {
                print("Restarting wake word detection...");
                _startListeningForWakeWord();
              }
            });
          }
        }
      };

      _startListeningForWakeWord();
    } else {
      print("Speech recognition not available");

      Future.delayed(Duration(seconds: 3), _startWakeWordDetection);
    }
  }

  void _startListeningForWakeWord() {
    if (!speech.isListening && mounted && !_isInConversationMode) {
      try {
        speech.listen(
          onResult: (result) {
            if (result.finalResult) {
              String userInput = result.recognizedWords.toLowerCase();
              print("Heard: $userInput");
              if (userInput.contains('jarvis') ||
                  userInput.contains('hey jarvis')) {
                setState(() => _isWakeWordDetected = true);
                _playWakeSound();

                _startConversationMode();
              }
            }
          },
          listenFor: Duration(minutes: 10), 
          pauseFor: Duration(seconds: 10), 
          partialResults: true,
          listenMode: stt.ListenMode.deviceDefault,
          cancelOnError: false,
          onSoundLevelChange: (level) {},
        );
      } catch (e) {
        print("Error starting speech recognition: $e");

        Future.delayed(Duration(seconds: 2), () {
          if (mounted && _isBackgroundListening && !_isInConversationMode) {
            _startListeningForWakeWord();
          }
        });
      }
    }
  }

  void _startConversationMode() {
    speech.stop();

    setState(() {
      _isInConversationMode = true;
      _isWakeWordDetected = true;
    });

    speak("I'm listening, sir. How can I assist you?");
  }

  void _continueConversation() {
    if (!mounted || !_isInConversationMode) return;

    print("Continuing conversation...");

    if (!speech.isListening) {
      try {
        speech.listen(
          onResult: (result) async {
            if (result.finalResult) {
              String userInput = result.recognizedWords.toLowerCase();
              print("Conversation heard: $userInput");

              if (userInput.contains("end conversation") ||
                  userInput.contains("goodbye") ||
                  userInput.contains("bye") ||
                  userInput.contains("that's all") ||
                  userInput.contains("exit conversation")) {
                _endConversationMode();
                speak(
                    "Ending conversation mode. Just say 'Hey Jarvis' when you need me again.");
                return;
              }

              processQuery(userInput);
            }
          },
          listenFor: Duration(minutes: 10),
          pauseFor: Duration(seconds: 10),
          partialResults: true,
          listenMode: stt.ListenMode.deviceDefault,
          cancelOnError: false,
          onSoundLevelChange: (level) {},
        );

        speech.statusListener = (status) {
          if ((status == stt.SpeechToText.doneStatus ||
                  status == stt.SpeechToText.notListeningStatus) &&
              _isInConversationMode &&
              !isSpeaking) {
            Future.delayed(Duration(milliseconds: 300), () {
              if (mounted &&
                  _isInConversationMode &&
                  !isSpeaking &&
                  !speech.isListening) {
                print("Restarting conversation listening...");
                _continueConversation();
              }
            });
          }
        };
      } catch (e) {
        print("Error in conversation listening: $e");

        Future.delayed(Duration(seconds: 1), () {
          if (mounted && _isInConversationMode) {
            _continueConversation();
          }
        });
      }
    }
  }

  void _endConversationMode() {
    setState(() {
      _isInConversationMode = false;
      _isWakeWordDetected = false;
    });

    if (_isBackgroundListening) {
      _startWakeWordDetection();
    }
  }

  void _processWakeWordCommand() {
    speech.stop();

    speech.listen(
      onResult: (result) async {
        if (result.finalResult) {
          String userInput = result.recognizedWords.toLowerCase();
          print("Command heard: $userInput");
          processQuery(userInput);
          setState(() => _isWakeWordDetected = false);

          Future.delayed(Duration(milliseconds: 500), () {
            if (mounted && _isBackgroundListening) {
              _startWakeWordDetection();
            }
          });
        }
      },
      listenFor: Duration(minutes: 10), 
      pauseFor: Duration(seconds: 10), 
      partialResults: true,
      listenMode: stt.ListenMode.deviceDefault,
      cancelOnError: false,
    );
  }

  void processQuery(String query) async {
    try {
      if (query.isEmpty || query.trim().isEmpty) {
        if (_isInConversationMode) {
          _continueConversation();
        }
        return;
      }

      if (query.contains("weather")) {
        _searchWeather();
        return;
      } else if (query.contains("time")) {
        _tellTime();
        return;
      } else if (query.contains("open")) {
        _openApp(query);
        return;
      } else if (query.contains("set timer")) {
        _handleTimerCommand(query);
        return;
      } else if (query.contains("set alarm")) {
        _handleAlarmCommand(query);
        return;
      }
      final chat = model.startChat(history: conversationHistory);
      conversationHistory.add(Content.text(query));

      String initialInstruction = '''
      From now onwards, talk like Jarvis from Iron Man.
      If asked what your name is, just say that you're Jarvis and if they ask who made you just tell that you were made by Tony Stark.
      Talk like JARVIS AI made by Tony Stark in IRON MAN.
      Ask the user for their name and then respond accordingly.
      Keep your responses fairly concise since they'll be spoken aloud.
      ''';

      await chat.sendMessage(Content.text(initialInstruction));
      final response = await chat.sendMessage(Content.text(query));
      conversationHistory.add(Content.text(response.text ?? "No response"));

      setState(() => responseText = "");
      speak(response.text ?? "I didn't get that.");
    } catch (e) {
      setState(() => responseText = "");
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
      "camera": "com.android.camera",
      "gallery": "com.android.gallery3d",
      "photos": "com.google.android.apps.photos",
      "youtube": "com.google.android.youtube",
      "maps": "com.google.android.apps.maps",
      "gmail": "com.google.android.gm",
      "settings": "com.android.settings",
      "play store": "com.android.vending",
      "calculator": "com.android.calculator2",
      "calendar": "com.google.android.calendar",
      "clock": "com.android.deskclock",
      "contacts": "com.android.contacts",
      "phone": "com.android.dialer",
      "messages": "com.android.mms",
      "file manager": "com.android.documentsui",
      "files": "com.android.documentsui",
      "music": "com.android.music",
      "sound recorder": "com.android.soundrecorder",
      "notes": "com.android.notes",
      "notepad": "com.android.notes",
      "browser": "com.android.chrome",
      "internet": "com.android.chrome",
      "email": "com.google.android.gm",
      "mail": "com.google.android.gm",
      "camera app": "com.android.camera",
      "gallery app": "com.android.gallery3d",
      "photos app": "com.google.android.apps.photos",
      "youtube app": "com.google.android.youtube",
      "maps app": "com.google.android.apps.maps",
      "gmail app": "com.google.android.gm",
      "settings app": "com.android.settings",
      "play store app": "com.android.vending",
      "calculator app": "com.android.calculator2",
      "calendar app": "com.google.android.calendar",
      "clock app": "com.android.deskclock",
      "contacts app": "com.android.contacts",
      "phone app": "com.android.dialer",
      "messages app": "com.android.mms",
      "file manager app": "com.android.documentsui",
      "files app": "com.android.documentsui",
      "music app": "com.android.music",
      "sound recorder app": "com.android.soundrecorder",
      "notes app": "com.android.notes",
      "notepad app": "com.android.notes",
      "browser app": "com.android.chrome",
      "internet app": "com.android.chrome",
      "email app": "com.google.android.gm",
      "mail app": "com.google.android.gm"
    };

    String cleanedQuery = query.toLowerCase().replaceAll("open", "").trim();
    print("Attempting to open app from query: '$cleanedQuery'");

    String? packageToOpen = appMap[cleanedQuery];

    if (packageToOpen == null) {
      for (var entry in appMap.entries) {
        if (cleanedQuery.contains(entry.key)) {
          packageToOpen = entry.value;
          break;
        }
      }
    }

    if (packageToOpen != null) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.MAIN',
          category: 'android.intent.category.LAUNCHER',
          package: packageToOpen,
          flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        );

        await intent.launch();
        speak("Opening ${cleanedQuery.trim()}");
      } catch (e) {
        print("Error launching app: $e");

        final playStoreUrl = Uri.parse("market://search?q=$cleanedQuery");
        try {
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
          speak(
              "I couldn't open $cleanedQuery. Opening the Play Store to search for it.");
        } catch (e) {
          speak(
              "I apologize, but I couldn't open ${cleanedQuery.trim()}. The app might not be installed.");
        }
      }
    } else {
      final playStoreUrl = Uri.parse("market://search?q=$cleanedQuery");
      try {
        await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
        speak(
            "I couldn't find $cleanedQuery. Opening the Play Store to search for it.");
      } catch (e) {
        speak(
            "I apologize, but I don't have access to open $cleanedQuery at the moment.");
      }
    }
  }

  void _handleTimerCommand(String query) async {
    if (query.contains("set timer")) {
      speak("Sir, could you please specify the duration in minutes?");
      startListening(); 
      return;
    }

    final minutesMatch = RegExp(r'(\d+)\s*(?:minute|min|m)').firstMatch(query);
    if (minutesMatch != null) {
      final minutes = int.parse(minutesMatch.group(1)!);
      _startTimer(minutes);
    } else {
      speak(
          "I couldn't understand the duration. Please specify the time in minutes.");
    }
  }

  void _startTimer(int minutes) {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      _remainingSeconds = minutes * 60;
      _isTimerActive = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds! > 0) {
          _remainingSeconds = _remainingSeconds! - 1;
        } else {
          _isTimerActive = false;
          timer.cancel();
          speak("Timer completed, sir.");
        }
      });
    });

    speak("Timer set for $minutes minutes, sir.");
  }

  void _handleAlarmCommand(String query) async {
    if (query.contains("set alarm")) {
      speak(
          "Sir, could you please specify the time for the alarm? For example, say 'set alarm for 7:30 AM'");
      startListening(); 
      return;
    }

    final timeMatch =
        RegExp(r'(\d+):(\d+)\s*(?:am|pm|AM|PM)').firstMatch(query);
    if (timeMatch != null) {
      final hour = int.parse(timeMatch.group(1)!);
      final minute = int.parse(timeMatch.group(2)!);
      final isPM = query.toLowerCase().contains('pm');

      var alarmHour = hour;
      if (isPM && hour != 12) alarmHour += 12;
      if (!isPM && hour == 12) alarmHour = 0;

      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.LAUNCHER',
        package: 'com.android.deskclock',
        componentName: 'com.android.deskclock',
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
        data: Uri.parse(
                'content://com.android.deskclock/alarm?hour=$alarmHour&minute=$minute')
            .toString(),
      );

      try {
        await intent.launch();
        speak(
            "Opening the clock app. I've set the alarm for $hour:${minute.toString().padLeft(2, '0')} ${isPM ? 'PM' : 'AM'}, sir.");
      } catch (e) {
        speak(
            "I apologize, but I couldn't open the clock app. Please try again.");
      }
    } else {
      speak(
          "I couldn't understand the time. Please specify the time in format like '7:30 AM'.");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wakeWordTimer?.cancel();
    _backgroundAnimationTimer?.cancel();
    _animationController.dispose();
    _colorAnimationController.dispose();
    _audioPlayer.dispose();
    _stopBackgroundListening();
    super.dispose();
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
        listenFor: Duration(minutes: 5),
        pauseFor: Duration(seconds: 15),
        partialResults: true,
        listenMode: stt.ListenMode.deviceDefault,
        cancelOnError: false,
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

      if (speech.isListening) {
        speech.stop();
      }

      setState(() => isSpeaking = true);
      await flutterTts.speak(cleanText);
    } else if (_isInConversationMode) {
      _continueConversation();
    }
  }

  void _stopBackgroundListening() {
    if (_isBackgroundListening) {
      speech.stop();
      setState(() => _isBackgroundListening = false);
    }
  }

  Future<void> _playWakeSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/wake.mp3'));
    } catch (e) {
      print('Error playing wake sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIdleState =
        !_isWakeWordDetected && !isSpeaking && !_isInConversationMode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: CircuitPatternPainter(
                isIdleState: isIdleState,
              ),
              key: ValueKey(
                  _backgroundAnimationCounter),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  center: Alignment.center,
                  radius: 1.5,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isTimerActive && _remainingSeconds != null)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Timer: ${(_remainingSeconds! ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds! % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.orange.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_isBackgroundListening)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _isInConversationMode
                                ? Colors.purple
                                : Colors.green,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: _isInConversationMode
                                    ? Colors.purple.withOpacity(0.5)
                                    : Colors.green.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _isInConversationMode
                              ? "CONVERSATION ACTIVE"
                              : "ALWAYS LISTENING",
                          style: TextStyle(
                            color: _isInConversationMode
                                ? Colors.blueAccent
                                : Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _isInConversationMode
                        ? "ACTIVE CONVERSATION MODE"
                        : _isWakeWordDetected
                            ? "LISTENING FOR COMMAND..."
                            : isSpeaking
                                ? "JARVIS IS RESPONDING..."
                                : "SAY 'HEY JARVIS' TO START",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isInConversationMode
                          ? Colors.blueAccent
                          : _isWakeWordDetected
                              ? Colors.green
                              : isSpeaking
                                  ? Colors.orange
                                  : Colors.cyan,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: _isInConversationMode
                              ? Colors.blueAccent
                              : _isWakeWordDetected
                                  ? Colors.green
                                  : isSpeaking
                                      ? Colors.orange
                                      : Colors.cyan,
                          blurRadius: 10,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_bounceAnimation, _colorAnimation]),
                  builder: (context, child) {
                    final currentColor =
                        _colorAnimation.value ?? _ironManColors[0];
                    return Transform.scale(
                      scale: _isWakeWordDetected ||
                              isSpeaking ||
                              _isInConversationMode
                          ? _bounceAnimation.value
                          : 1.0,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => isListening = true),
                        onTapUp: (_) {
                          if (_isInConversationMode) {
                            _endConversationMode();
                            speak(
                                "Ending conversation mode. Just say 'Hey Jarvis' when you need me again.");
                          } else {
                            startListening();
                          }
                        },
                        onTapCancel: () => setState(() => isListening = false),
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                currentColor.withOpacity(0.9),
                                currentColor.withOpacity(0.7),
                                currentColor.withOpacity(0.5),
                              ],
                              center: Alignment.center,
                              radius: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: currentColor.withOpacity(0.7),
                                blurRadius: 35,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: currentColor.withOpacity(0.4),
                                blurRadius: 60,
                                spreadRadius: 15,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.8),
                                blurRadius: 15,
                                spreadRadius: -3,
                                offset: Offset(0, 5),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.black,
                              width: 2.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 168,
                                height: 168,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: currentColor.withOpacity(0.9),
                                    width: 4,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: ArcReactorSegmentsPainter(
                                    isActive: _isWakeWordDetected ||
                                        isSpeaking ||
                                        _isInConversationMode,
                                    isConversation: _isInConversationMode,
                                    color: currentColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 144,
                                height: 144,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: currentColor.withOpacity(0.8),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 2,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  painter: CircuitLinesPainter(
                                    isActive: _isWakeWordDetected ||
                                        isSpeaking ||
                                        _isInConversationMode,
                                    isConversation: _isInConversationMode,
                                    color: currentColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: currentColor.withOpacity(0.7),
                                    width: 2.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 2,
                                      spreadRadius: 0.5,
                                    ),
                                  ],
                                ),
                                child: CustomPaint(
                                  painter: TrianglePatternPainter(
                                    isActive: _isWakeWordDetected ||
                                        isSpeaking ||
                                        _isInConversationMode,
                                    isConversation: _isInConversationMode,
                                    color: currentColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      currentColor.withOpacity(0.9),
                                      currentColor.withOpacity(0.7),
                                    ],
                                    center: Alignment.center,
                                    radius: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: currentColor.withOpacity(0.7),
                                      blurRadius: 25,
                                      spreadRadius: 4,
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.8),
                                      blurRadius: 8,
                                      spreadRadius: -2,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.5,
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: CorePatternPainter(
                                    isActive: _isWakeWordDetected ||
                                        isSpeaking ||
                                        _isInConversationMode,
                                    isConversation: _isInConversationMode,
                                    color: currentColor,
                                    showPurpleTriangle: true,
                                  ),
                                ),
                              ),
                              if (_isWakeWordDetected ||
                                  isSpeaking ||
                                  _isInConversationMode)
                                Container(
                                  width: 192,
                                  height: 192,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: currentColor.withOpacity(0.5),
                                      width: 3,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'J.A.R.V.I.S',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            shadows: [
              Shadow(
                color: Colors.blue.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black.withOpacity(0.3),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isBackgroundListening ? Icons.mic : Icons.mic_off,
              color: _isBackgroundListening
                  ? (_isInConversationMode ? Colors.purple : Colors.green)
                  : Colors.red,
              size: 28,
            ),
            onPressed: () {
              if (_isInConversationMode) {
                _endConversationMode();
                speak("Ending conversation mode.");
              }

              if (_isBackgroundListening) {
                _stopBackgroundListening();
                speak("Background listening disabled.");
              } else {
                setState(() => _isBackgroundListening = true);
                _startWakeWordDetection();
                speak(
                    "Background listening enabled. You can now say 'Hey Jarvis' anytime.");
              }
            },
            tooltip: _isBackgroundListening
                ? "Disable background listening"
                : "Enable background listening",
          ),
        ],
      ),
    );
  }
}

class CorePatternPainter extends CustomPainter {
  final bool isActive;
  final bool isConversation;
  final Color color;
  final bool showPurpleTriangle;

  CorePatternPainter({
    this.isActive = false,
    this.isConversation = false,
    this.color = Colors.blue,
    this.showPurpleTriangle = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    final path = Path();
    final triangleSize = radius * 0.8;
    final height = triangleSize * sqrt(3) / 2;

    path.moveTo(center.dx, center.dy - height / 2);
    path.lineTo(center.dx + triangleSize / 2, center.dy + height / 2);
    path.lineTo(center.dx - triangleSize / 2, center.dy + height / 2);
    path.close();

    canvas.drawPath(path, borderPaint); 
    canvas.drawPath(path, paint);

    final innerPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final innerSize = triangleSize * 0.6;
    final innerHeight = innerSize * sqrt(3) / 2;

    path.reset();
    path.moveTo(center.dx, center.dy - innerHeight / 2);
    path.lineTo(center.dx + innerSize / 2, center.dy + innerHeight / 2);
    path.lineTo(center.dx - innerSize / 2, center.dy + innerHeight / 2);
    path.close();

    canvas.drawPath(path, innerBorderPaint); 
    canvas.drawPath(path, innerPaint); 

    final dotPaint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.12, dotPaint);

    if (showPurpleTriangle) {
      final purplePaint = Paint()
        ..color = Colors.purple.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      final purpleBorderPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final purpleTrianglePath = Path();
      final purpleTriangleSize =
          radius * 0.5; 
      final purpleHeight = purpleTriangleSize * sqrt(3) / 2;

      purpleTrianglePath.moveTo(center.dx, center.dy - purpleHeight / 2);
      purpleTrianglePath.lineTo(
          center.dx + purpleTriangleSize / 2, center.dy + purpleHeight / 2);
      purpleTrianglePath.lineTo(
          center.dx - purpleTriangleSize / 2, center.dy + purpleHeight / 2);
      purpleTrianglePath.close();

      final purpleRect = Rect.fromCircle(center: center, radius: radius * 0.5);
      final purpleGradient = RadialGradient(
        colors: [
          Colors.purple.withOpacity(0.9),
          Colors.deepPurple.withOpacity(0.7),
        ],
        center: Alignment(0.2, -0.3), 
        radius: 0.8,
      );

      final gradientPaint = Paint()
        ..shader = purpleGradient.createShader(purpleRect)
        ..style = PaintingStyle.fill;

      canvas.drawPath(purpleTrianglePath, gradientPaint);
      canvas.drawPath(purpleTrianglePath, purpleBorderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TrianglePatternPainter extends CustomPainter {
  final bool isActive;
  final bool isConversation;
  final Color color;

  TrianglePatternPainter({
    this.isActive = false,
    this.isConversation = false,
    this.color = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var i = 0; i < 3; i++) {
      final angle = i * (2 * pi / 3);
      final path = Path();

      final triangleSize = radius * 0.8;
      final height = triangleSize * sqrt(3) / 2;

      final topPoint = Offset(
        center.dx + sin(angle) * height / 2,
        center.dy - cos(angle) * height / 2,
      );
      final bottomLeft = Offset(
        center.dx + sin(angle - 2 * pi / 3) * height / 2,
        center.dy - cos(angle - 2 * pi / 3) * height / 2,
      );
      final bottomRight = Offset(
        center.dx + sin(angle + 2 * pi / 3) * height / 2,
        center.dy - cos(angle + 2 * pi / 3) * height / 2,
      );

      path.moveTo(topPoint.dx, topPoint.dy);
      path.lineTo(bottomLeft.dx, bottomLeft.dy);
      path.lineTo(bottomRight.dx, bottomRight.dy);
      path.close();

      canvas.drawPath(path, borderPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CircuitLinesPainter extends CustomPainter {
  final bool isActive;
  final bool isConversation;
  final Color color;

  CircuitLinesPainter({
    this.isActive = false,
    this.isConversation = false,
    this.color = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var i = 0; i < 12; i++) {
      final angle = i * (2 * pi / 12);
      final path = Path();

      final startRadius = radius * 0.7;
      final endRadius = radius * 0.9;

      final startX = center.dx + cos(angle) * startRadius;
      final startY = center.dy + sin(angle) * startRadius;
      final endX = center.dx + cos(angle) * endRadius;
      final endY = center.dy + sin(angle) * endRadius;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);

      canvas.drawPath(path, borderPaint);
      canvas.drawPath(path, paint);
    }

    for (var i = 0; i < 6; i++) {
      final angle = i * (2 * pi / 6);
      final path = Path();

      final radius1 = radius * 0.75;
      final radius2 = radius * 0.85;

      final x1 = center.dx + cos(angle) * radius1;
      final y1 = center.dy + sin(angle) * radius1;
      final x2 = center.dx + cos(angle + pi / 3) * radius2;
      final y2 = center.dy + sin(angle + pi / 3) * radius2;

      path.moveTo(x1, y1);
      path.lineTo(x2, y2);

      canvas.drawPath(path, borderPaint);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ArcReactorSegmentsPainter extends CustomPainter {
  final bool isActive;
  final bool isConversation;
  final Color color;

  ArcReactorSegmentsPainter({
    this.isActive = false,
    this.isConversation = false,
    this.color = Colors.blue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = color.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5;

    for (var i = 0; i < 8; i++) {
      final angle = i * (2 * pi / 8);
      final path = Path();

      final startRadius = radius * 0.9;
      final endRadius = radius;

      final startX = center.dx + cos(angle) * startRadius;
      final startY = center.dy + sin(angle) * startRadius;
      final endX = center.dx + cos(angle) * endRadius;
      final endY = center.dy + sin(angle) * endRadius;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);

      canvas.drawPath(path, borderPaint);
      canvas.drawPath(path, paint);
    }

    final innerPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var i = 0; i < 16; i++) {
      final angle = i * (2 * pi / 16);
      final path = Path();

      final startRadius = radius * 0.85;
      final endRadius = radius * 0.95;

      final startX = center.dx + cos(angle) * startRadius;
      final startY = center.dy + sin(angle) * startRadius;
      final endX = center.dx + cos(angle) * endRadius;
      final endY = center.dy + sin(angle) * endRadius;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);

      canvas.drawPath(path, innerBorderPaint);
      canvas.drawPath(path, innerPaint);
    }

    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.transparent,
        ],
        center: Alignment(-0.2, -0.2), 
        radius: 0.8,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.95, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
