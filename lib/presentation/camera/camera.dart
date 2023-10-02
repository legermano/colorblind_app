import 'dart:developer';
import 'dart:io';

import 'package:boilerplate/constants/colors.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  Color backgroundColor = Color(0xFF1C1C1C);
  FlashMode _flashMode = FlashMode.off;
  CameraLensDirection _lensDirection = CameraLensDirection.back;
  CameraController? _cameraController;
  int _cameraFrameRotation = 0;
  double _cameraFrameToScreenScale = 0;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
      cameraController.dispose();
      setState(() {
        _showPreview = false;
      });
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      // await _cameraController!
      //     .startImageStream((image) => _processCameraImage(image));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {
        _showPreview = true;
      });
    }
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
        // _buildTopControllers(),
        // _buildBottomControllers(context),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return _showPreview
        ? ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(children: [
              CameraPreview(
                _cameraController!,
                child: _buildGestureDector(),
              ),
              _buildTopControllers(),
              _buildBottomControllers(context),
            ]),
          )
        : Container();
  }

  Widget _buildGestureDector() {
    return GestureDetector(
      onTapDown: (details) {
        print("onTapDown (x,y): ${details.localPosition.dx}, ${details.localPosition.dy}" );
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
          IconButton(
            splashColor: Colors.transparent,
            icon: Icon(
              Icons.colorize_rounded,
              color: AppColors.white,
              size: 26,
            ),
            onPressed: () {},
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
      child: Row(
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
                  _lensDirection = (_lensDirection == CameraLensDirection.back)
                      ? CameraLensDirection.front
                      : CameraLensDirection.back;
                  initCamera();
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
