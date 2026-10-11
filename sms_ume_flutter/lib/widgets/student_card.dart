import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/student.dart';
import '../config/theme.dart';
import '../config/api_config.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: AppTheme.primaryLight,
          child: student.photo != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: '${ApiConfig.uploadUrl}/${student.photo}',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Text(student.gender == 'M' ? '👨' : '👩'),
                  ),
                )
              : Text(
                  student.gender == 'M' ? '👨' : '👩',
                  style: const TextStyle(fontSize: 24),
                ),
        ),
        title: Text(
          student.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('📌 ${student.studentCode}'),
        trailing: _statusBadge(student.status),
        onTap: onTap,
      ),
    );
  }

  Widget _statusBadge(String status) {
    final map = {
      'active': ['កំពុងរៀន', AppTheme.success],
      'graduated': ['បញ្ចប់', AppTheme.info],
      'dropped': ['ឈប់', AppTheme.danger],
    };
    final info = map[status] ?? map['active']!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (info[1] as Color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        info[0] as String,
        style: TextStyle(
          color: info[1] as Color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}