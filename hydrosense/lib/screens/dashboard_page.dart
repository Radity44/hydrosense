import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 1; // Dashboard aktif by default

  // Data dummy meja (nanti diganti data dari Firebase)
  final List<Map<String, dynamic>> _mejaList = [
    {
      'nama': 'Meja 1 – Sawi',
      'status': 'NORMAL',
      'isNormal': true,
      'ph': 6.5,
      'nutrisi': 800,
      'volume': 80,
    },
    {
      'nama': 'Meja 2 – Selada',
      'status': 'PERLU PERHATIAN',
      'isNormal': false,
      'ph': 7.8,
      'nutrisi': 650,
      'volume': 72,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final normalCount = _mejaList.where((m) => m['isNormal'] == true).length;
    final warnCount = _mejaList.where((m) => m['isNormal'] == false).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 2),
                        Text(
                          'Berikut Kondisi Kebun Anda!!!',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Icon settings
                  _buildIconBtn(Icons.settings_outlined, onTap: () {}),
                  const SizedBox(width: 10),
                  // Icon logout
                  _buildIconBtn(Icons.logout_outlined, onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Summary cards
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

            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const Icon(Icons.layers_outlined,
                      color: Color(0xFF1E5C3A), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Status Real-Time Meja',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // List meja
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _mejaList.length,
                itemBuilder: (context, index) {
                  return _buildMejaCard(_mejaList[index]);
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildIconBtn(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        ),
        child: Icon(icon, size: 18, color: Colors.grey[600]),
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
              fontFamily: 'Nunito',
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
    final bool isNormal = meja['isNormal'] as bool;
    final Color statusColor =
        isNormal ? const Color(0xFF1E5C3A) : const Color(0xFFE53E3E);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card header
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Parameter rows
          _buildParamRow(
            icon: Icons.water_drop_outlined,
            label: 'pH Air',
            value: '${meja['ph']}',
            isAlert: !isNormal && (meja['ph'] as double) > 7.0,
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

          // Tombol lihat detail
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
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
                    child: Icon(Icons.chevron_right,
                        size: 18, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParamRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAlert = false,
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
                  color: isAlert
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: isAlert
                      ? const Color(0xFFE53E3E)
                      : const Color(0xFF1E5C3A),
                ),
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
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isAlert
                      ? const Color(0xFFE53E3E)
                      : const Color(0xFF1A1A2E),
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

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.grid_view_rounded, 'label': 'Meja'},
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.history_rounded, 'label': 'Riwayat'},
    ];

    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Color(0xFF1E5C3A),
        borderRadius: BorderRadius.vertical(bottom: Radius.zero),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isActive = index == _selectedIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.15)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      items[index]['icon'] as IconData,
                      color: Colors.white
                          .withValues(alpha: isActive ? 1.0 : 0.6),
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    items[index]['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}