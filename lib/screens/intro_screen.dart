import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiroai/screens/inital_stage_screen.dart' as initial_stage; 
import 'package:wiroai/screens/setup_timeline_screen.dart' as setup_timeline; 
import 'package:wiroai/screens/questionaire_stage_screen.dart' as questionaire_stage; 

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),  
            fit: BoxFit.cover, 
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05, right: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.height * 0.2),  // Horizontal padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            mainAxisAlignment: MainAxisAlignment.start,  
            children: [
            
              const Text(
                'Wiro AI',
                style: TextStyle(
                  fontSize: 60.0,  
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC788A),  
                ),
              ),
              const Text(
                'Best AI',
                style: TextStyle(
                  fontSize: 55.0,  
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              const Text(
                'For Music',
                style: TextStyle(
                  fontSize: 55.0,  
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDC788A), 
                ),
              ),
              const Text(
                'And Life',
                style: TextStyle(
                  fontSize: 55.0, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              const SizedBox(height: 100),  
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _handleStartTap(context), 
                  child: const Text("Let's Start", style: TextStyle(color: Colors.white)),  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8CDAD8),  
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), 
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), 
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStartTap(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? answers = prefs.getStringList('answers');
    bool isSetupComplete = prefs.getBool('setupComplete') ?? false;

    if (answers != null && answers.length == 4) {
      if (isSetupComplete) {
       
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => questionaire_stage.QuestionaireStageScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const setup_timeline.SetupTimelineScreen()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const initial_stage.InitialStageScreen()),
      );
    }
  }
}
void main() {
  runApp(const MaterialApp(
    home: IntroScreen(),
  ));
}
