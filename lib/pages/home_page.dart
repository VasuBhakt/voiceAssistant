import 'package:flutter/material.dart';
import 'package:voice_assistant/colors/pallete.dart';
import 'package:voice_assistant/widgets/chat_bubble.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              child: ListView(
                padding: EdgeInsets.only(top: 10),
                children: [
                  ChatBubble(
                    message: "Hello! What can I do for you?",
                    user: false,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Here are a few suggestions!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Pallete.mainFontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ChatBubble(message: "What's the weather today?", user: true),
                  ChatBubble(message: "How to build a startup?", user: true),
                  ChatBubble(message: "What was the scoreline for Mohun Bagan vs East Bengal", user: true),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextField()),
                IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Pallete.firstSuggestionBoxColor,
                  child: Icon(Icons.mic, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
