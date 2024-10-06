import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'face_capture_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.signIn(_email, _password);
      
      if (success) {
        // Navegar a la pantalla de captura de rostro
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FaceCaptureScreen()),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo iniciar sesión. Verifica tus credenciales.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                SvgPicture.asset(
                  'assets/logo.svg',
                  width: 150,
                  height: 150,
                ), // Reemplaza con tu logo
                SizedBox(height: 50),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Por favor ingrese su email' : null,
                            onSaved: (value) => _email = value!,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                value!.isEmpty ? 'Por favor ingrese su contraseña' : null,
                            onSaved: (value) => _password = value!,
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              child: Text('Iniciar Sesión', style: TextStyle(fontSize: 18)),
                            ),
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
