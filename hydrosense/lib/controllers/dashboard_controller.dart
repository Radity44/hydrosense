import '../services/firebase_service.dart';
import '../models/monitoring_log.dart';

class DashboardController {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<List<MonitoringLog>> getMonitoringLogs() {
    return _firebaseService.getHydroSenseStream().map((event) {
      final rawData = event.snapshot.value;
      if (rawData == null) return [];

      final Map<dynamic, dynamic> logsMap = Map<dynamic, dynamic>.from(rawData as Map);
      
      return logsMap.entries.map((e) {
        return MonitoringLog.fromMap(e.key.toString(), Map<dynamic, dynamic>.from(e.value as Map));
      }).toList();
    });
  }
}
