import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../services/student_service.dart';
import '../config/theme.dart';
import '../config/api_config.dart';

class StudentFormScreen extends StatefulWidget {
  final dynamic student; // null = Add, មាន = Edit

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  String _gender = 'M';
  int? _cohortId;
  int? _entryYearId;
  String _status = 'active';
  File? _photoFile;
  bool _saving = false;

  bool get isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final s = widget.student;
      _codeCtrl.text = s.studentCode ?? '';
      _nameCtrl.text = s.fullName ?? '';
      _gender = s.gender ?? 'M';
      _cohortId = s.cohortId;
      _entryYearId = s.entryYearId;
      _status = s.status ?? 'active';
      _dobCtrl.text = s.dob ?? '';
      _phoneCtrl.text = s.phone ?? '';
      _emailCtrl.text = s.email ?? '';
      _addressCtrl.text = s.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? '✏️ កែសិស្ស' : '➕ បន្ថែមសិស្ស'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ==================== PHOTO ====================
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      // ✅ Photo Avatar
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: AppTheme.primaryLight,
                        child: ClipOval(
                          child: _buildPhotoContent(),
                        ),
                      ),

                      // ✅ Camera Icon (Upload)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppTheme.primary,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ✅ ប៊ូតុង Delete Photo
                  if (isEdit &&
                      widget.student.photo != null &&
                      _photoFile == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton.icon(
                        onPressed: _deletePhoto,
                        icon: const Icon(
                          Icons.delete,
                          color: AppTheme.danger,
                          size: 18,
                        ),
                        label: const Text(
                          'លុបរូបថត',
                          style: TextStyle(color: AppTheme.danger),
                        ),
                      ),
                    ),

                  // ✅ បើករើសរូបថតថ្មី — បង្ហាញប៊ូតុង Cancel
                  if (_photoFile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton.icon(
                        onPressed: () => setState(() => _photoFile = null),
                        icon: const Icon(
                          Icons.cancel,
                          color: AppTheme.warning,
                          size: 18,
                        ),
                        label: const Text(
                          'បោះបង់រូបថតថ្មី',
                          style: TextStyle(color: AppTheme.warning),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==================== STUDENT CODE ====================
            TextFormField(
              controller: _codeCtrl,
              enabled: !isEdit,
              decoration: const InputDecoration(
                labelText: 'លេខកូដ *',
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (v) => v?.isEmpty == true ? 'សូមបំពេញ' : null,
            ),
            const SizedBox(height: 16),

            // ==================== FULL NAME ====================
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'ឈ្មោះ *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) => v?.isEmpty == true ? 'សូមបំពេញ' : null,
            ),
            const SizedBox(height: 16),

            // ==================== GENDER ====================
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'ភេទ *',
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'M', child: Text('👨 ប្រុស')),
                DropdownMenuItem(value: 'F', child: Text('👩 ស្រី')),
              ],
              onChanged: (v) => setState(() => _gender = v ?? 'M'),
            ),
            const SizedBox(height: 16),

            // ==================== COHORT ====================
            DropdownButtonFormField<int>(
              value: _cohortId,
              decoration: const InputDecoration(
                labelText: 'ជំនាន់',
                prefixIcon: Icon(Icons.school),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('-- មិនជ្រើស --'),
                ),
                ...app.cohorts.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.cohortName}${c.isCurrent ? " ⭐" : ""}'),
                  );
                }),
              ],
              onChanged: (v) => setState(() => _cohortId = v),
            ),
            const SizedBox(height: 16),

            // ==================== ENTRY YEAR ====================
            DropdownButtonFormField<int>(
              value: _entryYearId,
              decoration: const InputDecoration(
                labelText: 'ឆ្នាំចូលរៀន',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text('-- មិនជ្រើស --'),
                ),
                ...app.years.map((y) {
                  return DropdownMenuItem(
                    value: y.id,
                    child: Text(y.yearName),
                  );
                }),
              ],
              onChanged: (v) => setState(() => _entryYearId = v),
            ),
            const SizedBox(height: 16),

            // ==================== STATUS ====================
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'ស្ថានភាព',
                prefixIcon: Icon(Icons.info),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('🟢 កំពុងរៀន')),
                DropdownMenuItem(value: 'graduated', child: Text('🎓 បញ្ចប់')),
                DropdownMenuItem(value: 'dropped', child: Text('🔴 ឈប់')),
              ],
              onChanged: (v) => setState(() => _status = v ?? 'active'),
            ),
            const SizedBox(height: 16),

            // ==================== PHONE ====================
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'ទូរស័ព្ទ',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),

            // ==================== EMAIL ====================
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'អ៊ីមែល',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            // ==================== ADDRESS ====================
            TextFormField(
              controller: _addressCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'អាសយដ្ឋាន',
                prefixIcon: Icon(Icons.location_on),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 32),

            // ==================== SAVE BUTTON ====================
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_saving ? 'កំពុងរក្សាទុក...' : '💾 រក្សាទុក'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ✅ PHOTO CONTENT — Logic សម្រាប់បង្ហាញរូបថត
  // ============================================================
  Widget _buildPhotoContent() {
    // ១. បើរើសរូបថតថ្មី (ក្នុង Form) — បង្ហាញរូបថតថ្មី
    if (_photoFile != null) {
      return Image.file(
        _photoFile!,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      );
    }

    // ២. បើ Edit + មានរូបថតក្នុង DB — បង្ហាញរូបថតចាស់
    if (isEdit && widget.student.photo != null) {
      final photoUrl = '${ApiConfig.uploadUrl}/${widget.student.photo}';
      return CachedNetworkImage(
        imageUrl: photoUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
        // ✅ Placeholder ពេលកំពុង Load
        placeholder: (context, url) => Container(
          color: AppTheme.primaryLight,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        // ✅ Error Widget ពេល Load បរាជ័យ
        errorWidget: (context, url, error) => Container(
          color: AppTheme.primaryLight,
          child: Center(
            child: Text(
              _gender == 'M' ? '👨' : '👩',
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ),
      );
    }

    // ៣. បើគ្មានរូបថត — បង្ហាញ Emoji
    return Center(
      child: Text(
        _gender == 'M' ? '👨' : '👩',
        style: const TextStyle(fontSize: 50),
      ),
    );
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _photoFile = File(picked.path));
    }
  }

  // ============================================================
  // DELETE PHOTO
  // ============================================================
  Future<void> _deletePhoto() async {
    final ok = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('លុបរូបថត?'),
            content: const Text('តើអ្នកចង់លុបរូបថតនេះមែនទេ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('បោះបង់'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.danger,
                ),
                child: const Text('លុប'),
              ),
            ],
          ),
        ) ??
        false;

    if (!ok) return;

    final success = await StudentService.deletePhoto(widget.student.id);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ លុបរូបថតជោគជ័យ'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ លុបបរាជ័យ'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  // ============================================================
  // SAVE
  // ============================================================
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final data = <String, dynamic>{
        'student_code': _codeCtrl.text.trim(),
        'full_name': _nameCtrl.text.trim(),
        'gender': _gender,
        'cohort_id': _cohortId,
        'entry_year_id': _entryYearId,
        'status': _status,
        'dob': _dobCtrl.text.trim().isEmpty ? null : _dobCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
      };

      bool ok = false;

      if (isEdit) {
        // ✅ EDIT — Update ធម្មតា
        data['id'] = widget.student.id;
        ok = await StudentService.update(data);

        // ✅ បើមានរូបថតថ្មី → Upload ដោយឡែក
        if (ok && _photoFile != null) {
          await StudentService.uploadPhoto(
            studentId: widget.student.id,
            photo: _photoFile!,
          );
        }
      } else {
        // ✅ ADD ថ្មី — បើមានរូបថត → Upload ព្រមគ្នា
        if (_photoFile != null) {
          ok = await StudentService.createWithPhoto(
            data: data,
            photo: _photoFile,
          );
        } else {
          ok = await StudentService.create(data);
        }
      }

      if (ok) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? '✅ កែជោគជ័យ' : '✅ បន្ថែមជោគជ័យ'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context, true);
      } else {
        _showError('បរាជ័យ');
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _nameCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }
}