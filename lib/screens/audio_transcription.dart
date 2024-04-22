import 'package:flutter/material.dart';
import 'package:notility/animations/animation.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:notility/server/chatgpt.dart';

class AudioTranscriber extends StatefulWidget {
  const AudioTranscriber({super.key, required this.title});

  final String title;

  @override
  State<AudioTranscriber> createState() => _AudioTranscriberState();
}

class _AudioTranscriberState extends State<AudioTranscriber> {
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  late OpenAI openAI;
  bool isRecording = false;
  String audioPath = ' ';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
    openAI = OpenAI.instance.build(
        token: token,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 25)),
        enableLog: true);
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void showTranscription() async {
    if (audioPath != ' ') {
      FileInfo infer = FileInfo(audioPath, "myFile.m4a");
      final request = AudioRequest(file: infer);
      final response = await openAI.audio.transcribes(request);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Transcribed",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            content: Text(response.text, style: TextStyle(color: Colors.grey),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Disregard the response
                },
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, response.text); // Disregard the response
                  Navigator.pop(
                      context, response.text); // Disregard the response
                },
                child: const Text("Add to Note", style: TextStyle(color: Colors.redAccent),),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Transcribed"),
            content: const Text("No audio to transcribe."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Disregard the response
                },
                child: const Text("Done"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        var directory = await getApplicationDocumentsDirectory();
        var filePath = '${directory.path}/myFile.m4a';
        print("start path: $filePath");
        await audioRecord.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      print("end path: $path");
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print('Error Stop Recording : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      print("play path: $audioPath");
      DeviceFileSource urlSource = DeviceFileSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error Play Recording : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 48,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          // Pressing the back button
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        leadingWidth: 48, // Size after leading
        titleSpacing: 0, // Size before text
        title: const Text(
          "Audio Transcription",
          style: TextStyle(fontSize: 17, color: Colors.grey),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isRecording)
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RecordingInProgressAnimation(),
              ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[900],
                backgroundColor: Colors.grey[600],
                // onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isRecording
                  ? const Text('Stop Recording')
                  : const Text('Start Recording'),
            ),
            SizedBox(
              height: 25,
            ),
            if (!isRecording && audioPath != ' ')
              ElevatedButton(
                onPressed: playRecording,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey[900],
                  backgroundColor: Colors.grey[600],
                  // onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Play Recording'),
              ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: showTranscription,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[900],
                backgroundColor: Colors.grey[600],
                // onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Transcribe'),
            )
          ],
        ),
      ),
    );
  }
}
