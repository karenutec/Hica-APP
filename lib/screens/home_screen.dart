import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tratamiento_service.dart';
import '../models/tratamiento.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Iniciando construcción de HomeScreen');
    final authProvider = Provider.of<AuthProvider>(context);
    final veterinario = authProvider.veterinario;
    final TratamientoService tratamientoService = TratamientoService(authProvider);

    print('Veterinario: ${veterinario?.id}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              print('Iniciando proceso de cierre de sesión');
              authProvider.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (veterinario != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos del Veterinario'),
                    Text('N° de Registro: ${veterinario.nDeRegistro}'),
                    Text('Dependencia: ${veterinario.dependencia}'),
                    Text('Validado: ${veterinario.validado ? 'Sí' : 'No'}'),
                    Text('ID: ${veterinario.id}'),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Tratamientos'),
              ),
              FutureBuilder<List<Tratamiento>>(
                future: tratamientoService.getTratamientosByVeterinarioId(veterinario.id),
                builder: (context, snapshot) {
                  print('Estado de la conexión: ${snapshot.connectionState}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error al cargar tratamientos: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    print('No se encontraron tratamientos');
                    return Center(child: Text('No hay tratamientos disponibles'));
                  } else {
                    print('Número de tratamientos cargados: ${snapshot.data!.length}');
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final tratamiento = snapshot.data![index];
                        print('Construyendo tratamiento: ${tratamiento.id}');
                        return ListTile(
                          title: Text('Fecha: ${tratamiento.fecha} - Hora: ${tratamiento.hora}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Medicación: ${tratamiento.medicacion}'),
                              Text('Observaciones: ${tratamiento.observaciones}'),
                              Text('Estado: ${tratamiento.estadoAutorizacion}'),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}