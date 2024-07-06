import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wiroai/modules/video_composer_service.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isVideoShared = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _setPath();
  }

  Future<void> _setPath() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/output.mp3';
  }

  Future<void> _playMusic() async {
    if (_filePath == null) {
      print('File path is null');
      return;
    }
    print("play music from $_filePath");
    try {
      await _audioPlayer.play(DeviceFileSource(_filePath!));
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _shareToTikTok() async {
    if (!_isVideoShared) {
      // Generate and share the video
      final videoComposerService = VideoComposerService(
        imagePath: 'image/wiroAiContent.jpg',
        audioPath: _filePath!,
        outputPath: 'output/video.mp4',
      );
      // await videoComposerService.createAndShareVideoToTikTok();
      // setState(() {
      //   _isVideoShared = true;
      // });
    } else {
      print('Video has already been shared.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Icon(
                Icons.music_note,
                size: 100,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Now Playing: Song Name',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _playMusic,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _shareToTikTok,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              child: Text(
                'Share to TikTok',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
