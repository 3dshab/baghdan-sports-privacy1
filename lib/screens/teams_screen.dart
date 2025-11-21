import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/team_model.dart';
import '../models/group_model.dart';
import '../services/firebase_service.dart';

/// صفحة عرض الفرق
class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String? _selectedGroupId;
  bool _showAllGroups = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      appBar: AppBar(
        title: Text(
          'الفرق',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1BA098),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildGroupFilter(),
          Expanded(
            child: _buildTeamsList(),
          ),
        ],
      ),
    );
  }

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
                _buildFilterChip(
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
                      child: _buildFilterChip(
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

  Widget _buildFilterChip({
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

  Widget _buildTeamsList() {
    final stream = _showAllGroups
        ? _firebaseService.getTeams()
        : _firebaseService.getTeamsByGroup(_selectedGroupId!);

    return StreamBuilder<List<TeamModel>>(
      stream: stream,
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
            child: Text(
              'حدث خطأ في تحميل البيانات',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.groups_outlined,
                  size: 80,
                  color: Colors.white24,
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد فرق',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          );
        }

        final teams = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return _buildTeamCard(team, index + 1);
          },
        );
      },
    );
  }

  Widget _buildTeamCard(TeamModel team, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1BA098).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF1BA098).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // الترتيب
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: rank <= 3
                      ? const Color(0xFF8B7E3A)
                      : const Color(0xFF1E5A7D),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // اسم الفريق
              Expanded(
                child: Text(
                  team.name,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // النقاط
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF00ff88),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${team.points} نقطة',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF051622),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('لعب', team.played.toString()),
              _buildStatItem('فوز', team.won.toString(), Colors.green),
              _buildStatItem('تعادل', team.drawn.toString(), Colors.orange),
              _buildStatItem('خسارة', team.lost.toString(), Colors.red),
              _buildStatItem('له', team.goalsFor.toString()),
              _buildStatItem('عليه', team.goalsAgainst.toString()),
              _buildStatItem('الفارق', team.goalDifference.toString(),
                  team.goalDifference >= 0 ? Colors.green : Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, [Color? valueColor]) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
