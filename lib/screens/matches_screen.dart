import 'package:flutter/material.dart';
import '../models/match_summary_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';
import '../widgets/match_card_widget.dart';
import 'match_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

/// صفحة عرض المباريات بشكل احترافي
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _selectedFilter = 'all'; // all, upcoming, completed
  String? _selectedGroupId;
  bool _showAllGroups = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
        title: const Text(
          'المباريات',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Group Filter
          _buildGroupFilter(),
          // Filter Chips
          _buildFilterChips(),
          
          // Matches Grid
          Expanded(
            child: StreamBuilder<List<MatchSummaryModel>>(
              stream: _showAllGroups
                  ? _firebaseService.getMatchSummaries()
                  : _firebaseService.getMatchSummariesByGroup(_selectedGroupId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00ff88),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'حدث خطأ: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sports_soccer,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد مباريات حالياً',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter matches based on selected filter
                List<MatchSummaryModel> filteredMatches = _filterMatches(snapshot.data!);

                if (filteredMatches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_list_off,
                          size: 80,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد مباريات مطابقة للفلتر',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _getCrossAxisCount(context),
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredMatches.length,
                  itemBuilder: (context, index) {
                    final match = filteredMatches[index];
                    return MatchCardWidget(
                      match: match,
                      onTap: () => _navigateToMatchDetail(match),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build group filter
  Widget _buildGroupFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0A2E36),
      child: StreamBuilder<List<GroupModel>>(
        stream: _firebaseService.getGroups(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final groups = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGroupChip(
                  label: 'الكل',
                  isSelected: _showAllGroups,
                  onTap: () {
                    setState(() {
                      _showAllGroups = true;
                      _selectedGroupId = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                ...groups.map((group) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _buildGroupChip(
                        label: group.name,
                        isSelected:
                            !_showAllGroups && _selectedGroupId == group.id,
                        onTap: () {
                          setState(() {
                            _showAllGroups = false;
                            _selectedGroupId = group.id;
                          });
                        },
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build group chip
  Widget _buildGroupChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00ff88)
              : const Color(0xFF051622).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00ff88)
                : const Color(0xFF1BA098).withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? const Color(0xFF051622) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Build filter chips
  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('الكل', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('القادمة', 'upcoming'),
            const SizedBox(width: 8),
            _buildFilterChip('المنتهية', 'completed'),
          ],
        ),
      ),
    );
  }

  /// Build individual filter chip
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1BA098) : const Color(0xFF0A2E36),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF00ff88) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Filter matches based on selected filter
  List<MatchSummaryModel> _filterMatches(List<MatchSummaryModel> matches) {
    final now = DateTime.now();
    
    switch (_selectedFilter) {
      case 'upcoming':
        return matches.where((match) => match.matchDate.isAfter(now)).toList();
      case 'completed':
        return matches.where((match) => match.matchDate.isBefore(now)).toList();
      case 'all':
      default:
        return matches;
    }
  }

  /// Get cross axis count based on screen width
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0A2E36),
        title: const Text(
          'تصفية المباريات',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogOption('الكل', 'all'),
            _buildDialogOption('المباريات القادمة', 'upcoming'),
            _buildDialogOption('المباريات المنتهية', 'completed'),
          ],
        ),
      ),
    );
  }

  /// Build dialog option
  Widget _buildDialogOption(String label, String value) {
    return RadioListTile<String>(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      groupValue: _selectedFilter,
      activeColor: const Color(0xFF00ff88),
      onChanged: (newValue) {
        setState(() {
          _selectedFilter = newValue!;
        });
        Navigator.pop(context);
      },
    );
  }

  /// Navigate to match detail screen
  void _navigateToMatchDetail(MatchSummaryModel match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailScreen(match: match),
      ),
    );
  }
}
