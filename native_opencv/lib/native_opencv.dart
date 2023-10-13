// Load our C lib
import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_opencv.so")
    : DynamicLibrary.process();

// C Function signatures
typedef _CVersion = Pointer<Utf8> Function();
typedef _CGetColor = Pointer<Utf8> Function(
  Int32 width,
  Int32 height,
  Int32 rotation,
  Int32 pointX,
  Int32 pointY,
  Pointer<Uint8> bytes,
  Bool isYUV,
);

typedef _CCorrect = Void Function(
  Int32 width,
  Int32 height,
  Int32 rotation,
  Float protanopiaDegree,
  Float deutranopiaDegree,
  Pointer<Uint8> bytes,
  Bool isYUV,
  Pointer<Uint8> encondedData,
  Pointer<Int32> outCount
);

typedef _CSimulate = Void Function(
  Int32 width,
  Int32 height,
  Int32 rotation,
  Pointer<Utf8> type,
  Float degree,
  Pointer<Uint8> bytes,
  Bool isYUV,
  Pointer<Uint8> encondedData,
  Pointer<Int32> outCount
);

// Dart functions signatures
typedef _DartVersion = Pointer<Utf8> Function();
typedef _DartGetColor = Pointer<Utf8> Function(
  int width,
  int height,
  int rotation,
  int pointX,
  int pointY,
  Pointer<Uint8> bytes,
  bool isYUV,
);

typedef _DartCorrect = void Function(
  int width,
  int height,
  int rotation,
  double protanopiaDegree,
  double deutranopiaDegree,
  Pointer<Uint8> bytes,
  bool isYUV,
  Pointer<Uint8> encondedData,
  Pointer<Int32> outCount
);

typedef _DartSimulate = void Function(
  int width,
  int height,
  int rotation,
  Pointer<Utf8> type,
  double degree,
  Pointer<Uint8> bytes,
  bool isYUV,
  Pointer<Uint8> encondedData,
  Pointer<Int32> outCount
);

// Create dart functions that invoke the C function
final _version = nativeLib.lookupFunction<_CVersion, _DartVersion>('version');
final _getColor =
    nativeLib.lookupFunction<_CGetColor, _DartGetColor>('getColor');
final _correct = nativeLib.lookupFunction<_CCorrect, _DartCorrect>('correct');
final _simulate = nativeLib.lookupFunction<_CSimulate, _DartSimulate>('simulate');

class NativeOpencv {
  Pointer<Uint8>? _imageBuffer;

  static const MethodChannel _channel = MethodChannel('native_opencv');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  String cvVersion() {
    return _version().toDartString();
  }

  void destroy() {
    if (_imageBuffer != null) {
      malloc.free(_imageBuffer!);
    }
  }

  String getColor(
    int width,
    int height,
    int rotation,
    int pointX,
    int pointY,
    Uint8List yBuffer,
    Uint8List? uBuffer,
    Uint8List? vBuffer,
  ) {
    var ySize = yBuffer.lengthInBytes;
    var uSize = uBuffer?.lengthInBytes ?? 0;
    var vSize = vBuffer?.lengthInBytes ?? 0;
    var totalSize = ySize + uSize + vSize;

    _imageBuffer ??= malloc.allocate<Uint8>(totalSize);

    // We always have at least 1 plane, on Android it si the yPlane on iOS its the rgba plane
    Uint8List bytes = _imageBuffer!.asTypedList(totalSize);
    bytes.setAll(0, yBuffer);

    if (Platform.isAndroid) {
      // Swap u&v buffer for opencv
      bytes.setAll(ySize, vBuffer!);
      bytes.setAll(ySize + vSize, uBuffer!);
    }

    Pointer<Utf8> color = _getColor(
      width,
      height,
      rotation,
      pointX,
      pointY,
      _imageBuffer!,
      Platform.isAndroid ? true : false,
    );

    return color.toDartString();
  }

  Uint8List correct(
    int width,
    int height,
    int rotation,
    double protanopiaDegree,
    double deutranopiaDegree,
    Uint8List yBuffer,
    Uint8List? uBuffer,
    Uint8List? vBuffer,
  ) {
    var ySize = yBuffer.lengthInBytes;
    var uSize = uBuffer?.lengthInBytes ?? 0;
    var vSize = vBuffer?.lengthInBytes ?? 0;
    var totalSize = ySize + uSize + vSize;

    _imageBuffer ??= malloc.allocate<Uint8>(totalSize);

    // We always have at least 1 plane, on Android it si the yPlane on iOS its the rgba plane
    Uint8List bytes = _imageBuffer!.asTypedList(totalSize);
    bytes.setAll(0, yBuffer);

    if (Platform.isAndroid) {
      // Swap u&v buffer for opencv
      bytes.setAll(ySize, vBuffer!);
      bytes.setAll(ySize + vSize, uBuffer!);
    }

    Pointer<Int32> outCount = malloc.allocate<Int32>(1);
    Pointer<Uint8> encodedBytes = malloc.allocate<Uint8>(totalSize);

    _correct(
      width,
      height,
      rotation,
      protanopiaDegree,
      deutranopiaDegree,
      _imageBuffer!,
      Platform.isAndroid ? true : false,
      encodedBytes,
      outCount,
    );

    final count = outCount.value;
    final data = encodedBytes.asTypedList(count);

    malloc.free(outCount);
    malloc.free(encodedBytes);
    return data;
  }

  Uint8List simulate(
    int width,
    int height,
    int rotation,
    String type,
    double degree,
    Uint8List yBuffer,
    Uint8List? uBuffer,
    Uint8List? vBuffer,
  ) {
    var ySize = yBuffer.lengthInBytes;
    var uSize = uBuffer?.lengthInBytes ?? 0;
    var vSize = vBuffer?.lengthInBytes ?? 0;
    var totalSize = ySize + uSize + vSize;

    _imageBuffer ??= malloc.allocate<Uint8>(totalSize);

    // We always have at least 1 plane, on Android it si the yPlane on iOS its the rgba plane
    Uint8List bytes = _imageBuffer!.asTypedList(totalSize);
    bytes.setAll(0, yBuffer);

    if (Platform.isAndroid) {
      // Swap u&v buffer for opencv
      bytes.setAll(ySize, vBuffer!);
      bytes.setAll(ySize + vSize, uBuffer!);
    }

    Pointer<Int32> outCount = malloc.allocate<Int32>(1);
    Pointer<Uint8> encodedBytes = malloc.allocate<Uint8>(totalSize);

    _simulate(
      width,
      height,
      rotation,
      type.toNativeUtf8(),
      degree,
      _imageBuffer!,
      Platform.isAndroid ? true : false,
      encodedBytes,
      outCount,
    );

    final count = outCount.value;
    final data = encodedBytes.asTypedList(count);

    malloc.free(outCount);
    malloc.free(encodedBytes);
    return data;
  }
}
