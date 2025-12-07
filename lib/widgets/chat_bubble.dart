import 'package:flutter/material.dart';
import 'package:voice_assistant/colors/pallete.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String role;
  final bool isDarkMode;
  const ChatBubble({
    super.key,
    required this.message,
    required this.role,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: (isDarkMode)
              ? Pallete.darkModeBorderColor
              : Pallete.lightModeBorderColor,
        ),
        borderRadius: (role == "user")
            ? BorderRadius.all(
                Radius.circular(20),
              ).copyWith(topRight: Radius.circular(0))
            : BorderRadius.all(
                Radius.circular(20),
              ).copyWith(topLeft: Radius.circular(0)),
        color: (role == "user")
            ? ((isDarkMode) ? Pallete.darkModeUser : Pallete.lightModeUser)
            : ((isDarkMode) ? Pallete.darkModeModel : Pallete.lightModeModel),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 18, 101, 1),
            blurRadius: 12,
            offset: Offset(0, 6)
          )
        ]
      ),
      alignment: (role == "user")
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: (isDarkMode)
                ? Pallete.darkModeFontColor
                : Pallete.lightModeFontColor,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
