class Veterinario {
  final int id;
  final int nDeRegistro;
  final bool validado;
  final String? deviceId;
  final String dependencia;
  final String? foto;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Veterinario({
    required this.id,
    required this.nDeRegistro,
    required this.validado,
    this.deviceId,
    required this.dependencia,
    this.foto,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Veterinario.fromJson(Map<String, dynamic> json) {
    return Veterinario(
      id: json['id'],
      nDeRegistro: json['N_de_registro'],
      validado: json['Validado'],
      deviceId: json['deviceId'],
      dependencia: json['Dependencia'],
      foto: json['Foto'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'Veterinario{id: $id, nDeRegistro: $nDeRegistro, validado: $validado, dependencia: $dependencia, userId: $userId}';
  }
}