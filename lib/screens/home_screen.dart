import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final veterinario = authProvider.veterinario; // Asumiendo que has agregado esto al AuthProvider

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authProvider.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (veterinario != null) ...[
              Text('N° de Registro: ${veterinario.nDeRegistro}'),
              Text('Dependencia: ${veterinario.dependencia}'),
              Text('Validado: ${veterinario.validado ? 'Sí' : 'No'}'),
              Text('ID: ${veterinario.id}'),
            ],
          ],
        ),
      ),
    );
  }
}