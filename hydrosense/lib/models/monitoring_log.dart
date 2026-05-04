class MonitoringLog {
  final String id;
  final String deviceId;
  final bool isNormal;
  final String nama;
  final int nutrisi;
  final double ph;
  final int volume;
  final String createdAt;

  MonitoringLog({
    required this.id,
    required this.deviceId,
    required this.isNormal,
    required this.nama,
    required this.nutrisi,
    required this.ph,
    required this.volume,
    required this.createdAt,
  });

  factory MonitoringLog.fromMap(String id, Map<dynamic, dynamic> map) {
    return MonitoringLog(
      id: id,
      deviceId: map['device_id']?.toString() ?? '',
      isNormal: map['isNormal'] ?? true,
      nama: map['nama']?.toString() ?? 'Meja',
      nutrisi: (map['nutrisi'] ?? 0).toInt(),
      ph: (map['ph'] ?? 0.0).toDouble(),
      volume: (map['volume'] ?? 0).toInt(),
      createdAt: map['created_at']?.toString() ?? '',
    );
  }
}
