import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../models/monitoring_log.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardController _controller = DashboardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: SafeArea(
        child: StreamBuilder<List<MonitoringLog>>(
          stream: _controller.getMonitoringLogs(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final allLogs = snapshot.data;
            if (allLogs == null || allLogs.isEmpty) {
              return const Center(child: Text("Data Kosong"));
            }

            // Hitung ringkasan status
            int normalCount = allLogs.where((log) => log.isNormal).length;
            int warnCount = allLogs.where((log) => !log.isNormal).length;

            return Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),

                // Summary Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          count: normalCount,
                          label: 'Normal',
                          color: const Color(0xFF1E5C3A),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildSummaryCard(
                          count: warnCount,
                          label: 'Perlu Perhatian',
                          color: const Color(0xFFE53E3E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                _buildSectionTitle(),
                const SizedBox(height: 12),

                // List Perangkat (Meja)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: allLogs.length,
                    itemBuilder: (context, index) {
                      final log = allLogs[index];
                      return _buildMejaCard({
                        'nama': log.nama,
                        'status': log.isNormal ? "NORMAL" : "PERLU PERHATIAN",
                        'isNormal': log.isNormal,
                        'ph': log.ph,
                        'nutrisi': log.nutrisi,
                        'volume': log.volume,
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo Admin 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  'Berikut Kondisi Kebun Anda!!!',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMejaCard(Map<String, dynamic> meja) {
    final bool isNormal = meja['isNormal'];
    final Color statusColor = isNormal
        ? const Color(0xFF1E5C3A)
        : const Color(0xFFE53E3E);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                meja['nama'],
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  meja['status'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildParamRow(
            icon: Icons.water_drop_outlined,
            label: 'pH Air',
            value: '${meja['ph']}',
          ),
          _buildParamRow(
            icon: Icons.science_outlined,
            label: 'Nutrisi',
            value: '${meja['nutrisi']} PPM',
          ),
          _buildParamRow(
            icon: Icons.water_outlined,
            label: 'Volume',
            value: '${meja['volume']}%',
            showDivider: false,
          ),
          const SizedBox(height: 14),
          _buildDetailButton(),
        ],
      ),
    );
  }

  Widget _buildParamRow({
    required IconData icon,
    required String label,
    required String value,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF1E5C3A)),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(color: Colors.grey[200], thickness: 1, height: 0),
      ],
    );
  }

  Widget _buildDetailButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              'Lihat Detail',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.chevron_right,
              size: 18,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSectionTitle() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: const [
        Icon(Icons.layers_outlined, color: Color(0xFF1E5C3A), size: 18),
        SizedBox(width: 8),
        Text(
          'Status Real-Time Meja',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    ),
  );

}
