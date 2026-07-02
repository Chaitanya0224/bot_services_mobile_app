import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'voice_bot_screen.dart';
import '../widgets/clay_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium AI',
                        style: TextStyle(
                          color: const Color(0xFFD8C08A).withOpacity(0.8), // Champagne Gold
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const Text(
                        'Joke BOT',
                        style: TextStyle(
                          color: Color(0xFFF2EDE1), // Ivory Silk
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: ClayContainerDecoration(
                      color: const Color(0xFF093B33),
                      borderRadius: 15,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFFF2EDE1),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),

              // Interactive Bot Avatar Block
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: ClayContainerDecoration(
                    color: const Color(0xFF093B33), // Forest Depth
                    borderRadius: 24,
                  ),
                  child: Row(
                    children: [
                      const _AnimatedAvatar(),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A5E4E), // Emerald Palace
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'ONLINE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFD8C08A),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap to Chat & Laugh',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF2EDE1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Voice assistant is fully active.',
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFFF2EDE1).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFFD8C08A),
                        size: 32,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bento Grid Section
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
                children: [
                  // Bento Block 1: Voice Bot Mode launcher
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const VoiceBotScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ClayContainerDecoration(
                        color: const Color(0xFF103F46), // Royal Teal
                        borderRadius: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.keyboard_voice,
                            color: Color(0xFFD8C08A),
                            size: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Voice Bot',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFF2EDE1),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Speech In / Speech Out',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFFF2EDE1).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bento Block 2: Quick Action
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(initialPrompt: "Tell me a knock-knock joke!"),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: ClayContainerDecoration(
                        color: const Color(0xFF093B33),
                        borderRadius: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.bolt,
                            color: Color(0xFFD8C08A),
                            size: 32,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Quick Joke',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFFF2EDE1),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Knock-knock variant',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(0xFFF2EDE1).withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bento Block 3: Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: ClayContainerDecoration(
                      color: const Color(0xFF093B33),
                      borderRadius: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '100%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFD8C08A),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Funny Level',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFF2EDE1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Guaranteed laughs',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFFF2EDE1).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bento Block 4: TTS Config
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: ClayContainerDecoration(
                      color: const Color(0xFF103F46),
                      borderRadius: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          Icons.volume_up_outlined,
                          color: Color(0xFFD8C08A),
                          size: 32,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Voice Feedback',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFF2EDE1),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Text-to-Speech active',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color(0xFFF2EDE1).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Launch CTA Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: ClayContainerDecoration(
                    color: const Color(0xFFD8C08A),
                    borderRadius: 20,
                  ),
                  child: const Center(
                    child: Text(
                      'START CHATTING NOW',
                      style: TextStyle(
                        color: Color(0xFF071B1E),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedAvatar extends StatefulWidget {
  const _AnimatedAvatar();

  @override
  State<_AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<_AnimatedAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnimation,
      child: Container(
        width: 64,
        height: 64,
        decoration: ClayContainerDecoration(
          color: const Color(0xFF103F46),
          borderRadius: 20,
        ),
        child: const Icon(
          Icons.sentiment_very_satisfied_outlined,
          color: Color(0xFFD8C08A),
          size: 36,
        ),
      ),
    );
  }
}
