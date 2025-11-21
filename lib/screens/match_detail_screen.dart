import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/match_summary_model.dart';

/// صفحة تفاصيل المباراة مع مشغل الفيديو
class MatchDetailScreen extends StatefulWidget {
  final MatchSummaryModel match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoadingVideo = false;
  String? _videoError;
  String? _currentVideoUrl;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getVideoTabsCount(), vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _switchVideo(_tabController.index);
      }
    });

    // Initialize first available video
    if (_hasAnyVideo()) {
      _initializeFirstVideo();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _initializeFirstVideo() {
    if (widget.match.summaryVideoUrl != null &&
        widget.match.summaryVideoUrl!.isNotEmpty) {
      _initializeVideoPlayer(widget.match.summaryVideoUrl!);
    } else if (widget.match.firstHalfVideoUrl != null &&
        widget.match.firstHalfVideoUrl!.isNotEmpty) {
      _initializeVideoPlayer(widget.match.firstHalfVideoUrl!);
    } else if (widget.match.secondHalfVideoUrl != null &&
        widget.match.secondHalfVideoUrl!.isNotEmpty) {
      _initializeVideoPlayer(widget.match.secondHalfVideoUrl!);
    }
  }

  Future<void> _initializeVideoPlayer(String videoUrl) async {
    if (_currentVideoUrl == videoUrl) return;

    // Dispose previous controllers
    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    setState(() {
      _isLoadingVideo = true;
      _videoError = null;
      _currentVideoUrl = videoUrl;
    });

    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        aspectRatio: 16 / 9,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF00ff88),
          handleColor: const Color(0xFF00ff88),
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade300,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF00ff88)),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'خطأ في تحميل الفيديو',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isLoadingVideo = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVideo = false;
        _videoError = e.toString();
      });
    }
  }

  void _switchVideo(int index) {
    String? videoUrl;

    if (index == 0 && widget.match.summaryVideoUrl != null) {
      videoUrl = widget.match.summaryVideoUrl;
    } else if (index == 1 && widget.match.firstHalfVideoUrl != null) {
      videoUrl = widget.match.firstHalfVideoUrl;
    } else if (index == 2 && widget.match.secondHalfVideoUrl != null) {
      videoUrl = widget.match.secondHalfVideoUrl;
    }

    if (videoUrl != null && videoUrl.isNotEmpty) {
      _initializeVideoPlayer(videoUrl);
    }
  }

  bool _hasAnyVideo() {
    return (widget.match.summaryVideoUrl != null &&
            widget.match.summaryVideoUrl!.isNotEmpty) ||
        (widget.match.firstHalfVideoUrl != null &&
            widget.match.firstHalfVideoUrl!.isNotEmpty) ||
        (widget.match.secondHalfVideoUrl != null &&
            widget.match.secondHalfVideoUrl!.isNotEmpty);
  }

  int _getVideoTabsCount() {
    int count = 0;
    if (widget.match.summaryVideoUrl != null &&
        widget.match.summaryVideoUrl!.isNotEmpty) {
      count++;
    }
    if (widget.match.firstHalfVideoUrl != null &&
        widget.match.firstHalfVideoUrl!.isNotEmpty) {
      count++;
    }
    if (widget.match.secondHalfVideoUrl != null &&
        widget.match.secondHalfVideoUrl!.isNotEmpty) {
      count++;
    }
    return count > 0 ? count : 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051622),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF1BA098),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'تفاصيل المباراة',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF1BA098),
                      const Color(0xFF1BA098).withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.sports_soccer,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Match Info Card
                  _buildMatchInfoCard(),

                  const SizedBox(height: 20),

                  // Video Tabs (Summary, First Half, Second Half)
                  if (_hasAnyVideo()) _buildVideoSection(),

                  const SizedBox(height: 20),

                  // Match Summary Text
                  if (widget.match.matchSummary != null &&
                      widget.match.matchSummary!.isNotEmpty)
                    _buildMatchSummary(),

                  const SizedBox(height: 20),

                  // Goals List
                  if (widget.match.goals.isNotEmpty) _buildGoalsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build match info card
  Widget _buildMatchInfoCard() {
    final dateFormat = DateFormat('EEEE، dd MMMM yyyy', 'ar');
    final timeFormat = DateFormat('hh:mm a', 'ar');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1BA098).withValues(alpha: 0.3),
            const Color(0xFF0A2E36),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00ff88).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Date and Time
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: const Color(0xFF00ff88),
              ),
              const SizedBox(width: 8),
              Text(
                dateFormat.format(widget.match.matchDate),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 16, color: const Color(0xFF00ff88)),
              const SizedBox(width: 8),
              Text(
                timeFormat.format(widget.match.matchDate),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Teams and Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home Team
              Expanded(
                child: _buildTeamColumn(
                  widget.match.homeTeam,
                  widget.match.homeScore,
                ),
              ),

              // Score
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${widget.match.homeScore} - ${widget.match.awayScore}',
                  style: const TextStyle(
                    color: Color(0xFF00ff88),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Away Team
              Expanded(
                child: _buildTeamColumn(
                  widget.match.awayTeam,
                  widget.match.awayScore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build team column
  Widget _buildTeamColumn(String teamName, int score) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF00ff88).withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: const Icon(Icons.shield, color: Color(0xFF00ff88), size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// Build video section with tabs
  Widget _buildVideoSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00ff88).withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Tabs
            Container(
              color: const Color(0xFF0A2E36),
              child: Column(
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.play_circle_filled,
                          color: Color(0xFF00ff88),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'فيديوهات المباراة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF00ff88),
                    labelColor: const Color(0xFF00ff88),
                    unselectedLabelColor: Colors.white60,
                    tabs: _buildVideoTabs(),
                  ),
                ],
              ),
            ),

            // Video Player
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _isLoadingVideo
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00ff88),
                        ),
                      )
                    : _videoError != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'خطأ في تحميل الفيديو',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (_currentVideoUrl != null) {
                                  _initializeVideoPlayer(_currentVideoUrl!);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00ff88),
                              ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _chewieController != null
                    ? Chewie(controller: _chewieController!)
                    : const Center(
                        child: Text(
                          'لا يوجد فيديو متاح',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build video tabs
  List<Widget> _buildVideoTabs() {
    List<Widget> tabs = [];

    if (widget.match.summaryVideoUrl != null &&
        widget.match.summaryVideoUrl!.isNotEmpty) {
      tabs.add(const Tab(icon: Icon(Icons.video_library), text: 'الملخص'));
    }

    if (widget.match.firstHalfVideoUrl != null &&
        widget.match.firstHalfVideoUrl!.isNotEmpty) {
      tabs.add(const Tab(icon: Icon(Icons.looks_one), text: 'الشوط الأول'));
    }

    if (widget.match.secondHalfVideoUrl != null &&
        widget.match.secondHalfVideoUrl!.isNotEmpty) {
      tabs.add(const Tab(icon: Icon(Icons.looks_two), text: 'الشوط الثاني'));
    }

    return tabs;
  }

  /// Build match summary text
  Widget _buildMatchSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2E36),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00ff88).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description, color: Color(0xFF00ff88), size: 24),
              const SizedBox(width: 12),
              const Text(
                'ملخص المباراة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.match.matchSummary!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// Build goals list
  Widget _buildGoalsList() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2E36),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00ff88).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_soccer,
                color: Color(0xFF00ff88),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'الأهداف',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.match.goals.map((goal) => _buildGoalItem(goal)),
        ],
      ),
    );
  }

  /// Build individual goal item
  Widget _buildGoalItem(GoalSummary goal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: goal.team == 'home'
              ? const Color(0xFF00ff88).withValues(alpha: 0.3)
              : Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Minute
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF00ff88).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "${goal.minute}'",
              style: const TextStyle(
                color: Color(0xFF00ff88),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Goal Icon
          Icon(
            Icons.sports_soccer,
            color: goal.team == 'home'
                ? const Color(0xFF00ff88)
                : Colors.orange,
            size: 24,
          ),

          const SizedBox(width: 12),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.playerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  goal.teamName,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),

          // Video Icon
          if (goal.videoUrl != null && goal.videoUrl!.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.play_circle_outline,
                color: Color(0xFF00ff88),
                size: 28,
              ),
              onPressed: () {
                // يمكن إضافة وظيفة لتشغيل فيديو الهدف
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('سيتم إضافة مشغل فيديو الهدف قريباً'),
                    backgroundColor: Color(0xFF1BA098),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
