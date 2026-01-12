import 'package:flutter/material.dart';
import 'features/posts/presentation/pages/post_page.dart';
import 'features/posts/presentation/pages/post_add_update_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // The pages that are actually Tabs
  final List<Widget> _pages = [
    const PostPage(),    // Index 0
    const SizedBox(),    // Index 1 (Placeholder for the 'Plus' button)
    const ProfilePage(), // Index 2
  ];

  void _onTabTapped(int index) {
    if (index == 1) {
      // LOGIC: If the user clicks the middle button (Plus), 
      // don't switch tabs. Instead, open the Create Post page.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PostAddUpdatePage()),
      );
    } else {
      // Standard tab switching
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We only show the body of the selected tab
      body: _currentIndex == 1 
          ? _pages[0] // If "Plus" was clicked, keep showing Feed (optional logic)
          : _pages[_currentIndex],
          
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Keeps buttons stable
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            // We highlight this icon to look like a button
            icon: Icon(Icons.add_circle, size: 40, color: Colors.blueAccent),
            label: '', // No text for the middle button
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}