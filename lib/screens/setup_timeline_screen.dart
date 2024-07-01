import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'waiting_screen.dart';  // Import the WaitingScreen

class SetupTimelineScreen extends StatefulWidget {
  const SetupTimelineScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      _selectedTimeslots[i] = _timeslots[0]; // Default value
    }
  }

  void _saveSetupComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Convert the list of selected timeslots and labels to a Map
    Map<String, String> timeslotMap = {};
    for (int i = 0; i < _labels.length; i++) {
      timeslotMap[_labels[i]] = _selectedTimeslots[i];
    }
    
    // Store the Map as a JSON string in SharedPreferences
    prefs.setString('timeslotMap', timeslotMap.toString());
    prefs.setBool('setupComplete', true);
  }

  void _validateTimeslots() {
    for (int i = 1; i < _selectedTimeslots.length; i++) {
      if (_compareTimes(_selectedTimeslots[i - 1], _selectedTimeslots[i])) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_labels[i]} must be later than ${_labels[i - 1]}')),
        );
        return;
      }
    }
    _onCompleteSetup();
  }

  bool _compareTimes(String time1, String time2) {
    return _convertToMinutes(time1) >= _convertToMinutes(time2);
  }

  int _convertToMinutes(String time) {
    final timeFormat = DateFormat('hh:mm a');
    final parsedTime = timeFormat.parse(time);
    return parsedTime.hour * 60 + parsedTime.minute;
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
            // Question text at the top
            const SizedBox(height: 75), 
            const Text(
              'Please set up the timeline for the following events:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),  // Add space between the question and the slots
            Column(
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 40.0), // Increased gap between rows
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _labels[index],
                        style: TextStyle(fontSize: 18.0),
                      ),
                      DropdownButton<String>(
                        value: _selectedTimeslots[index],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTimeslots[index] = newValue!;
                            if (index < 3) {
                              _validateTimeslots();  // Validate timeslots whenever a selection is changed
                            }
                          });
                        },
                        items: _timeslots.map<DropdownMenuItem<String>>((String timeslot) {
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
            ),
            const Text(
              "This setup is for alert purpose to schedule your answering time for music generation! Feel Free to schedule your answer time and music gift time!",
              style: TextStyle(
                fontSize: 15.0,  // Smaller text size
                color: Colors.grey,  // Gray color
              ),
            ),
            SizedBox(height: 20),
            Divider(
              color: Colors.grey,
            ),
            // Add space between the paragraph and the floating action button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFF246EE9), // foreground
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingScreen()),  // Navigate to WaitingScreen
                );
              },
              child: const Text('Start our music'),
            ),
          ],
        ),
      ),
    );
  }
}
