import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:ichack_backend_client/ichack_backend_client.dart';
import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart'
    as cloud_speech;
import 'package:google_speech/google_speech.dart';
import 'package:ichack_backend_client/ichack_backend_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'tflite_service.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
// import 'utils/ai_responses.dart';

typedef _Fn = void Function();

const int cstSAMPLERATE = 16000;
const int cstCHANNELNB = 2;
const Codec cstCODEC = Codec.pcm16;

var client = Client('http://localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: const Color.fromARGB(255, 182, 67, 67),
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        colorScheme: colorScheme,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.shadow,
          foregroundColor: colorScheme.inverseSurface,
        ),
      ),
      home: ConvoScreen(), // Set ConvoScreen as the home screen
    );
  }
}

class ConvoScreen extends StatefulWidget {
  @override
  _ConvoScreenState createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> {
  String _liveResponse = '';
  String _entireResponse = '';
  bool _isRecording = false;
  bool _showingLLMResponse = false; // New state for LLM feedback

  // State for Sidebar toggle
  bool _isDrawerOpen = false;

  // Create a GlobalKey for ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _displayLLMResponse(String response) {
    setState(() {
      _isRecording = false;
      _showingLLMResponse = true;
      _liveResponse = response;
    });
  }

  // lol start
  // lmao start
  late CameraController _controller;
  // late TFLiteService _tfliteService;
  Timer? _frameCaptureTimer;
  List<String> _emotions = [];
  // lmao end

  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';

  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;

  StreamController<Uint8List>? recordingDataController;

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _mRecorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    //sampleRate = await _mRecorder!.getSampleRate();

    setState(() {
      _mRecorderIsInited = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _openRecorder();
    //lmao start
    _initializeCamera();
    // _tfliteService = TFLiteService();
    // _tfliteService.loadModels();
    // lmao end
  }

  // lmao start
  void _initializeCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.medium);
    await _controller.initialize();
    if (!mounted) return;

