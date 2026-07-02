import 'dart:async';
import 'package:flutter/material.dart';
import '../services/bot_service.dart';
import '../services/tts_service.dart';
import '../services/stt_service.dart';
import '../widgets/clay_container.dart';

class VoiceBotScreen extends StatefulWidget {
  const VoiceBotScreen({super.key});

  @override
  State<VoiceBotScreen> createState() => _VoiceBotScreenState();
}

class _VoiceBotScreenState extends State<VoiceBotScreen> with SingleTickerProviderStateMixin {
  final BotService _botService = BotService();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  bool _isListening = false;
  String _recognizedSubtitle = "Tap Mic to Start Speaking...";
  String _botResponseSubtitle = "";
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _sttService.initialize();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Auto-start listening on launch for hands-free premium feel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  void _startListening() {
    _ttsService.stop();
    setState(() {
      _botResponseSubtitle = "";
      _recognizedSubtitle = "Listening...";
    });
    _sttService.listen(
      onResult: (text) {
        setState(() {
          _recognizedSubtitle = text;
        });
      },
      onListeningStateChanged: (listening) {
        setState(() {
          _isListening = listening;
        });
        if (!listening && _recognizedSubtitle.isNotEmpty && _recognizedSubtitle != "Listening...") {
          _processVoiceInput(_recognizedSubtitle);
        }
      },
    );
  }

  void _processVoiceInput(String query) {
    setState(() {
      _botResponseSubtitle = "Thinking...";
    });
    
    _botService.getBotResponse(query).then((response) {
      if (mounted) {
        setState(() {
          _botResponseSubtitle = response;
        });
        _ttsService.speak(response);
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF2EDE1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'VOICE MODE',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Color(0xFFD8C08A),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF071B1E),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bot Response / Subtitle Panel
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_botResponseSubtitle.isNotEmpty) ...[
                      Text(
                        "BOT RESPONDED:",
                        style: TextStyle(
                          color: const Color(0xFFD8C08A).withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _botResponseSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFF2EDE1),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.question_answer_outlined,
                        size: 64,
                        color: Colors.white12,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Ask me a question or for a joke!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 16,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            // User Subtitles (STT Output)
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: ClayContainerDecoration(
                color: const Color(0xFF093B33),
                borderRadius: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "YOU SAID:",
                    style: TextStyle(
                      color: const Color(0xFFD8C08A).withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recognizedSubtitle,
                    style: const TextStyle(
                      color: Color(0xFFF2EDE1),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Immersive Wave Animation & Speaking Controller
            Column(
              children: [
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          double height = 15.0 + (index * 8.0);
                          if (_isListening) {
                            height = height * _waveController.value;
                          } else {
                            height = 8.0;
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 6,
                            height: height,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8C08A),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Interactive Mic Button
                GestureDetector(
                  onTap: () {
                    if (_isListening) {
                      _sttService.stop((listening) {
                        setState(() {
                          _isListening = listening;
                        });
                      });
                    } else {
                      _startListening();
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: ClayContainerDecoration(
                      color: _isListening ? const Color(0xFFD8C08A) : const Color(0xFF0A5E4E),
                      borderRadius: 40,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: _isListening ? const Color(0xFF071B1E) : const Color(0xFFF2EDE1),
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isListening ? "Listening..." : "Tap to Speak",
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFF2EDE1).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
