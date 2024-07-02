import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/screens/inital_stage_screen.dart' as initial_stage; // Use alias
import 'package:wiroai/screens/setup_timeline_screen.dart' as setup_timeline; // Use alias
import 'package:wiroai/screens/questionaire_stage_screen.dart' as questionaire_stage; // Import QuestionaireStageScreen with alias

// Intro Screen Definition
class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),  // Set background image
            fit: BoxFit.cover,  // Cover the entire screen
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.2),  // Horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Align content to the left
            mainAxisAlignment: MainAxisAlignment.start,  // Align content to the top
            children: [
              // Title at the top
              const Text(
                'Wiro AI',
                style: TextStyle(
                  fontSize: 60.0,  // Title font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC788A),  // Title color
                ),
              ),
              const Text(
                'Best AI',
                style: TextStyle(
                  fontSize: 55.0,  // Title font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // Title color
                ),
              ),
              const Text(
                'For Music',
                style: TextStyle(
                  fontSize: 55.0,  // Title font size
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC788A),  // Title color
                ),
              ),
              const Text(
                'And Life',
                style: TextStyle(
                  fontSize: 55.0,  // Title font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // Title color
                ),
              ),
              const SizedBox(height: 100),  // Spacer for the button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _handleStartTap(context),  // Call the _handleStartTap method
                  child: const Text("Let's Start", style: TextStyle(color: Colors.white)),  // Start button text color
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CDAD8),  // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),  // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),  // Button padding
                  ),
                ),
              ),
            ],
          ),
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
        // Navigate to QuestionaireStageScreen if setup is complete
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => questionaire_stage.QuestionaireStageScreen()),
        );
      } else {
        // Navigate to SetupTimelineScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const setup_timeline.SetupTimelineScreen()),
        );
      }
    } else {
      // Navigate to InitialStageScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const initial_stage.InitialStageScreen()),
      );
    }
  }
}

// Main function
void main() {
  runApp(const MaterialApp(
    home: IntroScreen(),
  ));
}
