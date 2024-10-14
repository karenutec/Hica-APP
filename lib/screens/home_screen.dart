import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tratamiento_service.dart';
import '../models/tratamiento.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final veterinario = authProvider.veterinario;
    final TratamientoService tratamientoService = TratamientoService(authProvider);

    Future<void> _refreshTratamientos() async {
      // Forzar una reconstrucción del widget
      await Future.delayed(Duration.zero);
    }

    Future<void> _showAutorizationDialog(BuildContext context, Tratamiento tratamiento) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // El usuario debe tocar un botón para cerrar el diálogo
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Autorización de Tratamiento'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('¿Qué acción desea tomar para el siguiente tratamiento?'),
                  SizedBox(height: 10),
                  Text('Medicación: ${tratamiento.medicacion}'),
                  Text('Fecha: ${tratamiento.fecha}'),
                  Text('Hora: ${tratamiento.hora}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Rechazar'),
                onPressed: () {
                  // Aquí iría la lógica para rechazar el tratamiento
                  // Por ejemplo: tratamientoService.rechazarTratamiento(tratamiento.id);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Autorizar'),
                onPressed: () {
                  // Aquí iría la lógica para autorizar el tratamiento
                  // Por ejemplo: tratamientoService.autorizarTratamiento(tratamiento.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // Implementar funcionalidad de notificaciones
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTratamientos,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2A9D8F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.pets, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activo',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Karen Etchepare',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(
                    'Pendientes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // Implementar funcionalidad de pendientes
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1D3557)),
                ),
                ElevatedButton(
                  child: Text(
                    'Historial',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // Implementar funcionalidad de historial
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A9D8F)),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Tratamiento>>(
                future: veterinario != null
                    ? tratamientoService.getTratamientosByVeterinarioId(veterinario.id)
                    : Future.value([]),
                builder: (context, snapshot) {
                  if (veterinario == null) {
                    return Center(child: Text('No hay información de veterinario disponible', style: TextStyle(color: Colors.white)));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No hay tratamientos disponibles', style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final tratamiento = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: InkWell(
                            onTap: () => _showAutorizationDialog(context, tratamiento),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.medical_services, color: Color(0xFF2A9D8F), size: 24),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tratamiento.medicacion,
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text('Fecha: ${tratamiento.fecha}'),
                                        Text('Hora: ${tratamiento.hora}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}