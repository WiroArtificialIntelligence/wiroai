import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'questionaire_stage_screen.dart';  
import 'package:wiroai/utils/time_utils.dart';

class SetupTimelineScreen extends StatefulWidget {
  const SetupTimelineScreen({super.key});

  @override
  _SetupTimelineScreenState createState() => _SetupTimelineScreenState();
}

class _SetupTimelineScreenState extends State<SetupTimelineScreen> {
  final List<String> _timeslots = [
    '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM', '07:00 PM',
    '08:00 PM', '09:00 PM', '10:00 PM', '11:00 PM',
  ];

  final List<String> _labels = [
    "Happy Morning",
    "Good Afternoon",
    "Nice Evening",
    "Music Arrival Time"
  ];

  final List<String> _selectedTimeslots = List.filled(4, '');

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _selectedTimeslots[i] = _timeslots[0]; 
    }
  }

  void _saveSetupComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    
    prefs.setString('morning', _selectedTimeslots[0]);
    prefs.setString('afternoon', _selectedTimeslots[1]);
    prefs.setString('evening', _selectedTimeslots[2]);
    prefs.setString('music', _selectedTimeslots[3]);
    
    prefs.setBool('setupComplete', true);
  }

    bool _validateTimeslots() {
    for (int i = 1; i < _selectedTimeslots.length; i++) {
      if (TimeUtils.compareTimes(_selectedTimeslots[i - 1], _selectedTimeslots[i])) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_labels[i]} must be later than ${_labels[i - 1]}')),
        );
        return false;
      }
    }
    _onCompleteSetup();
    return true;
  }

  void _onCompleteSetup() {
    _saveSetupComplete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setup completed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 75),
            const QuestionText(),
            const SizedBox(height: 20),
            TimeslotSetup(
              timeslots: _timeslots,
              labels: _labels,
              selectedTimeslots: _selectedTimeslots,
              onTimeslotChanged: (index, newValue) {
                setState(() {
                  _selectedTimeslots[index] = newValue;
                });
              },
            ),
            const InstructionText(),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            StartMusicButton(
              onPressed: () {
                if( _validateTimeslots())
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuestionaireStageScreen()),  // Navigate to QuestionaireStageScreen
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionText extends StatelessWidget {
  const QuestionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Please set up the timeline for the following events:',
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}

class TimeslotSetup extends StatelessWidget {
  final List<String> timeslots;
  final List<String> labels;
  final List<String> selectedTimeslots;
  final Function(int, String) onTimeslotChanged;

  const TimeslotSetup({
    Key? key,
    required this.timeslots,
    required this.labels,
    required this.selectedTimeslots,
    required this.onTimeslotChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(4, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                labels[index],
                style: TextStyle(fontSize: 18.0),
              ),
              DropdownButton<String>(
                value: selectedTimeslots[index],
                onChanged: (String? newValue) {
                  onTimeslotChanged(index, newValue!);
                },
                items: timeslots.map<DropdownMenuItem<String>>((String timeslot) {
                  return DropdownMenuItem<String>(
                    value: timeslot,
                    child: Text(timeslot),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class InstructionText extends StatelessWidget {
  const InstructionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "This setup is for alert purpose to schedule your answering time for music generation! Feel Free to schedule your answer time and music gift time!",
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.grey,
      ),
    );
  }
}

class StartMusicButton extends StatelessWidget {
  final VoidCallback onPressed;

  const StartMusicButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.black,
      ),
      onPressed: onPressed,
      child: const Text('Start our music'),
    );
  }
}
