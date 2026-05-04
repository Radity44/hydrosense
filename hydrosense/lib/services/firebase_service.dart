import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // Inisialisasi langsung supaya tidak null
  // Di file services/firebase_service.dart
  // Tambah .child('monitoring') di ujung ref()
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child(
    'Monitoring',
  );
  Stream<DatabaseEvent> getHydroSenseStream() {
    return _dbRef.onValue;
  }
}
