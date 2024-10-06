import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class FaceCaptureScreen extends StatefulWidget {
  @override
  _FaceCaptureScreenState createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _capturedImage;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0; // Para rastrear qué cámara está seleccionada

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      // Inicializa con la cámara frontal si está disponible
      selectedCameraIndex = cameras!.indexWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front
      );
      if (selectedCameraIndex == -1) selectedCameraIndex = 0; // Si no hay frontal, usa la primera

      _controller = CameraController(
        cameras![selectedCameraIndex],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleCamera() async {
    if (cameras == null || cameras!.length < 2) return;

    selectedCameraIndex = (selectedCameraIndex + 1) % cameras!.length;
    CameraDescription selectedCamera = cameras![selectedCameraIndex];

    await _controller?.dispose();

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = File(image.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imagen capturada con éxito')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al capturar la imagen')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Captura de Imagen')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: _capturedImage == null
                      ? (_controller != null
                          ? CameraPreview(_controller!)
                          : Center(child: Text('Cámara no inicializada')))
                      : Image.file(_capturedImage!),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(_capturedImage == null ? 'Capturar' : 'Capturar de nuevo'),
                        onPressed: _captureImage,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                      ElevatedButton(
                        child: Icon(Icons.flip_camera_ios),
                        onPressed: _toggleCamera,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}