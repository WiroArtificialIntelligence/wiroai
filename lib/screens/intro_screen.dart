import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
      child: Column(          
        children: [
            Padding(padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.3), // Margin from left by 30% of screen width)
          child: _buildBlueSquare(context)), // Display the blue square
            const SizedBox(height: 50), // Spacer between blue square and button
            Center(child: _startButton(context)), // Center the button horizontally
          ],
          )
        ),
    );
  }

  // Function to create the blue square container
  Widget _buildBlueSquare(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
      height: MediaQuery.of(context).size.height * 0.65, // 65% of screen height
      color: const Color(0xFF246EE9), // Color #246EE9
    );
  }

  // Function to create the start button
  Widget _startButton(BuildContext context) {
    return GestureDetector(
      onTap: _handleStartTap, // Call _handleStartTap method when tapped
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
        height: 60, // Fixed height for the button
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Border color
            width: 2, // Border width
          ),
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: const Center(
          child: Text(
            'Start with the music!', // Button text
            style: TextStyle(
              fontSize: 18, // Font size of the text
              fontWeight: FontWeight.bold, // Font weight of the text
            ),
          ),
        ),
      ),
    );
  }

  // Method to handle tap on the start button
  void _handleStartTap() {
    // Add functionality here for when the button is tapped
    if (kDebugMode) {
      print('Start button tapped');
    }
    // Example: Navigate to another screen or perform some action
  }
}