    _frameCaptureTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _captureAndSendFrame();
    });

    setState(() {});
  }

  Future<void> _captureAndSendFrame() async {
    if (!_controller.value.isInitialized) return;

    try {
      XFile imageFile = await _controller.takePicture();
      print("picture taken");
      List<int> imageBytes = await imageFile.readAsBytes();
      final String base64String = base64Encode(imageBytes);
      // print(base64String);
      final payload = jsonEncode({'image': base64String});
      final url = Uri.parse('http://35.177.93.9/analyze');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );
      print('Response: ${response.body}');
      // _sendInfoToBackend(response.body, text);
      // img.Image frame = img.decodeImage(Uint8List.fromList(imageBytes))!;

      // Run Face Detection
      // List<Map<String, dynamic>> faces = _tfliteService.detectFaces(frame);

      // Run Emotion Classification
      // List<String> faceResults = [];
      // for (var face in faces) {
      //   int x = face["x"];
      //   int y = face["y"];
      //   int w = face["width"];
      //   int h = face["height"];
      //   img.Image faceCrop =
      //       img.copyCrop(frame, x: x, y: y, width: w, height: h);
      //   String emotion = _tfliteService.classifyEmotion(faceCrop);
      //   faceResults.add(emotion);
      // }

      // Send results to Serverpod backend
      // await client.processVid.processVideo(faceResults);

      // setState(() {
      //   _emotions = faceResults;
      // });
    } catch (e) {
      print("Error capturing frame: $e");
      
    }
  }
  // lmao end

  // void _sendTextToBackend(responseBody, String textToSend) async {
  //   try {
  //     final response = await client.text.processTranscription(responseBody, textToSend);
  //     print('Backend Response: $response');
  //   } catch (e) {
  //     print('Error sending text to backend: $e');
  //   }
  // }

  @override
  void dispose() {
    stopRecorder();
    _mRecorder!.closeRecorder();
    _mRecorder = null;

    // lmao start
    _controller.dispose();
    _frameCaptureTimer?.cancel();
    // lmao end

    super.dispose();
  }

  // ----------------------  Here is the code to record to a Stream ------------

  Future<void> record() async {
    assert(_mRecorderIsInited);
    recordingDataController?.close(); // Close previous instance if exists
    recordingDataController = StreamController<Uint8List>();
    await _mRecorder!.startRecorder(
      toStream: recordingDataController!.sink,
      codec: cstCODEC,
      numChannels: cstCHANNELNB,
      sampleRate: cstSAMPLERATE,
      bufferSize: 8192,
    );
    setState(() {});
  }
  // --------------------- (it was very simple, wasn't it ?) -------------------

  Future<void> stopRecorder() async {
    await _mRecorder!.stopRecorder();
  }

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped
        ? startRecordingAndRecognize
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }

  void streamingRecognizeMic() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/ichack-2025-cf1182265dcf.json')));
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        recordingDataController!.stream);



    // final audio = await _getAudioContent('threevoices.wav');
    // print("got content");
    // await speechToText.recognize(config, audio).then((value) {
    //   setState(() {
    //     text = value.results
    //         .map((e) => e.alternatives.first.transcript)
    //         .join('\n');
    //     value.results.last.alternatives.first.words
    //         .forEach((e) => print(e.word + ' ' + e.speakerTag.toString()));
    //   });
    // }).whenComplete(() => setState(() {
    //       recognizeFinished = true;
    //       recognizing = false;
    //     }));

    

    responseStream.listen((data) {

      setState(() {
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');

        // for (var e in data.results) {
        //   for (var w in e.alternatives.first.words) {
        //     print('${w.word} ${w.speakerTag}');
        //   }
        // }

        recognizeFinished = true;
      });
    }, onDone: () {
      print("START TEXT;;;;");
      print(text);
      print("END TEXT;;;");
      setState(() {
        recognizing = false;
      });
    });
  }

  // Future<List<int>> _getAudioContent(String name) async {
  //   print("hi");
  //   final directory = await getApplicationDocumentsDirectory();
  //   print("hi2");
  //   print("directory.path:" + directory.path);
  //   final path = directory.path + '/$name';
  //   if (!File(path).existsSync()) {
  //     await _copyFileFromAssets(name);
  //   }
  //   return File(path).readAsBytesSync().toList();
  // }

  // Future<void> _copyFileFromAssets(String name) async {
  //   var data = await rootBundle.load('assets/$name');
  //   final directory = await getApplicationDocumentsDirectory();
  //   final path = directory.path + '/$name';
  //   await File(path).writeAsBytes(
  //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  // }
  void startRecordingAndRecognize() async {
    await record(); // Start recording first
    Future.delayed(const Duration(milliseconds: 500), () {
      // Small delay to start stream
      streamingRecognizeMic();
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      // model: RecognitionModel.basic,
      model: RecognitionModel.video,
      useEnhanced: true,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 48000,
      diarizationConfig: _getSpeakerDiarizationConfig(),
      languageCode: 'en-US');

  cloud_speech.SpeakerDiarizationConfig _getSpeakerDiarizationConfig() =>
      cloud_speech.SpeakerDiarizationConfig(
        enableSpeakerDiarization: true,
        minSpeakerCount: 4,
        maxSpeakerCount: 4,
      );
  //lol end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Conversation'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleDrawer,
        ),
      ),
      drawer: ChatHistorySidebar(),
      body: Column(
        children: [
          InteractionContainer(
            isRecording: _isRecording,
            showingLLMResponse: _showingLLMResponse,
            responseText: _liveResponse,
            onAcceptResponse: () {
              setState(() {
                _showingLLMResponse = false; // Reset to default state
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: RecordButton(
              isRecording: _isRecording,
              onToggle: _toggleRecording,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      if (!_mRecorderIsInited) {
        return null;
      }
      if (_isRecording) {
        // Stopping Recording
        _isRecording = false;
        stopRecorder().then((value) => setState(() {}));
        _showingLLMResponse = false; // Reset LLM response state
      } else {
        // Start Recording
        _isRecording = true;
        startRecordingAndRecognize();
      }
    });
  }

  // Toggle the drawer state using the GlobalKey
  void _toggleDrawer() {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.closeDrawer();
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}

class ChatHistorySidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(0), bottomRight: Radius.circular(0)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 124.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chat History',
                    style: TextStyle(
                      color: colorScheme.surfaceDim,
                      fontSize: 24,
                    ),
                  ),
                  Icon(Icons.chat, color: colorScheme.surfaceDim)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text('Chat 1',
                style: TextStyle(color: colorScheme.onSurfaceVariant)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatName: 'Chat 1'),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              'Chat 2',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatName: 'Chat 2'),
                ),
              );
            },
          ),
          // Add more ListTile widgets as needed
        ],
      ),
    );
  }
}

class InteractionContainer extends StatelessWidget {
  final bool isRecording;
  final bool showingLLMResponse;
  final String responseText;
  final VoidCallback onAcceptResponse;

