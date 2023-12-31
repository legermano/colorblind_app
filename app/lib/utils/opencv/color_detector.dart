import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:native_opencv/native_opencv.dart';

// This class will be used as argument to the init method, since we cant access the bundled assets
// from an Isolate we must get the marker png from the main thread
class InitRequest {
  SendPort toMainThread;
  InitRequest({required this.toMainThread});
}

// this is the class that the main thread will send here asking to invoke a function on ArucoDetector
class Request {
  // a correlation id so the main thread will be able to match response with request
  int reqId;
  String method;
  dynamic params;
  Request({required this.reqId, required this.method, this.params});
}

// this is the class that will be sent as a response to the main thread
class Response {
  int reqId;
  dynamic data;
  Response({required this.reqId, this.data});
}

// This is the port that will be used to send data to main thread
late SendPort _toMainThread;
late _ColorDetector _detector;

void init(InitRequest initReq) {
  // Create ArucoDetector
  _detector = _ColorDetector();

  // Save the port on which we will send messages to the main thread
  _toMainThread = initReq.toMainThread;

  // Create a port on which the main thread can send us messages and listen to it
  ReceivePort fromMainThread = ReceivePort();
  fromMainThread.listen(_handleMessage);

  // Send the main thread the port on which it can send us messages
  _toMainThread.send(fromMainThread.sendPort);
}

void _handleMessage(data) {
  if (data is Request) {
    dynamic res;
    switch (data.method) {
      case 'getColor':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        var pointX = data.params['pointX'];
        var pointY = data.params['pointY'];
        res = _detector.getColor(image, rotation, pointX, pointY);
        break;
      case 'getColorImage':
        var path = data.params['path'];
        var pointX = data.params['pointX'];
        var pointY = data.params['pointY'];
        res = _detector.getColorImage(path, pointX, pointY);
        break;
      case 'correct':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        var protanopiaDegree = data.params['protanopiaDegree'];
        var deutranopiaDegree = data.params['deutranopiaDegree'];
        res = _detector.correct(image, rotation, protanopiaDegree, deutranopiaDegree);
        break;
      case 'correctImage':
        var path = data.params['path'];
        var protanopiaDegree = data.params['protanopiaDegree'];
        var deutranopiaDegree = data.params['deutranopiaDegree'];
        res = _detector.correctImage(path, protanopiaDegree, deutranopiaDegree);
        break;
      case 'simulate':
        var image = data.params['image'] as CameraImage;
        var rotation = data.params['rotation'];
        var type = data.params['type'];
        var degree = data.params['degree'];
        res = _detector.simulate(image, rotation, type, degree);
        break;
      case 'simulateImage':
        var path = data.params['path'];
        var type = data.params['type'];
        var degree = data.params['degree'];
        res = _detector.simulateImage(path, type, degree);
        break;
      case 'destroy':
        _detector.destroy();
        break;
      default:
        log('Unknown method: ${data.method}');
    }

    _toMainThread.send(Response(reqId: data.reqId, data: res));
  }
}

class _ColorDetector {
  NativeOpencv? _nativeOpencv;

  _ColorDetector() {
    init();
  }

  init() async {
    // init the detector
    _nativeOpencv = NativeOpencv();
  }

  String? getColor(CameraImage image, int rotation, int pointX, int pointY) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    // On Android the image format is YUV and we get a buffer per channel,
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    // the entire image
    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;

    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }

    return _nativeOpencv!.getColor(
      image.width,
      image.height,
      rotation,
      pointX,
      pointY,
      yBuffer,
      uBuffer,
      vBuffer,
    );
  }

  String? getColorImage(String path, int pointX, int pointY) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    return _nativeOpencv!.getColorImage(
      path,
      pointX,
      pointY,
    );
  }

  Uint8List? correct(CameraImage image, int rotation, double protanopiaDegree, double deutranopiaDegree) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    // On Android the image format is YUV and we get a buffer per channel,
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    // the entire image
    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;

    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }

    return _nativeOpencv!.correct(
      image.width,
      image.height,
      rotation,
      protanopiaDegree,
      deutranopiaDegree,
      yBuffer,
      uBuffer,
      vBuffer,
    );
  }

  Uint8List? correctImage(String path, double protanopiaDegree, double deutranopiaDegree) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    return _nativeOpencv!.correctImage(
      path,
      protanopiaDegree,
      deutranopiaDegree,
    );
  }

  Uint8List? simulate(CameraImage image, int rotation, String type, double degree) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    // On Android the image format is YUV and we get a buffer per channel,
    // in iOS the format is BGRA and we get a single buffer for all channels.
    // So the yBuffer variable on Android will be just the Y channel but on iOS it will be
    // the entire image
    var planes = image.planes;
    var yBuffer = planes[0].bytes;

    Uint8List? uBuffer;
    Uint8List? vBuffer;

    if (Platform.isAndroid) {
      uBuffer = planes[1].bytes;
      vBuffer = planes[2].bytes;
    }

    return _nativeOpencv!.simulate(
      image.width,
      image.height,
      rotation,
      type,
      degree,
      yBuffer,
      uBuffer,
      vBuffer,
    );
  }

  Uint8List? simulateImage(String path, String type, double degree) {
    // make sure we have a detector
    if (_nativeOpencv == null) {
      return null;
    }

    return _nativeOpencv!.simulateImage(
      path,
      type,
      degree
    );
  }

  destroy() {
    if (_nativeOpencv != null) {
      _nativeOpencv!.destroy();
      _nativeOpencv = null;
    }
  }
}
