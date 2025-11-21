import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/match_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

class EditMatchDialog extends StatefulWidget {
  final MatchModel match;

  const EditMatchDialog({super.key, required this.match});

  @override
  State<EditMatchDialog> createState() => _EditMatchDialogState();
}

class _EditMatchDialogState extends State<EditMatchDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _homeTeamController;
  late TextEditingController _awayTeamController;
  late TextEditingController _streamUrlController;
  late TextEditingController _homeScoreController;
  late TextEditingController _awayScoreController;

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedGroup;
  late bool _isLive;
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();
  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _homeTeamController = TextEditingController(text: widget.match.homeTeam);
    _awayTeamController = TextEditingController(text: widget.match.awayTeam);
    _streamUrlController = TextEditingController(
      text: widget.match.liveStreamUrl ?? '',
    );
    _homeScoreController = TextEditingController(
      text: widget.match.homeScore?.toString() ?? '',
    );
    _awayScoreController = TextEditingController(
      text: widget.match.awayScore?.toString() ?? '',
    );

    _selectedDate = widget.match.dateTime;
    _selectedTime = TimeOfDay.fromDateTime(widget.match.dateTime);
    _selectedGroup = widget.match.groupId;
    _isLive = widget.match.isLive;

    _loadGroups();
  }

  Future<void> _loadGroups() async {
    _firebaseService.getGroups().listen((groups) {
      if (mounted) {
        setState(() {
          _groups = groups;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0a4d68),
      title: Text(
        'تعديل المباراة',
        style: GoogleFonts.cairo(
          color: const Color(0xFF00ff88),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
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
                style: GoogleFonts.cairo(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'الفريق الأول',
                  labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                ),
                validator: (v) => v?.isEmpty == true ? 'مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _awayTeamController,
                style: GoogleFonts.cairo(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'الفريق الثاني',
                  labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
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
                style: GoogleFonts.cairo(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'رابط البث المباشر',
                  labelStyle: GoogleFonts.cairo(color: Colors.white70),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
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
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _updateMatch,
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
                  'تحديث',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  Future<void> _updateMatch() async {
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

      final updatedMatch = widget.match.copyWith(
        homeTeam: _homeTeamController.text,
        awayTeam: _awayTeamController.text,
        dateTime: dateTime,
        liveStreamUrl: _streamUrlController.text.isEmpty
            ? null
            : _streamUrlController.text,
        isLive: _isLive,
        groupId: _selectedGroup,
        homeScore: _homeScoreController.text.isEmpty
            ? null
            : int.tryParse(_homeScoreController.text),
        awayScore: _awayScoreController.text.isEmpty
            ? null
            : int.tryParse(_awayScoreController.text),
      );

      try {
        await _firebaseService.updateMatch(updatedMatch);
        
        // مزامنة البيانات مع مجموعة match_summaries إذا كانت المباراة قد انتهت
        if (updatedMatch.isFinished) {
          await _firebaseService.createOrUpdateMatchSummary(updatedMatch);
        }
        
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تحديث المباراة بنجاح',
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
    super.dispose();
  }
}
