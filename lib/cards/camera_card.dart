import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:nows_app/cards/form_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

class CameraViewport extends StatefulWidget {
  final String userLocation;
  final String userId;

  const CameraViewport({super.key, required this.userLocation, required this.userId});

  @override
  State<CameraViewport> createState() => _CameraViewportState();
}

class _CameraViewportState extends State<CameraViewport> with WidgetsBindingObserver {

  CameraController? controller;
  bool _isCameraInitialised = false;
  bool _isTakingPicture = false;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 8.0;
  double _currentZoomLevel = 1.0;

  FlashMode? _currentFlashMode;

  @override
  void initState() {
    onNewCameraSelected(cameras[0]);
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) {
        setState(() {

        });
      }
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        controller!.getMaxZoomLevel()
          .then((value) => _maxAvailableZoom = value);

        controller!.getMinZoomLevel()
          .then((value) => _minAvailableZoom = value);

        _currentFlashMode = controller!.value.flashMode;

        _isCameraInitialised = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 160),
          child: Material(
            color: Colors.black,
            elevation: 10,
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.black,
              ),
              child: _isCameraInitialised ? 
              CameraPreview(
                controller!,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) => onViewFinderTap(details, constraints),
                    );
                  },
                ),
              ) : const Center(
                  child: SpinKitSquareCircle(
                    color: Colors.indigo,
                    size: 30,
                  ),
                ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 690, 20, 90),
          child: _isCameraInitialised ? Material(
            color: Colors.transparent,
            child: Row(
              children: [

                const SizedBox(width: 20),
          
                Expanded(
                  flex: 1,
                  child: Text(
                    '${_currentZoomLevel.toStringAsFixed(1)}x',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
          
                Expanded(
                  flex: 8,
                  child: Slider(
                    label: 'Zoom',
                    value: _currentZoomLevel,
                    min: _minAvailableZoom, 
                    max: _maxAvailableZoom,
                    activeColor: Colors.indigo.shade200,
                    thumbColor: Colors.indigo,
                    onChanged: (value) async {
                      setState(() {
                        _currentZoomLevel = value;
                      });
                      await controller!.setZoomLevel(value);
                    }
                  ),
                ),
          
              ],
            ),
          ): null,
        ),
        

        Positioned(
          bottom: 16,
          child: FloatingActionButton(
            heroTag: 'fabTag',
            onPressed: () async {
              try {
                setState(() => _isTakingPicture = true);

                await controller!.takePicture().then((image) { 
                  File imageFile = File(image.path);
                  print('IMAGE SAVED');

                  Navigator.pushAndRemoveUntil(context, PageRouteBuilder(
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.7),
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: TextForm(
                          imageFile: imageFile, 
                          userLocation: widget.userLocation, 
                          userId: widget.userId,
                        ),
                      );
                    },
                  ), (route) => route.isFirst);
                });

              } on Exception catch (e) {
                print('FAILED TAKING IMAGE: $e');
              }
            },
            child: _isTakingPicture ? 
            const Center(
              child: SpinKitSquareCircle(
                color: Colors.white,
                size: 20,
              ),
            )
            : const Icon(Icons.photo_camera_rounded),
          ),
        ),

        Positioned(
          bottom: 20,
          right: 20,
          child: SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton( 
              heroTag: 'locationTag',
              backgroundColor: Colors.grey.shade700,
              onPressed: () async {
                if (_currentFlashMode == FlashMode.auto) {
                  setState(() => _currentFlashMode = FlashMode.off);
                  await controller!.setFlashMode(FlashMode.off);
                } else if (_currentFlashMode == FlashMode.off) {
                  setState(() => _currentFlashMode = FlashMode.always);
                  await controller!.setFlashMode(FlashMode.always);
                } else if (_currentFlashMode == FlashMode.always) {
                  setState(() => _currentFlashMode = FlashMode.auto);
                  await controller!.setFlashMode(FlashMode.auto);
                }
              },
              child: 
                  _currentFlashMode == FlashMode.auto ? 
                    const Icon(Icons.flash_auto_rounded, color: Colors.white)
                : _currentFlashMode == FlashMode.off ? 
                    Icon(Icons.flash_off_rounded, color: Colors.grey.shade500)
                : _currentFlashMode == FlashMode.always ?
                    const Icon(Icons.flash_on_rounded, color: Colors.white)
                : null
            ),
          ),
        ),

      ],
    ); 
  }
}