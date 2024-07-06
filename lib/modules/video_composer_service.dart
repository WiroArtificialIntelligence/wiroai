import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

class VideoComposerService {
  final String imagePath;
  final String audioPath;
  final String outputPath;

  VideoComposerService({
    required this.imagePath,
    required this.audioPath,
    required this.outputPath,
  });

  Future<void> createMp4FromPictureAndMusic() async {
    // Load the image from assets
    final ByteData imageData = await rootBundle.load(imagePath);
    final List<int> imageBytes = imageData.buffer.asUint8List();
    final img.Image image = img.decodeImage(Uint8List.fromList(imageBytes))!;

    // Save the image to a temporary file
    final File imageFile = File('${Directory.systemTemp.path}/temp_image.png');
    imageFile.writeAsBytesSync(img.encodePng(image)!);

    // Load the audio from assets
    final ByteData audioData = await rootBundle.load(audioPath);
    final List<int> audioBytes = audioData.buffer.asUint8List();
    final File audioFile = File('${Directory.systemTemp.path}/temp_music.mp3');
    audioFile.writeAsBytesSync(audioBytes);

    // Define the duration of the video
    const int durationSeconds = 30;

    // Create a blank video with the image and add the audio
    final String ffmpegCommand = 
      '-loop 1 -i ${imageFile.path} -i ${audioFile.path} -c:v libx264 -t ${durationSeconds} -pix_fmt yuv420p -c:a aac -shortest ${outputPath}';

    // Run the FFmpeg command
    await FFmpegKit.execute(ffmpegCommand);

    print('Video created at $outputPath');
  }
}
