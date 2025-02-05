import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class TFLiteService {
  late Interpreter faceInterpreter;
  late Interpreter emotionInterpreter;

  Future<void> loadModels() async {
    final faceModelData = await rootBundle.load("models/face_detection_full_range_sparse.tflite");
    final emotionModelData = await rootBundle.load("models/model.tflite");

    // Convert ByteData to Uint8List
    Uint8List faceModelBytes = faceModelData.buffer.asUint8List();
    Uint8List emotionModelBytes = emotionModelData.buffer.asUint8List();

    // Load models using Interpreter.fromBuffer()
    faceInterpreter = await Interpreter.fromBuffer(faceModelBytes);
    emotionInterpreter = await Interpreter.fromBuffer(emotionModelBytes);
  }

  List<Map<String, dynamic>> detectFaces(img.Image frame) {
    var inputShape = faceInterpreter.getInputTensor(0).shape;
    var resizedFrame = img.copyResize(frame, width: inputShape[1], height: inputShape[2]);
    var input = List.generate(1, (_) => resizedFrame.getBytes().map((e) => e / 255.0).toList());

    List<List<double>> output = List.generate(1, (_) => List.filled(4, 0.0));
    faceInterpreter.run(input, output);

    return output.map((detection) {
      return {"x": detection[0], "y": detection[1], "width": detection[2], "height": detection[3]};
    }).toList();
  }

  String classifyEmotion(img.Image faceCrop) {
    var inputShape = emotionInterpreter.getInputTensor(0).shape;
    var resizedFace = img.copyResize(faceCrop, width: inputShape[1], height: inputShape[2]);
    var input = List.generate(1, (_) => resizedFace.getBytes().map((e) => e / 255.0).toList());

    List<List<double>> output = List.generate(1, (_) => List.filled(5, 0.0));
    emotionInterpreter.run(input, output);

    List<String> emotions = ["Happy", "Neutral", "Sad", "Surprised", "Angry"];
    return emotions[output[0].indexWhere((e) => e == output[0].reduce((a, b) => a > b ? a : b))];
  }
}
