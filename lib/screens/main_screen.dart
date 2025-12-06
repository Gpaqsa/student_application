import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import '../widgets/app_drawer.dart';
import 'home_page.dart';
import 'modules_page.dart';
import 'calendar_page.dart';
import 'todo_list_page.dart';

// Global key to access MainScreen state from anywhere
final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

// Made public by removing underscore
class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    ModulesPage(),
    CalendarPage(),
    TodoListPage(),
  ];

  // Public method to navigate to a specific page
  void navigateToPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appData = Provider.of<AppData>(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        appData: appData,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'To-Do',
          ),
        ],
      ),
    );
  }
}
