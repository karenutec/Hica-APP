import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/veterinario_service.dart';
import '../models/veterinario.dart';
import './face_capture_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  late VeterinarioService _veterinarioService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _veterinarioService = VeterinarioService(Provider.of<AuthProvider>(context, listen: false));
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.signIn(_email, _password);
      
      if (success) {
        String? userId = authProvider.userId;
        if (userId != null) {
          try {
            final Veterinario veterinarioDetails = await _veterinarioService.getVeterinarioDetails(userId);
            print('Detalles del veterinario obtenidos: ${veterinarioDetails.toString()}');
            
            authProvider.setVeterinarioDetails(veterinarioDetails);
            
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => FaceCaptureScreen(veterinario: veterinarioDetails),
              ),
            );
          } catch (e) {
            print('Error al obtener detalles del veterinario: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al obtener detalles del veterinario')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo iniciar sesión. Verifica tus credenciales.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Por favor ingrese su email' : null,
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.isEmpty ? 'Por favor ingrese su contraseña' : null,
                    onSaved: (value) => _password = value!,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    child: Text('Iniciar Sesión'),
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}