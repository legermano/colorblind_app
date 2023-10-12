import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:boilerplate/utils/opencv/color_detector.dart' as color_detector;

class ColorDetectorAsync {
  bool arThreadReady = false;
  late Isolate _detectorThread;
  late SendPort _toDetectorThread;
  int _reqId = 0;
  final Map<int, Completer> _cbs = {};

  ColorDetectorAsync() {
    _initDetectionThread();
  }

  void _initDetectionThread() async {
    // Create the port on which the detector thread will send us messages and listen to it.
    ReceivePort fromDetectorThread = ReceivePort();
    fromDetectorThread.listen(_handleMessage, onDone: () {
      arThreadReady = false;
    });

    // Spawn a new Isolate using the ArucoDetector.init method as entry point and
    // the port on which it can send us messages as parameter
    final initReq = color_detector.InitRequest(toMainThread: fromDetectorThread.sendPort);
    _detectorThread = await Isolate.spawn(color_detector.init, initReq);
  }

  Future<String?> getColor(CameraImage image, int rotation, int pointX, int pointY) {
    if (!arThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_reqId;
    var res = Completer<String?>();
    _cbs[reqId] = res;
    var msg = color_detector.Request(
      reqId: reqId,
      method: 'getColor',
      params: {'image': image, 'rotation': rotation, 'pointX': pointX, 'pointY': pointY},
    );

    _toDetectorThread.send(msg);
    return res.future;
  }

  Future<Uint8List?> correct(CameraImage image, int rotation, double protanopiaDegree, double deutranopiaDegree) {
    if (!arThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_reqId;
    var res = Completer<Uint8List?>();
    _cbs[reqId] = res;
    var msg = color_detector.Request(
      reqId: reqId,
      method: 'correct',
      params: {
        'image': image,
        'rotation': rotation,
        'protanopiaDegree': protanopiaDegree,
        'deutranopiaDegree': deutranopiaDegree,
      },
    );

    _toDetectorThread.send(msg);
    return res.future;
  }

  void destroy() async {
    if (!arThreadReady) {
      return;
    }

    arThreadReady = false;

    // We send a Destroy request and wait for a response before killing the thread
    var reqId = ++_reqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = color_detector.Request(reqId: reqId, method: 'destroy');
    _toDetectorThread.send(msg);

    // Wait for the detector to acknoledge the destory and kill the thread
    await res.future;
    _detectorThread.kill();
  }

  void _handleMessage(data) {
    // The detector thread send us its SendPort on init, if we got it this meand the detector is ready
    if (data is SendPort) {
      _toDetectorThread = data;
      arThreadReady = true;
      return;
    }

    // Make sure we got a Response object
    if (data is color_detector.Response) {
      // Find the Completer associated with this request and resolve it
      var reqId = data.reqId;
      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }

    log('Unknown message from ArucoDetector, got: $data');
  }
}