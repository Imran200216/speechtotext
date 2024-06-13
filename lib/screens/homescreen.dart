import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText speechToText = SpeechToText();

  bool speechEnabled = false;

  String wordsSpoken = "";

  double confidenceLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(result) {
    setState(() {
      wordsSpoken = "${result.recognizedWords}";
      confidenceLevel = result.confidence;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          speechToText.isListening ? stopListening() : startListening();
        },
        tooltip: "Listen",
        child: Icon(
          speechToText.isListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Speech to Text"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                speechToText.isListening
                    ? "listening..."
                    : speechEnabled
                        ? "Tap the microphone to start listening..."
                        : "Speech not available",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                wordsSpoken,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )),
            if (speechToText.isNotListening && confidenceLevel > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Confidence: ${(confidenceLevel * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
