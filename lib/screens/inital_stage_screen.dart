import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/screens/setup_timeline_screen.dart';

class InitialStageScreen extends StatefulWidget {
  final int initialQuestionIndex;

  const InitialStageScreen({Key? key, this.initialQuestionIndex = 0}) : super(key: key);

  @override
  _InitialStageScreenState createState() => _InitialStageScreenState();
}

class _InitialStageScreenState extends State<InitialStageScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _questions = [
    'What is your first question?',
    'What is your second question?',
    'What is your third question?',
    'What is your fourth question?',
  ];
  int _currentQuestionIndex = 0;
  List<String> _answers = [];

  @override
  void initState() {
    super.initState();
    _currentQuestionIndex = widget.initialQuestionIndex;
    _loadAnswers();
  }

  // Load answers from shared preferences
  void _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _answers = prefs.getStringList('answers') ?? [];
      _currentQuestionIndex = _answers.length; // Continue from the last answered question
    });
  }

  // Save answers to shared preferences
  void _saveAnswer(String answer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _answers.add(answer);
      prefs.setStringList('answers', _answers);
    });
  }

  void _nextQuestion(String answer) {
    if (answer.isNotEmpty) {
      _saveAnswer(answer);
      _controller.clear();
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All questions answered!')),
        );
      }
    }
  }

  void _goToNextStep() {
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SetupTimelineScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Centered Circle
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                color: Color(0xFF246EE9).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 30.0), // Space between circle and text
            // Question Text
            Text(
              _questions[_currentQuestionIndex],
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30.0), // Space between question text and text input
            // Text Input Prompt
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type here...',
                ),
                onSubmitted: _nextQuestion,
              ),
            ),
            SizedBox(height: 30.0), // Space between text input and button
            // Show button after all questions are answered
            if (_currentQuestionIndex == _questions.length - 1)
              ElevatedButton(
                onPressed: _goToNextStep,
                child: Text('Go to Next Step'),
              ),
          ],
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: InitialStageScreen(),
  ));
}
