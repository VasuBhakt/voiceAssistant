import 'package:flutter/material.dart';
import 'package:voice_assistant/colors/pallete.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool user;
  const ChatBubble({super.key, required this.message, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(top: 25),
      decoration: BoxDecoration(
        border: Border.all(color: Pallete.borderColor),
        borderRadius: (user)
            ? BorderRadius.all(
                Radius.circular(20),
              ).copyWith(topRight: Radius.circular(0))
            : BorderRadius.all(
                Radius.circular(20),
              ).copyWith(topLeft: Radius.circular(0)),
        color: (user) ? Pallete.secondSuggestionBoxColor : Pallete.firstSuggestionBoxColor
      ),
      alignment: (user) ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Pallete.mainFontColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
