import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../models/veterinario.dart';
import './home_screen.dart';

class FaceCaptureScreen extends StatefulWidget {
  final Veterinario veterinario;

  FaceCaptureScreen({Key? key, required this.veterinario}) : super(key: key);

  @override
  _FaceCaptureScreenState createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
      
      // Aquí deberías implementar la lógica para guardar la imagen
      // Por ejemplo, subirla a un servidor o guardarla localmente
      
      // Simularemos un guardado exitoso después de 2 segundos
      await Future.delayed(Duration(seconds: 2));
      
      // Navegar al HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
      appBar: AppBar(
        title: Text('Captura de Imagen'),
      ),
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
                  child: ElevatedButton(
                    child: Text(_capturedImage == null ? 'Capturar' : 'Guardar y Continuar'),
                    onPressed: _captureImage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ),
                Text('Veterinario: ${widget.veterinario.dependencia}'),
                Text('N° de Registro: ${widget.veterinario.nDeRegistro}'),
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