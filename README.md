# 🎙️ voiceAssistant

**voiceAssistant** is a Flutter-based AI-powered voice assistant, powered by Gemini 2.5 Flash. Ask it about Sports, History, Science, or any topic, and it responds via text and speech! Supports full multi-turn conversations, preserving context across messages for natural, human-like interactions.

## 🌟 Features
- 🎤 Real-time Speech-to-Text recognition.
- 🗣️ Text-to-Speech AI responses.
- 💬 Animated, scrollable chat interface.
- 🌗 Light & Dark mode support.
- 🔄 Quick reset functionality.
- 🤖 Supports multi-turn, context-aware conversations

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10
- Android/iOS device or emulator
- Gemini API Key (stored securely, not included)

### Installation
```
git clone https://github.com/yourusername/voice_assistant.git
cd voice_assistant
flutter pub get
```

### Create a ```secrets.dart``` file in lib folder and store your GEMINI_API_KEY : 
```const String GEMINI_API_KEY = "YOUR_API_KEY_HERE";```

### Run the app:
```flutter run```

## 🛠️ Usage

1. Tap the 🎤 microphone button to start speaking.
2. Speak your query clearly.
3. The assistant replies with text and voice.
4. Tap the 🔄 refresh icon to reset the chat.
5. Toggle dark/light mode with the 🌗 icon.

## 🔒 Privacy & Safety

- API key is never committed.
- No data, voice or text, is stored locally or remotely.

## ⚠️ Limitations

1. **Gemini API**
   - Responses are generated via the Gemini 2.5 API Flash, which has memory and context limitations. This might result in inaccurate information, especially for more recent information.
   - Occasionally, the API may fail due to network issues or rate limits — the app handles this with an ```API_ERROR``` fallback.

2. **Voice Recognition (```speech_to_text```)**
   - Accuracy depends on device microphone quality and ambient noise.
   - Some devices may not support continuous listening or long recordings.
   - Limited support for non-English languages unless configured on the device.

3. **Text-to-Speech (```flutter_tts```)**
   - Voice quality and speed vary by device.
   - Certain voices or languages may not be available on all platforms.

4. **Platform Differences**
   - Minor UI differences may appear on small devices or iOS/Android due to system-level font scaling, safe area insets, and TTS/voice recognition behavior.

## 🤝 Contributing

Contributions welcome! Open issues or submit pull requests to improve the app. <br>
It would be really helpful if someone could do the testing for iOS platform since it couldn't be done due to device constraints. <br>
If any bugs are found, feel free to open issues or submit pull requests! Thanks in advance! <br>

## 📄 License

This project is licensed under the [MIT License](./LICENSE.txt).

## Fun Fact

Such a dull name because I named it in a rush, plan to change it later!










