import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];  // List to hold chat messages
  final TextEditingController _messageController = TextEditingController();  // Controller for the text input field

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);  // Add the message to the list
      });
      _messageController.clear();  // Clear the text field
      FocusScope.of(context).unfocus();  // Close the keyboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFF246EE9),  // AppBar color
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,  // Start the list from the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFECECEC),  // Message background color
                      borderRadius: BorderRadius.circular(8.0),  // Rounded corners
                    ),
                    child: Text(
                      _messages[index],
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  ),
                ),
                SizedBox(width: 8.0),  // Space between text field and send button
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send, color: Colors.white),  // Send button icon
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF246EE9),  // Send button color
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
