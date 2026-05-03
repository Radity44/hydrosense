import 'package:flutter_test/flutter_test.dart';
import 'package:hydrosense/main.dart';

void main() {
  testWidgets('SplashScreen tampil dengan benar', (WidgetTester tester) async {
    await tester.pumpWidget(const HydroSenseApp());

    // Cek teks HydroSense muncul di splash
    expect(find.text('HydroSense'), findsOneWidget);

    // Cek tombol Daftar ada
    expect(find.text('Daftar'), findsOneWidget);
  });

  testWidgets('Tombol Daftar navigasi ke LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const HydroSenseApp());

    // Tap tombol Daftar
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    // Cek halaman login muncul
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Lupa password?'), findsOneWidget);
  });

  testWidgets('Tombol Masuk navigasi ke Dashboard tanpa validasi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const HydroSenseApp());

    // Ke halaman login dulu
    await tester.tap(find.text('Daftar'));
    await tester.pumpAndSettle();

    // Tap tombol Masuk langsung (tanpa isi field)
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Cek dashboard muncul
    expect(find.text('Halo Admin 👋'), findsOneWidget);
    expect(find.text('Status Real-Time Meja'), findsOneWidget);
  });
}