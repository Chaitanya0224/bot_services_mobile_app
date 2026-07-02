import 'dart:async';
import 'package:flutter/material.dart';
import '../services/bot_service.dart';
import '../services/tts_service.dart';
import '../services/stt_service.dart';
import '../widgets/clay_container.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatScreen extends StatefulWidget {
  final String? initialPrompt;

  const ChatScreen({super.key, this.initialPrompt});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final BotService _botService = BotService();
  final TtsService _ttsService = TtsService();
  final SttService _sttService = SttService();

  bool _isListening = false;
  bool _isTyping = false;
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
    _sttService.initialize();

    _messages.add(
      ChatMessage(
        text: "Hello! I am Joke BOT. Tap the microphone icon or type a message to ask for a joke!",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    // Track input field typing changes
    _inputController.addListener(_onTextChanged);

    if (widget.initialPrompt != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendMessage(widget.initialPrompt!);
      });
    }
  }

  void _onTextChanged() {
    final hasText = _inputController.text.trim().isNotEmpty;
    if (hasText != _showSendButton) {
      setState(() {
        _showSendButton = hasText;
      });
    }
  }

  void _listen() {
    if (!_isListening) {
      _sttService.listen(
        onResult: (text) {
          setState(() {
            _inputController.text = text;
          });
        },
        onListeningStateChanged: (listening) {
          setState(() {
            _isListening = listening;
          });
        },
      );
    } else {
      _sttService.stop((listening) {
        setState(() {
          _isListening = listening;
        });
      });
      if (_inputController.text.trim().isNotEmpty) {
        _handleSendMessage(_inputController.text.trim());
      }
    }
  }

  void _handleSendMessage(String text) {
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _inputController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Fetch response asynchronously from the Nvidia LLM
    _botService.getBotResponse(text).then((response) {
      if (mounted) {
        setState(() {
          _messages.add(
            ChatMessage(
              text: response,
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
          _isTyping = false;
        });
        _scrollToBottom();
        _ttsService.speak(response);
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.removeListener(_onTextChanged);
    _inputController.dispose();
    _scrollController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF093B33),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFF2EDE1)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: ClayContainerDecoration(
                color: const Color(0xFF103F46),
                borderRadius: 12,
              ),
              child: const Icon(
                Icons.face_retouching_natural_rounded,
                color: Color(0xFFD8C08A),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Joke BOT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF2EDE1),
                  ),
                ),
                Text(
                  _isTyping ? 'typing...' : 'online',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isTyping ? const Color(0xFFD8C08A) : Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _ttsService.isEnabled ? Icons.volume_up : Icons.volume_off,
              color: const Color(0xFFD8C08A),
            ),
            onPressed: () {
              setState(() {
                _ttsService.isEnabled = !_ttsService.isEnabled;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF071B1E),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildChatBubble(message);
                },
              ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      'Joke BOT is writing a funny response...',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFFF2EDE1).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24, top: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF093B33),
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF0A5E4E),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: ClayContainerDecoration(
                        color: const Color(0xFF071B1E),
                        borderRadius: 24,
                        depthInverted: true,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.sentiment_satisfied_alt, color: Color(0xFFD8C08A)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _inputController,
                              style: const TextStyle(color: Color(0xFFF2EDE1)),
                              decoration: const InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Colors.white24),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.white54),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_showSendButton) {
                        _handleSendMessage(_inputController.text.trim());
                      } else {
                        _listen();
                      }
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: ClayContainerDecoration(
                        color: _isListening ? const Color(0xFFD8C08A) : const Color(0xFF0A5E4E),
                        borderRadius: 25,
                      ),
                      child: Icon(
                        _showSendButton
                            ? Icons.send
                            : (_isListening ? Icons.mic_off : Icons.mic),
                        color: _isListening ? const Color(0xFF071B1E) : const Color(0xFFF2EDE1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: ClayContainerDecoration(
          color: isUser ? const Color(0xFF0A5E4E) : const Color(0xFF103F46),
          borderRadius: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: const TextStyle(
                color: Color(0xFFF2EDE1),
                fontSize: 15,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 10,
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
