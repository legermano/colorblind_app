import 'dart:developer';
import 'dart:io';

import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/utils/opencv/color_detector_async.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  // Key
  GlobalKey previewKey = GlobalKey();

  // Controllers
  CameraLensDirection _lensDirection = CameraLensDirection.back;
  CameraController? _cameraController;

  // Color
  Color backgroundColor = Color(0xFF1C1C1C);

  // Utils classes
  late ColorDetectorAsync _colorDetector;

  // State variables
  int _cameraFrameRotation = 0;
  int _lastRun = 0;
  double _cameraFrameToScreenScale = 0;
  bool _detectionInProgress = false;

  FlashMode _flashMode = FlashMode.off;
  CameraImage? _currentImage;

  // Color picker variables
  String? _selectedColor;
  bool _colorPickerInProgress = false;
  double? pX;
  double? pY;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _colorDetector = ColorDetectorAsync();
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.pausePreview();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _colorDetector.destroy();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    int index = cameras.indexWhere((c) => c.lensDirection == _lensDirection);
    CameraDescription? cameraDescription = (index >= 0) ? cameras[index] : null;

    if (cameraDescription == null) {
      return;
    }
    _cameraFrameRotation =
        Platform.isAndroid ? cameraDescription.sensorOrientation : 0;
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.yuv420
          : ImageFormatGroup.bgra8888,
    );
    _cameraController!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    try {
      await _cameraController!.initialize();
      await _cameraController!.startImageStream((image) {
        setState(() {
          _currentImage = image;
        });
      });
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image, int pointX, int pointY) async {
    if (_detectionInProgress ||
        !mounted ||
        DateTime.now().millisecondsSinceEpoch - _lastRun < 30) {
      return;
    }

    // calc the scale factor to convert from camera frame coords to screen coords.
    // NOTE!!!! We assume camera frame takes the entire screen width, if that's not the case
    // (like if camera is landscape or the camera frame is limited to some area) then you will
    // have to find the correct scale factor somehow else
    if (_cameraFrameToScreenScale == 0) {
      var w = (_cameraFrameRotation == 0 || _cameraFrameRotation == 180)
          ? image.width
          : image.height;
      _cameraFrameToScreenScale = MediaQuery.of(context).size.width / w;
    }

    // Call the detector
    _detectionInProgress = true;
    String? color = await _colorDetector.getColor(
        image, _cameraFrameRotation, pointX, pointY);
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;

    // Make sure we are still mounted, the background thread can return a response after we navigate away from this
    // screen but before bg thread is killed
    if (!mounted || color == null || color.isEmpty) {
      return;
    }

    setState(() {
      _selectedColor = color;
    });
  }

  void toogleColorPicker() {
    setState(() {
      _colorPickerInProgress = !_colorPickerInProgress;

      if (!_colorPickerInProgress) {
        _selectedColor = null;
        pX = null;
        pY = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_cameraController == null) {
      return const Center(
        child: Text('Carregando...'),
      );
    }

    return Stack(
      children: [
        _buildCameraPreview(context),
        _buildTopControllers(),
        _buildBottomControllers(context),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          CameraPreview(
            key: previewKey,
            _cameraController!,
            child: Stack(
              children: [
                if (pX != null && pY != null) _buildCircle(),
                _buildGestureDector(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle() {
    return CustomPaint(
      size: Size(5, 5),
      painter: CustomCirle(px: pX!, py: pY!),
    );
  }

  Widget _buildGestureDector(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        if (!_colorPickerInProgress) {
          return;
        }

        setState(() {
          pX = details.localPosition.dx;
          pY = details.localPosition.dy;
        });

        // Since the application is only render on portrait mode, we need to shift the width and height on the preview image
        double scale = previewKey.currentContext!.size!.width /
            _cameraController!.value.previewSize!.height;

        int px = details.localPosition.dx ~/ scale;
        int py = details.localPosition.dy ~/ scale;

        _processCameraImage(_currentImage!, px, py);
      },
    );
  }

  Widget _buildTopControllers() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            icon: Icon(
              _flashMode == FlashMode.torch ? Icons.flash_off : Icons.flash_on,
              color: AppColors.white,
              size: 26,
            ),
            onPressed: () {
              setState(() {
                _flashMode = (_flashMode == FlashMode.torch)
                    ? FlashMode.off
                    : FlashMode.torch;
              });

              _cameraController!.setFlashMode(_flashMode);
            },
          ),
          CircleAvatar(
            backgroundColor: _colorPickerInProgress
                ? backgroundColor.withOpacity(0.9)
                : Colors.transparent,
            child: IconButton(
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.colorize_rounded,
                color: AppColors.white,
                size: 26,
              ),
              onPressed: () => toogleColorPicker(),
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.close,
              color: AppColors.white,
              size: 26,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControllers(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 8,
      child: Column(
        children: [
          if (_colorPickerInProgress) _buildSelectedColorCard(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: backgroundColor.withOpacity(0.8),
                child: IconButton(
                  icon: Icon(Icons.flip_camera_android, color: AppColors.white),
                  onPressed: () {},
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 5),
                  ),
                  padding: EdgeInsets.all(2.5),
                  child: CircleAvatar(backgroundColor: AppColors.white),
                ),
              ),
              CircleAvatar(
                radius: 21,
                backgroundColor: backgroundColor.withOpacity(0.8),
                child: IconButton(
                  icon: Icon(Icons.flip_camera_android, color: AppColors.white),
                  onPressed: () {
                    setState(() {
                      _lensDirection =
                          (_lensDirection == CameraLensDirection.back)
                              ? CameraLensDirection.front
                              : CameraLensDirection.back;
                      initCamera();
                    });
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedColorCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Card(
        margin: EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Text(
            "${_selectedColor ?? 'Clique em alguma parte da tela para verificar a cor'}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCirle extends CustomPainter {
  final double px;
  final double py;

  CustomCirle({super.repaint, required this.px, required this.py});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the circle's radius
    double radius = 5;

    // Create a Paint object for styling the circle
    Paint paintBlack = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Paint paintWhite = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw the circle at the specified center
    canvas.drawCircle(Offset(this.px, this.py), radius, paintBlack);
    canvas.drawCircle(Offset(this.px, this.py), radius, paintWhite);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
