import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/app_colors.dart';
import '../ai/screens/chat_detail_screen.dart';
import '../history/screens/summary_detail_screen.dart';
import '../history/screens/view_summaries_screen.dart';
import '../notes/screens/note_detail_screen.dart';
import '../recording/screens/recording_detail_screen.dart';
import '../settings/screens/settings_screen.dart';
import '../ai/screens/ask_ai_screen.dart';
import '../history/screens/study_history_screen.dart';

import '../../services/activity_service.dart';
import '../../models/activity_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const StudyHistoryScreen(),
      const AskAiScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("AI Study Assistant"),
      ),

      body: pages[_currentIndex],

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor:
        AppColors.primary,
        type:
        BottomNavigationBarType
            .fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon:
            Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.smart_toy_outlined),
            label: "Ask AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  /// HOME CONTENT

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome Back 👋",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          /// DASHBOARD GRID

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              DashboardCard(
                icon: Icons
                    .upload_file_outlined,
                title: "Upload Notes",
                subtitle: "Add PDFs",
                onTap: () {
                  context.push(
                      '/upload-notes');
                },
              ),

              DashboardCard(
                icon:
                Icons.mic_none_outlined,
                title:
                "Record Lecture",
                subtitle:
                "Capture audio",
                onTap: () {
                  context.push(
                      '/record');
                },
              ),

              DashboardCard(
                icon: Icons
                    .description_outlined,
                title:
                "View Summaries",
                subtitle:
                "AI results",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const ViewSummariesScreen(),
                    ),
                  );
                },
              ),

              DashboardCard(
                icon: Icons
                    .chat_bubble_outline,
                title: "Ask AI",
                subtitle:
                "Study help",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AskAiScreen(
                        mode:
                        "education",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          /// RECENT HEADER

          Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              const Text(
                "Recent Activities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1; // History tab index
                  });
                },
                child: const Text("View All"),
              )
            ],
          ),

          const SizedBox(height: 16),

          /// RECENT ACTIVITIES

          const RecentActivitiesWidget(),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// DASHBOARD CARD
///////////////////////////////////////////////////////////

class DashboardCard
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary
                .withOpacity(0.2),
          ),
        ),
        padding:
        const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color:
                AppColors.primary),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontWeight:
                FontWeight.w600,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// RECENT ACTIVITIES
///////////////////////////////////////////////////////////

class RecentActivitiesWidget
    extends StatelessWidget {
  const RecentActivitiesWidget(
      {super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityService service =
    ActivityService();

    return StreamBuilder<
        List<ActivityModel>>(
      stream:
      service.streamRecentActivities(),
      builder: (context, snapshot) {
        /// LOADING

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child:
            CircularProgressIndicator(),
          );
        }

        /// ERROR

        if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: const TextStyle(
                color: Colors.red),
          );
        }

        /// EMPTY

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Text(
              "No recent activities");
        }

        final activities =
        snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder:
              (context, index) {
            final activity =
            activities[index];

            return ActivityTile(
              title: activity.title,
              subtitle:
              _timeAgo(
                  activity.createdAt),
              icon:
              _getIcon(activity.type),

              onTap: () {
                _openActivity(
                    context,
                    activity);
              },
            );
          },
        );
      },
    );
  }

  /////////////////////////////////////////////////////////

  void _openActivity(
      BuildContext context,
      ActivityModel activity,
      ) {
    switch (activity.type) {

      case "chat":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ChatDetailScreen(
                  chatId: activity.id,
                ),
          ),
        );
        break;

      case "summary":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SummaryDetailScreen(
                  summaryId: activity.id,
                ),
          ),
        );
        break;

      case "recording":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RecordingDetailScreen(
                  recordingId:
                  activity.id,
                ),
          ),
        );
        break;

      case "note":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                NoteDetailScreen(
                  noteId: activity.id,
                ),
          ),
        );
        break;
    }
  }

  /////////////////////////////////////////////////////////

  IconData _getIcon(String type) {
    switch (type) {
      case "chat":
        return Icons.chat;

      case "summary":
        return Icons.description;

      case "recording":
        return Icons.mic;

      case "note":
        return Icons.upload_file;

      default:
        return Icons.history;
    }
  }

  /////////////////////////////////////////////////////////

  String _timeAgo(
      Timestamp timestamp) {
    final date =
    timestamp.toDate();

    final diff =
    DateTime.now()
        .difference(date);

    if (diff.inMinutes < 60) {
      return "${diff.inMinutes} min ago";
    }

    if (diff.inHours < 24) {
      return "${diff.inHours} hours ago";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    return "${diff.inDays} days ago";
  }
}

///////////////////////////////////////////////////////////
/// ACTIVITY TILE
///////////////////////////////////////////////////////////

class ActivityTile
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(
      BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin:
        const EdgeInsets.only(
            bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primary
                .withOpacity(0.2),
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: AppColors.primary,
          ),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
        ),
      ),
    );
  }
}