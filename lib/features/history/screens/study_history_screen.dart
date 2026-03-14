import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudyHistoryPage(),
    );
  }
}

class StudyHistoryPage extends StatelessWidget {
  const StudyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF1FF),

      /// APP BAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          "Study History",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            /// SEARCH BAR
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xff88ABF9)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Study History",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// TABS
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff88ABF9)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  tabButton("All", true),
                  tabButton("Notes", false),
                  tabButton("Recordings", false),
                  tabButton("Summaries", false),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// HISTORY BOX (EMPTY)
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xff88ABF9)),
                ),

                /// EMPTY MESSAGE
                child: const Center(
                  child: Text(
                    "No Study History Yet",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
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

  /// TAB BUTTON
  static Widget tabButton(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffEAF1FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text),
    );
  }
}
