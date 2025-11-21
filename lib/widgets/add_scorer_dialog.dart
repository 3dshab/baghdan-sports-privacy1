import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/scorer_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

class AddScorerDialog extends StatefulWidget {
  const AddScorerDialog({super.key});

  @override
  State<AddScorerDialog> createState() => _AddScorerDialogState();
}

class _AddScorerDialogState extends State<AddScorerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _playerNameController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _goalsController = TextEditingController(text: '0');
  final _playerPhotoController = TextEditingController();

  String? _selectedGroup;
  bool _isLoading = false;
  File? _selectedImageFile;
  String? _imageFileName;

  final FirebaseService _firebaseService = FirebaseService();
  List<GroupModel> _groups = [];

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
          if (_groups.isNotEmpty && _selectedGroup == null) {
            _selectedGroup = _groups.first.id;
          }
        });
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedImageFile = File(result.files.single.path!);
          _imageFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل اختيار الصورة: $e', style: GoogleFonts.cairo()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        'إضافة هداف جديد',
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
                // Image Upload Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF051622),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF00ff88).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'صورة اللاعب (اختياري)',
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_selectedImageFile != null) ...[
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImageFile!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _imageFileName ?? 'صورة',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(_selectedImageFile!.lengthSync() / 1024).toStringAsFixed(2)} KB',
                                    style: GoogleFonts.cairo(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImageFile = null;
                                  _imageFileName = null;
                                });
                              },
                              icon: const Icon(Icons.close, color: Colors.red),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.image),
                                label: Text(
                                  'اختر صورة',
                                  style: GoogleFonts.cairo(),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00ff88),
                                  foregroundColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('أو', style: GoogleFonts.cairo(color: Colors.white70)),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _playerPhotoController,
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
                          decoration: InputDecoration(
                            labelText: 'رابط الصورة',
                            labelStyle: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white30),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00ff88)),
                            ),
                            isDense: true,
                          ),
                        ),
                      ],
                    ],
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
          onPressed: _isLoading ? null : _saveScorer,
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

  Future<void> _saveScorer() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('الرجاء اختيار المجموعة', style: GoogleFonts.cairo()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? photoUrl;
      
      // رفع الصورة إذا تم اختيارها
      if (_selectedImageFile != null) {
        photoUrl = await _firebaseService.uploadImage(
          imageFile: _selectedImageFile!,
          folder: 'players',
          fileName: _imageFileName ?? 'player.jpg',
        );
      } else if (_playerPhotoController.text.isNotEmpty) {
        photoUrl = _playerPhotoController.text;
      }

      final scorer = ScorerModel(
        playerName: _playerNameController.text,
        teamName: _teamNameController.text,
        groupId: _selectedGroup!,
        goals: int.parse(_goalsController.text),
        playerPhoto: photoUrl,
      );

      await _firebaseService.addScorer(scorer);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم إضافة الهداف بنجاح', style: GoogleFonts.cairo()),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل إضافة الهداف: $e', style: GoogleFonts.cairo()),
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
