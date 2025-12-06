import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/colors/pallete.dart';
import 'package:voice_assistant/services/gemini_service.dart';
import 'package:voice_assistant/widgets/chat_bubble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SpeechToText speechToText = SpeechToText();
  String speech = '';
  //String textSearch = '';
  List<Map<String, dynamic>> messages = [
    {
      "role": "model",
      "parts": [
        {"text": "Hello! What can I do to help you?"},
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
        {"text": "What's the weather today?"},
      ],
    },
    {
      "role": "model",
      "parts": [
        {"text": "The weather is sunny!"},
      ],
    },
    {
      "role": "user",
      "parts": [
        {"text": "Tell me about Formula 1?"},
      ],
    },
  ];
  bool defMessage = true;
  bool isReplying = false;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
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
      // LOCK: block duplicates
      addUserMessage(speech);
      speech = '';

      setState(() {
        isReplying = true;
      });

      final reply = await GeminiService().geminiAPI(messages);

      setState(() {
        messages.add({
          "role": "model",
          "parts": [
            {"text": reply},
          ],
        });
        isReplying = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  void addUserMessage(String text) {
    setState(() {
      if (defMessage) {
        messages.clear(); // remove default messages if FIRST message
        defMessage = false;
      }
      messages.add({
        "parts": [
          {"text": text},
        ],
        "role": "user",
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              child: IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
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
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ChatBubble(
                    message: messages[index]["parts"][0]["text"],
                    role: messages[index]["role"],
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
                    color: Colors.black,
                  ),
                ),
              ),
            SizedBox(height: 10),
            /*SafeArea(
              child: Row(
                children: [
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter your question here!",
                      
                    ),
                  )),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                  
                ],
              ),
            ),*/
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
                  backgroundColor: Pallete.firstSuggestionBoxColor,
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
