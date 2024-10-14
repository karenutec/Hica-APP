import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/tratamiento_service.dart';
import '../models/tratamiento.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TratamientoService _tratamientoService;

  @override
  void initState() {
    super.initState();
    _tratamientoService = TratamientoService(Provider.of<AuthProvider>(context, listen: false));
  }

  Future<List<Tratamiento>> _loadTratamientos() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final veterinario = authProvider.veterinario;
    if (veterinario != null) {
      return _tratamientoService.getTratamientosByVeterinarioId(veterinario.id);
    }
    return [];
  }

  Future<void> _refreshTratamientos() async {
    setState(() {});
  }

  Widget _buildStatusLabel(String estado) {
    Color color;
    switch (estado.toLowerCase()) {
      case 'pendiente':
        color = Colors.orange;
        break;
      case 'aprobado':
        color = Colors.green;
        break;
      case 'rechazado':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estado,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Future<void> _showAutorizationDialog(BuildContext context, Tratamiento tratamiento) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
              onPressed: () async {
                try {
                  await _tratamientoService.actualizarEstadoTratamiento(tratamiento.id, 'RECHAZADO');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tratamiento rechazado')),
                  );
                  _refreshTratamientos();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al rechazar el tratamiento: $e')),
                  );
                }
              },
            ),
            TextButton(
              child: Text('Autorizar'),
              onPressed: () async {
                try {
                  await _tratamientoService.actualizarEstadoTratamiento(tratamiento.id, 'APROBADO');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tratamiento autorizado')),
                  );
                  _refreshTratamientos();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al autorizar el tratamiento: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

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
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              authProvider.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
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
                          user?.email ?? 'Nombre no disponible',
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
                future: _loadTratamientos(),
                builder: (context, snapshot) {
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
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                tratamiento.medicacion,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            _buildStatusLabel(tratamiento.estadoAutorizacion),
                                          ],
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
