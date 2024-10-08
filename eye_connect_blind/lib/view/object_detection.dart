
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImageIdentifierScreen extends StatefulWidget {
  @override
  _ImageIdentifierScreenState createState() => _ImageIdentifierScreenState();
}

class _ImageIdentifierScreenState extends State<ImageIdentifierScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer();
  final gemini = Gemini.instance;
  CameraController? _cameraController;
  File? _imageFile;
  String? _imageLabel;
  String? _imagePurpose;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initTextToSpeech();
  }

  Future<void> _initTextToSpeech() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras.first, ResolutionPreset.high);
    await _cameraController?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureImage() async {
    try {
      final image = await _cameraController?.takePicture();
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
        _identifyImage();
      }
    } catch (e) {
      print('Failed to capture image: $e');
    }
  }

  Future<void> _identifyImage() async {
    try {
      audioPlayer.play(AssetSource('waiting.mp3'));
      final prompt =
          ' Idetify the image and your reply should include a title, a descriptive paragraph in one line';
      final imageBytes = await _imageFile!.readAsBytes();
      final imageResponse =
          await gemini.textAndImage(text: prompt, images: [imageBytes]);
      final responseText = imageResponse?.content?.parts?.last.text;
      audioPlayer.stop();
      speak(responseText!);
      print('Response Text: $responseText');
      final labelRegex = RegExp(r'Label:\s*(.+?)\s*Purpose:');
      final purposeRegex = RegExp(r'Purpose:\s*(.+)');
      final labelMatch = labelRegex.firstMatch(responseText ?? '');
      final purposeMatch = purposeRegex.firstMatch(responseText ?? '');

      setState(() {
        _imageLabel = labelMatch?.group(1)?.trim();
        _imagePurpose = purposeMatch?.group(1)?.trim();
      });

      if (_imageLabel != null && _imagePurpose != null) {
        await speak(_imageLabel!);
        await Future.delayed(Duration(milliseconds: 200));
        await speak(_imagePurpose!);
      }
    } catch (e) {
      print('Failed to identify image: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Identifier'),
      ),
      body: Stack(
  children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container( // Container for 3D effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), // Adjust border radius for desired curve
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect( // ClipRRect to respect border radius
          borderRadius: BorderRadius.circular(20), // Same as container's border radius
          child: _isCameraInitialized
            ? GestureDetector(
                onHorizontalDragEnd: (DragEndDetails details) {
                  speak('Back To Home Page');
                  Navigator.pop(context);
                },
                onDoubleTap: _captureImage,
                child: CameraPreview(_cameraController!),
              )
            : Center(child: CircularProgressIndicator()),
        ),
      ),
    ),
    if (!_isCameraInitialized)
      const Center(
        child: CircularProgressIndicator(),
      ),
  ],
),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageLabel != null)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            //       Text(
            //         'Label:',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       Text(
            //         _imageLabel!,
            //         style: TextStyle(fontSize: 18),
            //       ),
            //     ],
            //   ),
            // SizedBox(height: 8),
            // if (_imagePurpose != null)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Purpose:',
            //         style: TextStyle(fontSize: 18),
            //       ),
            //       Text(
            //         _imagePurpose!,
            //         style: TextStyle(fontSize: 18),
            //       ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}