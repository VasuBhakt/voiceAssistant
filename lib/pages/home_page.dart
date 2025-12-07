import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/colors/pallete.dart';
import 'package:voice_assistant/services/gemini_service.dart';
import 'package:voice_assistant/widgets/chat_bubble.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  List<Map<String, dynamic>> defaultMessages = [
    {
      "role": "model",
      "parts": [
        {
          "text":
              "Hi there! I'm voiceAssistant, powered by Gemini 2.5. Curious about Sports, History, or Science? Just ask me, and I’ll help!",
        },
      ],
    },
    {
      "role": "model",
      "parts": [
        {"text": "Here are some suggestions!"},
      ],
    },
    {
      "role": "user",
      "parts": [
        {"text": "Who was Subhash Chandra Bose?"},
      ],
    },
    {
      "role": "user",
      "parts": [
        {"text": "Tell me about quantum mechanics"},
      ],
    },
    {
      "role": "user",
      "parts": [
        {"text": "What is Formula 1?"},
      ],
    },
  ];
  //String textSearch = '';
  List<Map<String, dynamic>> messages = [];
  String speech = '';
  bool defMessage = true;
  bool isReplying = false;
  bool apiError = false;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();

    messages = [];

    Future.delayed(Duration(milliseconds: 300), () {
      addDefaultMessagesAnimated();
    });
  }

  void addDefaultMessagesAnimated() async {
    for (int i = 0; i < defaultMessages.length; i++) {
      await Future.delayed(Duration(milliseconds: 250)); // animation delay
      messages.insert(i, Map<String, dynamic>.from(defaultMessages[i]));
      _listKey.currentState?.insertItem(i);
    }
  }

  void insertAnimatedMessage(Map<String, dynamic> msg) {
    messages.add(msg);
    _listKey.currentState?.insertItem(messages.length - 1);
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechToTextResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechToTextResult(SpeechRecognitionResult result) async {
    setState(() {
      speech = result.recognizedWords;
    });

    if (result.finalResult && speech.isNotEmpty && !isReplying) {
      addUserMessage(speech);
      speech = '';

      setState(() {
        isReplying = true;
      });

      final reply = await GeminiService().geminiAPI(messages);
      if (reply == "API_ERROR") {
        setState(() {
          apiError = true;
          isReplying = false;
        });
        showErrorSnackBar(
          "There seems to be a problem, please try again later.",
        );
        return;
      }
      setState(() {
        insertAnimatedMessage({
          "role": "model",
          "parts": [
            {"text": reply},
          ],
        });

        isReplying = false;
        apiError = false;
      });

      if (reply.trim().isNotEmpty) {
        await systemSpeak(reply);
      }
    }
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  void addUserMessage(String text) {
    if (defMessage) {
      removeAllAnimated();
      defMessage = false;
    }

    setState(() {
      insertAnimatedMessage({
        "role": "user",
        "parts": [
          {"text": text},
        ],
      });
    });
  }

  void removeAllAnimated() {
    final count = messages.length;

    for (int i = count - 1; i >= 0; i--) {
      final removedMessage = messages.removeAt(i);

      _listKey.currentState?.removeItem(
        i,
        (context, animation) => FadeTransition(
          opacity: animation,
          child: ChatBubble(
            message: removedMessage["parts"][0]["text"],
            role: removedMessage["role"],
            isDarkMode: widget.isDarkMode,
          ),
        ),
        duration: Duration(milliseconds: 150),
      );
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void resetApp() {
    speechToText.stop();
    flutterTts.stop();

    removeAllAnimated();

    setState(() {
      messages.clear();
      _listKey.currentState?.setState(() {});

      Future.delayed(Duration(milliseconds: 300), () {
        addDefaultMessagesAnimated();
      });

      defMessage = true;
      speech = "";
      isReplying = false;
      apiError = false;
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        scrolledUnderElevation: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            const Center(
              child: Text(
                "voiceAssistant",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: widget.toggleTheme,
                icon: Icon(Icons.light_mode),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(onPressed: resetApp, icon: Icon(Icons.refresh)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/alice.png'),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: AnimatedList(
                key: _listKey,
                padding: EdgeInsets.only(top: 10),
                initialItemCount: messages.length,
                itemBuilder: (context, index, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ChatBubble(
                      message: messages[index]["parts"][0]["text"],
                      role: messages[index]["role"],
                      isDarkMode: widget.isDarkMode,
                    ),
                  );
                },
              ),
            ),

            if (isReplying)
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(bottom: 5),
                child: Text(
                  "Replying...",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: (!widget.isDarkMode) ? Colors.black : Colors.white,
                  ),
                ),
              ),
            SizedBox(height: 10),
            SafeArea(
              child: Align(
                alignment: AlignmentGeometry.bottomRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await speechToText.hasPermission &&
                        speechToText.isNotListening) {
                      await startListening();
                    } else if (speechToText.isListening) {
                      await stopListening();
                    } else {
                      initSpeechToText();
                    }
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Icon(
                    (speechToText.isNotListening) ? Icons.mic : Icons.stop,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
