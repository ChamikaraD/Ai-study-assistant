import 'package:ai_study_assistant/features/notes/screens/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ai/screens/ask_ai_screen.dart';
import '../history/screens/study_history_screen.dart';
import '../settings/screens/settings_screen.dart';

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

  /////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const StudyHistoryScreen(),
      const AskAiScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /////////////////////////////////////////////////////////
  /// BOTTOM NAV

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor:
      const Color(0xFF2563EB),
      type:
      BottomNavigationBarType.fixed,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: "History",
        ),
        BottomNavigationBarItem(
          icon:
          Icon(Icons.smart_toy_outlined),
          label: "Ask AI",
        ),
        BottomNavigationBarItem(
          icon:
          Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////
  /// HOME

  Widget _buildHomeContent() {
    final user =
        FirebaseAuth.instance.currentUser;

    String name =
        user?.email
            ?.split("@")
            .first ??
            "Student";

    return Column(
      children: [
        //////////////////////////////////////////////////////
        /// HEADER

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            20,
            54,
            20,
            18,
          ),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2563EB),
                Color(0xFF1E40AF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// CENTERED APP TITLE

              const Center(
                child: Text(
                  "AI Study Assistant",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// GREETING

              const Text(
                "Welcome Back 👋",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 4),

              /// USER NAME

              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        //////////////////////////////////////////////////////
        /// BODY

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              0, // reduced top space
              20,
              20,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                //////////////////////////////////////////////////
                /// GRID

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisSpacing:
                  16,
                  mainAxisSpacing: 16,
                  children: [
                    _dashboardCard(
                      icon:
                      Icons.upload_file,
                      title:
                      "Upload Notes",
                      subtitle:
                      "Add PDFs",
                      onTap: () {
                        context.push(
                            '/upload-notes');
                      },
                    ),
                    _dashboardCard(
                      icon: Icons.mic,
                      title:
                      "Record Lecture",
                      subtitle:
                      "Capture audio",
                      onTap: () {
                        context.push(
                            '/record');
                      },
                    ),
                    _dashboardCard(
                      icon:
                      Icons.description,
                      title:
                      "View Summaries",
                      subtitle:
                      "AI results",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const SummaryScreen(),
                          ),
                        );
                      },
                    ),
                    _dashboardCard(
                      icon: Icons.chat,
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
                                "education"),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(
                    height: 25),

                //////////////////////////////////////////////////
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
                        FontWeight
                            .bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex =
                          1;
                        });
                      },
                      child:
                      const Text(
                        "View All",
                        style: TextStyle(
                          color: Color(
                              0xFF2563EB),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                    height: 0),

                const RecentActivitiesWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////
  /// CARD

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(
              18),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),
              blurRadius: 10,
              offset:
              const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment
              .center,
          children: [
            Container(
              padding:
              const EdgeInsets.all(
                  14),
              decoration:
              const BoxDecoration(
                color: Color(
                    0xFFEAF0FF),
                shape:
                BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color:
                Color(0xFF2563EB),
              ),
            ),
            const SizedBox(
                height: 14),
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
            const SizedBox(
                height: 6),
            Text(
              subtitle,
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
/// RECENT ACTIVITIES (FIXED + IMPROVED UI)
///////////////////////////////////////////////////////////

class RecentActivitiesWidget extends StatelessWidget {
  const RecentActivitiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivityService service = ActivityService();

    return StreamBuilder<List<ActivityModel>>(
      stream: service.streamRecentActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No recent activities",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          );
        }

        final activities = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];

            return _activityCard(
              context,
              activity,
            );
          },
        );
      },
    );
  }

  ///////////////////////////////////////////////////////////
  /// ACTIVITY CARD

  Widget _activityCard(
      BuildContext context,
      ActivityModel activity,
      ) {
    return InkWell(
      onTap: () {
        _openActivity(context, activity);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            /////////////////////////////////////////////////////
            /// ICON

            Container(
              padding:
              const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                _getIcon(activity.type),
                color:
                const Color(0xFF2563EB),
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            /////////////////////////////////////////////////////
            /// TEXT

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    activity.title,
                    style:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow:
                    TextOverflow
                        .ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    activity.timeAgo,
                    style:
                    const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /////////////////////////////////////////////////////
            /// ARROW

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  /// ICON BY TYPE

  IconData _getIcon(String type) {
    switch (type) {
      case "summary":
        return Icons.description_outlined;

      case "recording":
        return Icons.mic_outlined;

      case "chat":
        return Icons.chat_bubble_outline;

      case "note":
        return Icons.insert_drive_file_outlined;

      default:
        return Icons.history;
    }
  }

  ///////////////////////////////////////////////////////////
  /// NAVIGATION (SAFE)

  void _openActivity(
      BuildContext context,
      ActivityModel activity,
      ) {
    if (activity.type == "summary") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const SummaryScreen(),
        ),
      );
    }

    else if (activity.type == "recording") {
      Navigator.pushNamed(
        context,
        '/record',
      );
    }

    else if (activity.type == "chat") {
      Navigator.pushNamed(
        context,
        '/ask-ai',
      );
    }
  }
}