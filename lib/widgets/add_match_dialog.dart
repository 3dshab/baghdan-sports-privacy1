import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/match_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

class AddMatchDialog extends StatefulWidget {
  const AddMatchDialog({super.key});

  @override
  State<AddMatchDialog> createState() => _AddMatchDialogState();
}

class _AddMatchDialogState extends State<AddMatchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _homeTeamController = TextEditingController();
  final _awayTeamController = TextEditingController();
  final _streamUrlController = TextEditingController();
  final _homeScoreController = TextEditingController();
  final _awayScoreController = TextEditingController();
  final _mainRefereeController = TextEditingController();
  final _firstAssistantController = TextEditingController();
  final _secondAssistantController = TextEditingController();
  final _fourthOfficialController = TextEditingController();
  final _matchSummaryController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedGroup;
  bool _isLive = false;
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();
  List<GroupModel> _groups = [];
  final List<StreamingPlatform> _streamingPlatforms = [];
  final List<String> _commentators = [];
  final List<Goal> _goals = [];

  // متغيرات رفع الملفات
  String? _summaryVideoUrl;
  String? _summaryFileName;
  bool _isUploadingFile = false;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    _firebaseService.getGroups().listen((groups) {
      if (mounted) {
        setState(() {
          _groups = groups;
          if (_groups.isNotEmpty) {
            _selectedGroup = _groups.first.id;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0a4d68),
      title: Text(
        'إضافة مباراة جديدة',
        style: GoogleFonts.cairo(
          color: const Color(0xFF00ff88),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_groups.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedGroup,
                    decoration: InputDecoration(
                      labelText: 'المجموعة',
                      labelStyle: GoogleFonts.cairo(color: Colors.white70),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                    ),
                    dropdownColor: const Color(0xFF051622),
                    style: GoogleFonts.cairo(color: Colors.white),
                    items: _groups.map((group) {
                      return DropdownMenuItem(
                        value: group.id,
                        child: Text(group.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGroup = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء اختيار المجموعة';
                      }
                      return null;
                    },
                  ),
                if (_groups.isEmpty)
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00ff88)),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _homeTeamController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'الفريق الأول',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _awayTeamController,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'الفريق الثاني',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                  validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'التاريخ: ${DateFormat('yyyy/MM/dd').format(_selectedDate)}',
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF00ff88),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2026),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'الوقت: ${_selectedTime.format(context)}',
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.access_time,
                    color: Color(0xFF00ff88),
                  ),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (time != null) {
                      setState(() {
                        _selectedTime = time;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _streamUrlController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.url,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'رابط البث المباشر (اختياري)',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'بث مباشر',
                    style: GoogleFonts.cairo(color: Colors.white),
                  ),
                  value: _isLive,
                  activeThumbColor: const Color(0xFF00ff88),
                  onChanged: (value) {
                    setState(() {
                      _isLive = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _homeScoreController,
                        style: GoogleFonts.cairo(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'نتيجة الأول',
                          labelStyle: GoogleFonts.cairo(color: Colors.white70),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00ff88)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _awayScoreController,
                        style: GoogleFonts.cairo(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'نتيجة الثاني',
                          labelStyle: GoogleFonts.cairo(color: Colors.white70),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white30),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00ff88)),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                _buildStreamingPlatformsSection(),
                const SizedBox(height: 24),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                _buildCommentatorsSection(),
                const SizedBox(height: 24),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                _buildRefereesSection(),
                const SizedBox(height: 24),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                _buildGoalsSection(),
                const SizedBox(height: 24),
                const Divider(color: Colors.white30),
                const SizedBox(height: 16),
                _buildMatchSummarySection(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveMatch,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00ff88),
            foregroundColor: const Color(0xFF051622),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'حفظ',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  // قنوات البث المتعددة
  Widget _buildStreamingPlatformsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'قنوات البث 📺',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF00ff88)),
              onPressed: () => _addStreamingPlatform(),
            ),
          ],
        ),
        if (_streamingPlatforms.isEmpty)
          Text(
            'لا توجد قنوات بث',
            style: GoogleFonts.cairo(color: Colors.white54, fontSize: 14),
          ),
        ..._streamingPlatforms.asMap().entries.map((entry) {
          final index = entry.key;
          final platform = entry.value;
          return Card(
            color: const Color(0xFF051622),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.tv, color: Color(0xFF00ff88)),
              title: Text(
                platform.name,
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              subtitle: Text(
                platform.url,
                style: GoogleFonts.cairo(color: Colors.white54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () =>
                    setState(() => _streamingPlatforms.removeAt(index)),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _addStreamingPlatform() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0a4d68),
        title: Text(
          'إضافة قناة بث',
          style: GoogleFonts.cairo(color: const Color(0xFF00ff88)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: GoogleFonts.cairo(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'اسم القناة (مثل: YouTube)',
                labelStyle: GoogleFonts.cairo(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              style: GoogleFonts.cairo(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'رابط البث',
                labelStyle: GoogleFonts.cairo(color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  urlController.text.isNotEmpty) {
                setState(() {
                  _streamingPlatforms.add(
                    StreamingPlatform(
                      name: nameController.text,
                      url: urlController.text,
                    ),
                  );
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ff88),
            ),
            child: Text('إضافة', style: GoogleFonts.cairo(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // المعلقون
  Widget _buildCommentatorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المعلقون 🎙️',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF00ff88)),
              onPressed: () => _addCommentator(),
            ),
          ],
        ),
        if (_commentators.isEmpty)
          Text(
            'لا يوجد معلقون',
            style: GoogleFonts.cairo(color: Colors.white54, fontSize: 14),
          ),
        ..._commentators.asMap().entries.map((entry) {
          final index = entry.key;
          final commentator = entry.value;
          return Card(
            color: const Color(0xFF051622),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(Icons.mic, color: Color(0xFF00ff88)),
              title: Text(
                commentator,
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _commentators.removeAt(index)),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _addCommentator() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0a4d68),
        title: Text(
          'إضافة معلق',
          style: GoogleFonts.cairo(color: const Color(0xFF00ff88)),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'اسم المعلق',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _commentators.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ff88),
            ),
            child: Text('إضافة', style: GoogleFonts.cairo(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // طاقم التحكيم
  Widget _buildRefereesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طاقم التحكيم 👨‍⚖️',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _mainRefereeController,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'الحكم الرئيسي',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            prefixIcon: const Icon(Icons.person, color: Color(0xFF00ff88)),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00ff88)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _firstAssistantController,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'الحكم المساعد الأول',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFF00ff88),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00ff88)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _secondAssistantController,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'الحكم المساعد الثاني',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFF00ff88),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00ff88)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fourthOfficialController,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'الحكم الرابع',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Color(0xFF00ff88),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white30),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF00ff88)),
            ),
          ),
        ),
      ],
    );
  }

  // الهدافون
  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الهدافون ⚽',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFF00ff88)),
              onPressed: () => _addGoalDialog(),
            ),
          ],
        ),
        if (_goals.isEmpty)
          Text(
            'لا توجد أهداف',
            style: GoogleFonts.cairo(color: Colors.white54, fontSize: 14),
          ),
        ..._goals.asMap().entries.map((entry) {
          final index = entry.key;
          final goal = entry.value;
          final teamName = goal.team == 'home'
              ? _homeTeamController.text
              : _awayTeamController.text;
          return Card(
            color: const Color(0xFF051622),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const Icon(
                Icons.sports_soccer,
                color: Color(0xFF00ff88),
              ),
              title: Text(
                '${goal.playerName} (${teamName.isEmpty ? goal.team : teamName})',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              subtitle: Row(
                children: [
                  Text(
                    'الدقيقة: ${goal.minute}',
                    style: GoogleFonts.cairo(color: Colors.white54),
                  ),
                  if (goal.videoUrl != null) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.video_library,
                      color: Color(0xFF00ff88),
                      size: 16,
                    ),
                  ],
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _goals.removeAt(index)),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ملخص المباراة
  Widget _buildMatchSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملخص المباراة 📝',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _matchSummaryController,
          style: GoogleFonts.cairo(color: Colors.white),
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'اكتب ملخص المباراة',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            hintText:
                'مثال: مباراة مثيرة شهدت تقدم الفريق الأول في الشوط الأول...',
            hintStyle: GoogleFonts.cairo(color: Colors.white38, fontSize: 12),
            prefixIcon: const Icon(Icons.description, color: Color(0xFF00ff88)),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00ff88)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'فيديو الملخص 🎥',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUploadingFile ? null : _pickFileFromDevice,
                icon: _isUploadingFile
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.upload_file),
                label: Text('رفع من الجهاز', style: GoogleFonts.cairo()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0a4d68),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isUploadingFile ? null : _addVideoUrlDialog,
                icon: const Icon(Icons.link),
                label: Text('إضافة رابط', style: GoogleFonts.cairo()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0a4d68),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        if (_summaryVideoUrl != null) ...[
          const SizedBox(height: 8),
          Card(
            color: const Color(0xFF051622),
            child: ListTile(
              leading: const Icon(
                Icons.video_library,
                color: Color(0xFF00ff88),
              ),
              title: Text(
                _summaryFileName ?? 'فيديو الملخص',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              subtitle: Text(
                _summaryVideoUrl!,
                style: GoogleFonts.cairo(color: Colors.white54, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _summaryVideoUrl = null;
                    _summaryFileName = null;
                  });
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  // إضافة هدف جديد
  void _addGoalDialog() {
    final playerNameController = TextEditingController();
    final minuteController = TextEditingController();
    String selectedTeam = 'home';
    String? goalVideoUrl;
    String? goalVideoFileName;
    bool isUploadingGoalVideo = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF0a4d68),
          title: Text(
            'إضافة هدف ⚽',
            style: GoogleFonts.cairo(color: const Color(0xFF00ff88)),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: playerNameController,
                  autofocus: true,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'اسم اللاعب',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: minuteController,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'الدقيقة',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedTeam,
                  decoration: InputDecoration(
                    labelText: 'الفريق',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  ),
                  dropdownColor: const Color(0xFF051622),
                  style: GoogleFonts.cairo(color: Colors.white),
                  items: [
                    DropdownMenuItem(
                      value: 'home',
                      child: Text(
                        _homeTeamController.text.isEmpty
                            ? 'الفريق الأول'
                            : _homeTeamController.text,
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'away',
                      child: Text(
                        _awayTeamController.text.isEmpty
                            ? 'الفريق الثاني'
                            : _awayTeamController.text,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedTeam = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'فيديو الهدف 🎥',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUploadingGoalVideo
                            ? null
                            : () async {
                                try {
                                  FilePickerResult? result = await FilePicker
                                      .platform
                                      .pickFiles(
                                        type: FileType.video,
                                        allowMultiple: false,
                                      );

                                  if (result != null &&
                                      result.files.single.path != null) {
                                    setDialogState(() {
                                      isUploadingGoalVideo = true;
                                    });

                                    File file = File(result.files.single.path!);
                                    String fileName =
                                        'goal_videos/${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

                                    TaskSnapshot uploadTask =
                                        await FirebaseStorage.instance
                                            .ref(fileName)
                                            .putFile(file);

                                    String downloadUrl = await uploadTask.ref
                                        .getDownloadURL();

                                    setDialogState(() {
                                      goalVideoUrl = downloadUrl;
                                      goalVideoFileName =
                                          result.files.single.name;
                                      isUploadingGoalVideo = false;
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'تم رفع الفيديو بنجاح',
                                            style: GoogleFonts.cairo(),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  setDialogState(() {
                                    isUploadingGoalVideo = false;
                                  });

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'خطأ في رفع الفيديو: $e',
                                          style: GoogleFonts.cairo(),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        icon: isUploadingGoalVideo
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.upload_file, size: 16),
                        label: Text(
                          'رفع',
                          style: GoogleFonts.cairo(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF051622),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isUploadingGoalVideo
                            ? null
                            : () {
                                final urlController = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: const Color(0xFF0a4d68),
                                    title: Text(
                                      'رابط الفيديو',
                                      style: GoogleFonts.cairo(
                                        color: const Color(0xFF00ff88),
                                      ),
                                    ),
                                    content: TextField(
                                      controller: urlController,
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'رابط الفيديو',
                                        labelStyle: GoogleFonts.cairo(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                          'إلغاء',
                                          style: GoogleFonts.cairo(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (urlController.text.isNotEmpty) {
                                            setDialogState(() {
                                              goalVideoUrl = urlController.text;
                                              goalVideoFileName = 'رابط فيديو';
                                            });
                                            Navigator.pop(ctx);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF00ff88,
                                          ),
                                        ),
                                        child: Text(
                                          'إضافة',
                                          style: GoogleFonts.cairo(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                        icon: const Icon(Icons.link, size: 16),
                        label: Text(
                          'رابط',
                          style: GoogleFonts.cairo(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF051622),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (goalVideoUrl != null) ...[
                  const SizedBox(height: 8),
                  Card(
                    color: const Color(0xFF051622),
                    child: ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.video_library,
                        color: Color(0xFF00ff88),
                        size: 20,
                      ),
                      title: Text(
                        goalVideoFileName ?? 'فيديو',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () {
                          setDialogState(() {
                            goalVideoUrl = null;
                            goalVideoFileName = null;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'إلغاء',
                style: GoogleFonts.cairo(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (playerNameController.text.isNotEmpty &&
                    minuteController.text.isNotEmpty) {
                  setState(() {
                    _goals.add(
                      Goal(
                        playerName: playerNameController.text,
                        team: selectedTeam,
                        minute: int.tryParse(minuteController.text) ?? 0,
                        videoUrl: goalVideoUrl,
                      ),
                    );
                  });
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ff88),
              ),
              child: Text(
                'إضافة',
                style: GoogleFonts.cairo(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // رفع ملف من الجهاز
  Future<void> _pickFileFromDevice() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        if (!mounted) return;
        
        setState(() {
          _isUploadingFile = true;
        });

        File file = File(result.files.single.path!);
        String fileName =
            'match_summaries/${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

        // رفع الملف إلى Firebase Storage
        TaskSnapshot uploadTask = await FirebaseStorage.instance
            .ref(fileName)
            .putFile(file);

        // الحصول على رابط التحميل
        String downloadUrl = await uploadTask.ref.getDownloadURL();

        if (mounted) {
          setState(() {
            _summaryVideoUrl = downloadUrl;
            _summaryFileName = result.files.single.name;
            _isUploadingFile = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم رفع الملف بنجاح', style: GoogleFonts.cairo()),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // User cancelled the picker
        if (mounted) {
          setState(() {
            _isUploadingFile = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploadingFile = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في رفع الملف: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // إضافة رابط فيديو
  void _addVideoUrlDialog() {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0a4d68),
        title: Text(
          'إضافة رابط فيديو الملخص',
          style: GoogleFonts.cairo(color: const Color(0xFF00ff88)),
        ),
        content: TextField(
          controller: urlController,
          autofocus: true,
          style: GoogleFonts.cairo(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'رابط الفيديو (YouTube, Vimeo, إلخ)',
            labelStyle: GoogleFonts.cairo(color: Colors.white70),
            hintText: 'https://www.youtube.com/watch?v=...',
            hintStyle: GoogleFonts.cairo(color: Colors.white38),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                setState(() {
                  _summaryVideoUrl = urlController.text;
                  _summaryFileName = 'رابط فيديو خارجي';
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00ff88),
            ),
            child: Text('إضافة', style: GoogleFonts.cairo(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMatch() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final dateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      if (_selectedGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الرجاء اختيار المجموعة', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final match = MatchModel(
        homeTeam: _homeTeamController.text,
        awayTeam: _awayTeamController.text,
        dateTime: dateTime,
        liveStreamUrl: _streamUrlController.text.isEmpty
            ? null
            : _streamUrlController.text,
        isLive: _isLive,
        groupId: _selectedGroup!,
        homeScore: _homeScoreController.text.isEmpty
            ? null
            : int.tryParse(_homeScoreController.text),
        awayScore: _awayScoreController.text.isEmpty
            ? null
            : int.tryParse(_awayScoreController.text),
        streamingPlatforms: _streamingPlatforms,
        commentators: _commentators,
        mainReferee: _mainRefereeController.text.isEmpty
            ? null
            : _mainRefereeController.text,
        firstAssistant: _firstAssistantController.text.isEmpty
            ? null
            : _firstAssistantController.text,
        secondAssistant: _secondAssistantController.text.isEmpty
            ? null
            : _secondAssistantController.text,
        fourthOfficial: _fourthOfficialController.text.isEmpty
            ? null
            : _fourthOfficialController.text,
        matchSummary: _matchSummaryController.text.isEmpty
            ? null
            : _matchSummaryController.text,
        summaryVideoUrl: _summaryVideoUrl,
        goals: _goals,
      );

      // Debug: Print data before saving
      debugPrint('🔍 Saving match with data:');
      debugPrint('  - Goals: ${_goals.length} items');
      debugPrint('  - Streaming Platforms: ${_streamingPlatforms.length} items');
      debugPrint('  - Commentators: ${_commentators.length} items');
      debugPrint('  - Summary Video URL: $_summaryVideoUrl');
      debugPrint('  - Match Summary: ${_matchSummaryController.text}');
      
      final matchMap = match.toMap();
      debugPrint('🔍 Match Map:');
      debugPrint('  - goals in map: ${matchMap['goals']}');
      debugPrint('  - streamingPlatforms in map: ${matchMap['streamingPlatforms']}');
      debugPrint('  - summaryVideoUrl in map: ${matchMap['summaryVideoUrl']}');

      try {
        await _firebaseService.addMatch(match);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إضافة المباراة بنجاح',
                style: GoogleFonts.cairo(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ: $e', style: GoogleFonts.cairo()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _homeTeamController.dispose();
    _awayTeamController.dispose();
    _streamUrlController.dispose();
    _homeScoreController.dispose();
    _awayScoreController.dispose();
    _mainRefereeController.dispose();
    _firstAssistantController.dispose();
    _secondAssistantController.dispose();
    _fourthOfficialController.dispose();
    _matchSummaryController.dispose();
    super.dispose();
  }
}
