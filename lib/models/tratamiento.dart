class Tratamiento {
  final String id;
  final DateTime fecha;
  final String hora;
  final String medicacion;
  final String observaciones;
  final String estadoAutorizacion;
  final String fichaClinicaId;
  final String veterinarioId;
  final DateTime createdAt;

  Tratamiento({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.medicacion,
    required this.observaciones,
    required this.estadoAutorizacion,
    required this.fichaClinicaId,
    required this.veterinarioId,
    required this.createdAt,
  });

  factory Tratamiento.fromJson(Map<String, dynamic> json) {
    return Tratamiento(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      hora: json['hora'],
      medicacion: json['medicacion'],
      observaciones: json['observaciones'],
      estadoAutorizacion: json['estadoAutorizacion'],
      fichaClinicaId: json['fichaClinicaId'],
      veterinarioId: json['veterinarioId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}