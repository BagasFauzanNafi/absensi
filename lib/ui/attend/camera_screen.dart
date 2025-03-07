import 'dart:io';

import 'package:attandence_tracker/ui/attend/attend_screen.dart';
import 'package:attandence_tracker/ui/components/custom_snackbar.dart';
import 'package:attandence_tracker/utils/google_mlkit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // Initialize Face Detector
  FaceDetector faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
    ),
  );

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![1], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {});
      });
    } else {
      customSnackbar(
        context,
        Icons.camera,
        'No camera available',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Screen Size
    Size size = MediaQuery.of(context).size;

    // Show Loader Dialog
    showLoaderDialog(BuildContext context) {
      AlertDialog alert = const AlertDialog(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange),
            ),
            SizedBox(width: 10),
            Text('Checking Data'),
          ],
        ),
      );
      showDialog(
        context: context,
        builder: (context) {
          return alert;
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Capture a selfie image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: controller == null
                ? const Center(
                    child: Text(
                      'Ups, Camera Error!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : !controller!.value.isInitialized
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CameraPreview(controller!),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Lottie.asset(
              'assets/raw/face_id_ring.json',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              height: 200,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Make sure you are in a well-lit area so your face is clearly visible',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ClipOval(
                      child: Material(
                        color: Colors.deepOrange,
                        child: InkWell(
                          splashColor: Colors.blue,
                          onTap: () async {
                            final hasPermission =
                                await handleLocationPermission();
                            try {
                              if (controller != null) {
                                if (controller!.value.isInitialized) {
                                  controller!.setFlashMode(FlashMode.off);
                                  image = await controller!.takePicture();
                                  setState(() {
                                    if (hasPermission) {
                                      showLoaderDialog(context);
                                      final inputImage =
                                          InputImage.fromFilePath(image!.path);
                                      Platform.isAndroid
                                          ? processImage(inputImage)
                                          : Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AttendScreen(image: image),
                                              ),
                                            );
                                    } else {
                                      customSnackbar(
                                        context,
                                        Icons.location_on_outlined,
                                        'Please enable location permission',
                                      );
                                    }
                                  });
                                }
                              }
                            } catch (e) {
                              customSnackbar(
                                context,
                                Icons.error_outline,
                                'Ups, $e',
                              );
                            }
                          },
                          child: const SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      customSnackbar(
        context,
        Icons.location_off,
        'Location service is disabled. Please enable the location service',
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        customSnackbar(
          context,
          Icons.location_off,
          'Location permission denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      customSnackbar(
        context,
        Icons.location_off,
        'Location permission denied forever, we can\'t request permission.',
      );
      return false;
    }
    return true;
  }

  // Image processing
  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.pop(context, true);
        if (faces.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AttendScreen(image: image),
            ),
          );
        } else {
          customSnackbar(
            context,
            Icons.error,
            'Ups, make sure your face is clearly visible',
          );
        }
      });
    }
  }
}
