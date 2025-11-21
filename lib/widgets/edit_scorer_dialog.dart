import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/scorer_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

class EditScorerDialog extends StatefulWidget {
  final ScorerModel scorer;

  const EditScorerDialog({super.key, required this.scorer});

  @override
  State<EditScorerDialog> createState() => _EditScorerDialogState();
}

class _EditScorerDialogState extends State<EditScorerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _playerNameController;
  late TextEditingController _teamNameController;
  late TextEditingController _goalsController;
  late TextEditingController _playerPhotoController;

  late String _selectedGroup;
  bool _isLoading = false;

  final FirebaseService _firebaseService = FirebaseService();
  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _playerNameController = TextEditingController(
      text: widget.scorer.playerName,
    );
    _teamNameController = TextEditingController(text: widget.scorer.teamName);
    _goalsController = TextEditingController(
      text: widget.scorer.goals.toString(),
    );
    _playerPhotoController = TextEditingController(
      text: widget.scorer.playerPhoto ?? '',
    );
    _selectedGroup = widget.scorer.groupId;

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
  void dispose() {
    _playerNameController.dispose();
    _teamNameController.dispose();
    _goalsController.dispose();
    _playerPhotoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0a4d68),
      title: Text(
        'تعديل الهداف',
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
                TextFormField(
                  controller: _playerNameController,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'اسم اللاعب',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم اللاعب';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _teamNameController,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'اسم الفريق',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم الفريق';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                  controller: _goalsController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'عدد الأهداف',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال عدد الأهداف';
                    }
                    if (int.tryParse(value) == null) {
                      return 'الرجاء إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _playerPhotoController,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.cairo(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'رابط صورة اللاعب (اختياري)',
                    labelStyle: GoogleFonts.cairo(color: Colors.white70),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00ff88)),
                    ),
                  ),
                ),
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
          onPressed: _isLoading ? null : _updateScorer,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00ff88),
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : Text(
                  'حفظ',
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }

  Future<void> _updateScorer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedScorer = widget.scorer.copyWith(
        playerName: _playerNameController.text,
        teamName: _teamNameController.text,
        groupId: _selectedGroup,
        goals: int.parse(_goalsController.text),
        playerPhoto: _playerPhotoController.text.isEmpty
            ? null
            : _playerPhotoController.text,
      );

      await _firebaseService.updateScorer(updatedScorer);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحديث الهداف بنجاح', style: GoogleFonts.cairo()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تحديث الهداف: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
