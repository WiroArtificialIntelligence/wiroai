import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/widgets/text_bubble.dart';
import 'package:wiroai/screens/music_screen.dart';
import 'package:wiroai/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class QuestionaireStageScreen extends StatefulWidget {
  @override
  _QuestionaireStageScreenState createState() =>
      _QuestionaireStageScreenState();
}

class _QuestionaireStageScreenState extends State<QuestionaireStageScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final List<String> _answers = List.filled(4, '');
  final List<String> _questions = [
    'How do you feel this morning?',
    'How is your afternoon going?',
    'How was your evening?',
    'Here is the following music!'
  ];
  int _currentQuestionIndex = 0;
  bool _canType = false;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  // Function to decode Base64 string and save as MP3
  Future<void> decodeBase64ToMp3(String base64Str, String fileName) async {
    try {
      Uint8List bytes = base64Decode(base64Str);
      Directory dir = await getApplicationDocumentsDirectory();
      String dirPath = '${dir.path}/$fileName';
      File file = File(dirPath);
      await file.writeAsBytes(bytes);

      // print('MP3 file saved to $dirPath');
    } catch (e) {
      // print('An error occurred while decoding or writing the file: $e');
    }
  }

  Future<void> _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String morningSlot = prefs.getString("morning") ?? "";
    String afternoonSlot = prefs.getString("afternoon") ?? "";
    String eveningSlot = prefs.getString("evening") ?? "";
    String musicSlot = prefs.getString("music") ?? "";
    final now = DateTime.now();
    final hour = now.hour;

    if (hour == 0) {
      await prefs.clear();
      setState(() {
        _messages.clear();
      });
      return;
    }

    int morningHour = convertTime(morningSlot);
    int afternoonHour = convertTime(afternoonSlot);
    int eveningHour = convertTime(eveningSlot);
    int musicHour = convertTime(musicSlot);
    if (hour < morningHour) {
      _lockPrompt();
    } else if (hour >= morningHour && prefs.getString("answer_0") == null) {
      _unlockPrompt();
      _showQuestion(0);
    } else if (hour < afternoonHour) {
      _lockPrompt();
    } else if (hour >= afternoonHour && prefs.getString("answer_1") == null) {
      _unlockPrompt();
      _showQuestion(1);
    } else if (hour < eveningHour) {
      _lockPrompt();
    } else if (hour >= eveningHour && prefs.getString("answer_2") == null) {
      _unlockPrompt();
      _showQuestion(2);
    } else if (hour < musicHour) {
      _lockPrompt();
    } else {
      ApiService apiService = ApiService();
      final response = await apiService.fetchMusic(
          prefs.getString("answer_0") ?? '',
          prefs.getString("answer_1") ?? '',
          prefs.getString("answer_2") ?? '');
      if (response.success) {
        await decodeBase64ToMp3(response.data, 'output.mp3');
        _unlockPrompt();
        _showMusic();
      } else {
        print('Failed to fetch music: ${response.errorMessage}');
      }
    }
  }

  void _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedMessages = _messages.map((message) {
      final buttonText = message['buttonText'] ?? '';
      final isUserMessage = message['isUserMessage'] ?? false;
      return '${message['text']}|$buttonText|${isUserMessage ? 'user' : 'system'}';
    }).toList();
    await prefs.setStringList('messages', savedMessages);
  }

  void _showQuestion(int index) {
    setState(() {
      _messages.add({
        'text': _questions[index],
        'buttonText': null,
        'isUserMessage': false,
      });
      _currentQuestionIndex = index;
    });
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty && _canType) {
      setState(() {
        _messages.add({
          'text': message,
          'buttonText': null,
          'isUserMessage': true,
        });
        _answers[_currentQuestionIndex] = message;
        _canType = false;
      });
      _messageController.clear();
      FocusScope.of(context).unfocus();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('answer_$_currentQuestionIndex', message);

      _saveMessages();
      _loadAnswers();
    }
  }

  int convertTime(String time) {
    final timeFormat = RegExp(r'(\d{1,2}):(\d{2})\s(AM|PM)');
    final match = timeFormat.firstMatch(time);

    if (match == null) {
      throw ArgumentError('Invalid time format. Use "hh:mm AM/PM".');
    }

    int hour = int.parse(match.group(1)!);
    final period = match.group(3)!;

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return hour;
  }

  void _lockPrompt() {
    setState(() {
      _canType = false;
    });
  }

  void _unlockPrompt() {
    setState(() {
      _canType = true;
    });
  }

  void _showMusic() {
    setState(() {
      _messages.add({
        'text': 'Here is the music!',
        'buttonText': 'Listen to Music',
        'isUserMessage': false,
      });
    });
  }

  void _listenToMusic() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MusicScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final text = message['text'];
                final buttonText = message['buttonText'];
                final isUserMessage = message['isUserMessage'] ?? false;

                if (buttonText != null) {
                  return Column(
                    crossAxisAlignment: isUserMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      TextBubble(
                        message: text,
                        fromUser: isUserMessage,
                      ),
                      SizedBox(height: 10.0),
                      if (!isUserMessage)
                        ElevatedButton(
                          onPressed: _listenToMusic,
                          child: Text(buttonText,
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                    ],
                  );
                }

                return TextBubble(
                  message: text,
                  fromUser: isUserMessage,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 32.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onSubmitted: (value) => _sendMessage(),
                    enabled: _canType,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _canType ? _sendMessage : null,
                  child: Icon(Icons.send, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC788A),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
