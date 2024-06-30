import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/screens/inital_stage_screen.dart' as initial_stage; // Use alias
import 'package:wiroai/screens/setup_timeline_screen.dart' as setup_timeline; // Use alias

// Intro Screen Definition
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // White background color
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),  // Horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Center content vertically
          children: [
            // Title at the top
            Text(
              'Welcome to Wiro AI',
              style: TextStyle(
                fontSize: 28.0,  // Title font size
                fontWeight: FontWeight.bold,
                color: Colors.black,  // Title color
              ),
            ),
            SizedBox(height: 30),  // Spacer between title and blue square

            // Blue Square
            Container(
              width: MediaQuery.of(context).size.width * 0.8,  // 80% of screen width
              height: MediaQuery.of(context).size.height * 0.5,  // 50% of screen height
              decoration: BoxDecoration(
                color: const Color(0xFF246EE9),  // Blue color
                borderRadius: BorderRadius.circular(20.0),  // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),  // Shadow color
                    offset: Offset(0, 4),  // Shadow position
                    blurRadius: 10,  // Shadow blur
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Wiro AI',  // Text inside the blue square
                  style: TextStyle(
                    fontSize: 32.0,  // Text size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  // Text color
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),  // Spacer between blue square and button

            // Start Button
            GestureDetector(
              onTap: () => _handleStartTap(context),  // Call _handleStartTap method when tapped
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,  // 80% of screen width
                height: 60,  // Fixed height for the button
                decoration: BoxDecoration(
                  color: Colors.white,  // Button background color
                  border: Border.all(
                    color: Colors.black,  // Border color
                    width: 2,  // Border width
                  ),
                  borderRadius: BorderRadius.circular(30),  // Rounded corners
                ),
                child: const Center(
                  child: Text(
                    'Start with the music!',  // Button text
                    style: TextStyle(
                      fontSize: 18,  // Font size of the text
                      fontWeight: FontWeight.bold,  // Font weight of the text
                      color: Colors.black,  // Text color
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle the start button tap
  void _handleStartTap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? answers = prefs.getStringList('answers');
    bool isSetupComplete = prefs.getBool('setupComplete') ?? false;

    if (answers != null && answers.length == 4) {
      if (isSetupComplete) {
        // Show alert dialog indicating setup is complete
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Setup Complete'),
              content: Text('You are all set up!'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Navigate to SetupTimelineScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => setup_timeline.SetupTimelineScreen()),
        );
      }
    } else {
      // Navigate to InitialStageScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => initial_stage.InitialStageScreen()),
      );
    }
  }
}

// Main function
void main() {
  runApp(MaterialApp(
    home: IntroScreen(),
  ));
}
