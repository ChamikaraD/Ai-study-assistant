import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../settings/screens/settings_screen.dart';
import '../ai/screens/ask_ai_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeContent(),
      const HistoryPlaceholder(),
      const AskAiScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.smart_toy_outlined),
            label: "Ask AI",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// HOME CONTENT
  /// ===============================
  Widget _buildHomeContent() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("AI Study Assistant"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            /// Action Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [

                /// Upload Notes
                DashboardCard(
                  icon: Icons.upload_file_outlined,
                  title: "Upload Notes",
                  subtitle: "Add PDFs",
                  onTap: () {
                    context.push('/upload-notes');
                  },
                ),

                /// Record Lecture
                DashboardCard(
                  icon: Icons.mic_none_outlined,
                  title: "Record Lecture",
                  subtitle: "Capture audio",
                  onTap: () {
                    context.push('/record');
                  },
                ),

                /// View Summaries
                DashboardCard(
                  icon: Icons.description_outlined,
                  title: "View Summaries",
                  subtitle: "AI results",
                  onTap: () {
                    context.push('/summaries');
                  },
                ),

                /// Ask AI
                DashboardCard(
                  icon: Icons.chat_bubble_outline,
                  title: "Ask AI",
                  subtitle: "Study help",
                  onTap: () {
                    context.push('/ask-ai');
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Recent Activities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            const ActivityTile(
              title: "Math Notes Summary",
              subtitle: "Generated 2 hours ago",
              icon: Icons.description,
            ),

            const ActivityTile(
              title: "AI Question Asked",
              subtitle: "Explained recursion",
              icon: Icons.smart_toy,
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// DASHBOARD CARD (Clickable)
/// ===============================
class DashboardCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
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

/// ===============================
/// ACTIVITY TILE
/// ===============================
class ActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ActivityTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}

/// ===============================
/// HISTORY PLACEHOLDER
/// ===============================
class HistoryPlaceholder extends StatelessWidget {
  const HistoryPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("History Screen"),
      ),
    );
  }
}