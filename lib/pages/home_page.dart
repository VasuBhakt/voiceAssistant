import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/colors/pallete.dart';
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
    {"text": "Hello! What can I do for you?", "user": false},
    {"text": "Here are a few suggestions!", "user": false},
    {"text": "What's the weather today?", "user": true},
    {"text": "How to build a startup?", "user": true},
    {"text": "What was the result of the latest Grand Prix?", "user": true},
  ];
  bool defMessage = true;

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

  void onSpeechToTextResult(SpeechRecognitionResult result) {
    setState(() {
      speech = result.recognizedWords;
    });

    // When speech is finalized
    if (result.finalResult && speech.isNotEmpty) {
      addUserMessage(result.recognizedWords);
      speech = '';
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
      messages.add({"text": text, "user": true});
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
                    message: messages[index]["text"],
                    user: messages[index]["user"],
                  );
                },
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
