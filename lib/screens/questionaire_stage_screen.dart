import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/widgets/text_bubble.dart';

class QuestionaireStageScreen extends StatefulWidget {
  @override
  _QuestionaireStageScreenState createState() => _QuestionaireStageScreenState();
}

class _QuestionaireStageScreenState extends State<QuestionaireStageScreen> {
  final List<Map<String, dynamic>> _messages = [];  // List to hold chat messages and associated actions
  final TextEditingController _messageController = TextEditingController();  // Controller for the text input field
  final List<String> _answers = List.filled(4, '');  // List to hold answers
  final List<String> _questions = [
    'How do you feel this morning?',
    'How is your afternoon going?',
    'How was your evening?',
    'Here is the following music!'
  ];  // List of questions
  int _currentQuestionIndex = 0;  // Index of the current question
  bool _canType = false;  // Flag to indicate if the user can type

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String morningSlot = prefs.getString("morning") ?? "";
    String afternoonSlot = prefs.getString("afternoon") ?? "";
    String eveningSlot = prefs.getString("evening") ?? "";
    String musicSlot = prefs.getString("music") ?? "";
    final now = DateTime.now();
    final hour = now.hour;

    print(prefs.getKeys());

    if (hour == 0) {
      // Clear all saved preferences if hour is zero
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
      _showMusic();  // Call the method to show music
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
        'isUserMessage': false,  // System message
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
          'isUserMessage': true,  // User message
        });  // Add the message to the list
        _answers[_currentQuestionIndex] = message;  // Save the answer
        _canType = false;  // Disable typing until the next question appears
      });
      _messageController.clear();  // Clear the text field
      FocusScope.of(context).unfocus();  // Close the keyboard

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('answer_$_currentQuestionIndex', message);

      _saveMessages();  // Save the messages

      _loadAnswers(); // reload the answer
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

    return hour;  // Return as an integer
  }

  void _lockPrompt() {
    setState(() {
      _canType = false;  // Lock the prompt
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
        'isUserMessage': false,  // System message
      });
    });
  }

  void _listenToMusic() async {
    // const url = 'https://example.com/music';  // Replace with your music URL
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
    print("HELLO");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),  // Set back button color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),  // Set text color to white
        ),
        backgroundColor: Colors.black,  // AppBar color
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
                    crossAxisAlignment: isUserMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      TextBubble(
                        message: text,
                        fromUser: isUserMessage,  // Show message on the correct side
                      ),
                      SizedBox(height: 10.0),  // Space between text bubble and button
                      if (!isUserMessage)  // Show button only for system messages
                        ElevatedButton(
                          onPressed: _listenToMusic,  // Open music link
                          child: Text(buttonText, style: TextStyle(color: Colors.white)),  // Set button text color to white
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,  // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                    ],
                  );
                }

                return TextBubble(
                  message: text,
                  fromUser: isUserMessage,  // Set to true for user messages, false for system messages
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
                    enabled: _canType,  // Disable the TextField based on _canType
                  ),
                ),
                SizedBox(width: 8.0),  // Space between text field and send button
                ElevatedButton(
                  onPressed: _canType ? _sendMessage : null,  // Disable the send button based on _canType
                  child: Icon(Icons.send, color: Colors.white),  // Send button icon
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDC788A),  // Send button color
                    shape: CircleBorder(),  // Circular shape for the button
                    padding: EdgeInsets.all(12.0),  // Padding for the button
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
