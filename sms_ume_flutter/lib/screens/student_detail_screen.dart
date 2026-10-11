import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/student.dart';
import '../services/student_service.dart';
import '../config/theme.dart';
import '../config/api_config.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    try {
      final data = await StudentService.history(widget.student.id);
      setState(() => _history = List<Map<String, dynamic>>.from(data));
    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;

    return Scaffold(
      appBar: AppBar(title: Text(s.fullName)),
      body: ListView(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary, const Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: s.photo != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: '${ApiConfig.uploadUrl}/${s.photo}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Text(
                              s.gender == 'M' ? '👨' : '👩',
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        )
                      : Text(
                          s.gender == 'M' ? '👨' : '👩',
                          style: const TextStyle(fontSize: 50),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  s.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '📌 ${s.studentCode}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Column(
                children: [
                  _infoTile(Icons.person, 'ភេទ', s.genderLabel),
                  _infoTile(Icons.school, 'ជំនាន់', s.cohortName ?? '-'),
                  _infoTile(Icons.phone, 'ទូរស័ព្ទ', s.phone ?? '-'),
                  _infoTile(Icons.email, 'អ៊ីមែល', s.email ?? '-'),
                  _infoTile(Icons.location_on, 'អាសយដ្ឋាន', s.address ?? '-'),
                  _infoTile(Icons.info, 'ស្ថានភាព', s.statusLabel),
                ],
              ),
            ),
          ),

          // History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📚 ប្រវត្តិមុខវិជ្ជា',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_loading)
                      const Center(child: CircularProgressIndicator())
                    else if (_history.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('មិនមានប្រវត្តិ'),
                        ),
                      )
                    else
                      ..._history.map((h) => _historyTile(h)),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(label, style: const TextStyle(fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }

  Widget _historyTile(Map<String, dynamic> h) {
    final status = h['status'] ?? 'active';
    Color color;
    switch (status) {
      case 'completed':
        color = AppTheme.success;
        break;
      case 'dropped':
        color = AppTheme.danger;
        break;
      default:
        color = AppTheme.info;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${h['subject_code']} — ${h['subject_name']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ពិន្ទុ: ${h['total_score'] ?? "-"} · និទ្ទេស: ${h['grade'] ?? "-"}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}