  InteractionContainer({
    required this.isRecording,
    required this.showingLLMResponse,
    required this.responseText,
    required this.onAcceptResponse,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Center(
        child: showingLLMResponse
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: 300,
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Feedback",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          responseText,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: onAcceptResponse,
                          child: Text("Okay"),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : isRecording
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeedbackButton(
                          header: "Encouragement",
                          body: "",
                          delayMilliseconds: 100,
                          iconImage: Icons.favorite,
                          constructive: false,
                          encouraging: true,
                          wellRounded: false,),
                      SizedBox(height: 24),
                      FeedbackButton(
                          header: "Construction",
                          body: "",
                          delayMilliseconds: 200,
                          iconImage: Icons.star,
                          encouraging: false,
                          wellRounded: false,
                          constructive: true,),
                      SizedBox(height: 24),
                      FeedbackButton(
                          header: "Well-rounded feedback",
                          body: "",
                          delayMilliseconds: 300,
                          iconImage: Icons.assignment,
                          encouraging: false,
                          constructive: false,
                          wellRounded: true,
                          ),
                    ],
                  )
                : Text(
                    'Press the mic to start a conversation!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
      ),
    );
  }
}

class FeedbackButton extends StatefulWidget {
  final String header;
  final String body;
  final int delayMilliseconds;
  final IconData iconImage;
  final bool encouraging;
  final bool constructive;
  final bool wellRounded;

  FeedbackButton({
    required this.header,
    required this.body,
    required this.delayMilliseconds,
    required this.iconImage,
    required this.encouraging,
    required this.constructive, 
    required this.wellRounded
  });

  @override
  _FeedbackButtonState createState() => _FeedbackButtonState();
}

class _FeedbackButtonState extends State<FeedbackButton> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.delayMilliseconds), () {
      if (mounted) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant FeedbackButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!context.findAncestorStateOfType<_ConvoScreenState>()!._isRecording) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  Future<String> someShit() async{
      final plswork = await client.text.generateReply(encouraging: widget.encouraging, constructive: widget.constructive, wellRounded: widget.wellRounded);
      return plswork;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final convoState = context.findAncestorStateOfType<_ConvoScreenState>();

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: Duration(milliseconds: 500),
        offset: _isVisible ? Offset.zero : Offset(0, 0.2),
        curve: Curves.easeOut,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            String llm_response = await someShit();
            convoState?._displayLLMResponse(llm_response);
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: colorScheme.tertiaryContainer,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              width: 300,
              height: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.header,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.tertiary,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Icon(
                        widget.iconImage,
                        color: colorScheme.tertiary,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.body,
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.tertiary,
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RecordButton extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onToggle;

  RecordButton({required this.isRecording, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0), // Add padding around the button
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Smooth transition effect
        decoration: ShapeDecoration(
          color: isRecording ? colorScheme.onTertiary : colorScheme.tertiary,
          shape: CircleBorder(),
          shadows: [
            BoxShadow(
              color: colorScheme.onInverseSurface, // Shadow color
              spreadRadius:
                  isRecording ? 15 : 0, // Increase spread when recording
              blurRadius: 0, // Blur effect for the shadow
              offset: Offset(0, 0), // Shadow offset
            ),
          ],
        ),
        child: Ink(
          decoration: ShapeDecoration(
            color: isRecording
                ? colorScheme.onTertiary
                : colorScheme.tertiary, // Toggle between colors
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              isRecording ? Icons.stop : Icons.mic,
              size: 36,
              color: isRecording
                  ? colorScheme.tertiary
                  : colorScheme.onTertiary, // Icon size inside the button
            ),
            onPressed: onToggle,
            padding: EdgeInsets.all(20),
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String chatName;

  ChatPage({required this.chatName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Simulate receiving a message after 2 seconds
    Timer(Duration(seconds: 2), () => _receiveMessage("Hello! How are you?"));
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _addMessage(text: text, isMe: true);

    // Simulate a reply from the other person after 1-3 seconds
    Timer(Duration(seconds: 1 + (DateTime.now().millisecondsSinceEpoch % 3)),
        () {
      _receiveMessage("I received: $text");
    });
  }

  void _receiveMessage(String text) {
    _addMessage(text: text, isMe: false);
  }

  void _addMessage({required String text, required bool isMe}) {
    ChatMessage message = ChatMessage(
      text: text,
      isMe: isMe,
      timestamp: DateTime(2025, 1, 1, 1, 1, 1, 1, 1),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                CircleAvatar(
                  backgroundColor: colorScheme.onTertiary,
                  child: Text("Joe",
                      style: TextStyle(color: colorScheme.onSurfaceVariant)),
                ),
              Container(
                margin: EdgeInsets.only(left: 16.0, right: 16.0),
                padding: EdgeInsets.all(10.0),
                constraints: BoxConstraints(maxWidth: 200),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(text),
              ),
              if (isMe)
                CircleAvatar(
                  child: Text('Me',
                      style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  backgroundColor: colorScheme.onTertiaryFixedVariant,
                ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hours = timestamp.hour.toString().padLeft(2, '0');
    final minutes = timestamp.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
}
