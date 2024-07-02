import 'package:flutter/material.dart';
import 'package:wiroai/screens/intro_screen.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      void _goBack(){
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IntroScreen()),
    );
  }
    return Scaffold(
      backgroundColor: Colors.white,  // White background color

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered Text
            Text(
              'Please Wait...',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.0),  // Space between text and loader

            // Circular Loader
            SizedBox(
              width: 60.0,
              height: 60.0,
              child: CircularProgressIndicator(
                strokeWidth: 6.0,  // Size of the spinner
                color: Color(0xFF246EE9),  // Color of the spinner
              ),
            ),
            SizedBox(height: 20.0),  // Space between loader and subtitle

            // Subtitle Text
            Text(
              'We are setting things up for you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],  // Gray color
              ),
            ),
          ],
        ),
      ),
      // Back Button
      floatingActionButton: FloatingActionButton(
        onPressed: _goBack,
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,  // White color for the arrow icon
        ),
        tooltip: 'Back to Intro Screen',
        backgroundColor: Color(0xFF246EE9),  // Color of the back button
      ),
    );
  }

}
