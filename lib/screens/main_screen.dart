import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data.dart';
import 'home_page.dart';
import 'modules_page.dart';
import 'calendar_page.dart';
import 'todo_list_page.dart';
import 'settings_page.dart';

// Global key to access MainScreen state from anywhere
final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

// Made public by removing underscore
class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const HomePage(),
    const ModulesPage(),
    const CalendarPage(),
    TodoListPage(key: todoListPageKey),
  ];

  // Public method to navigate to a specific page
  void navigateToPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 3
            ? Consumer<AppData>(
                builder: (context, appData, _) {
                  return PopupMenuButton<String>(
                    icon: const Icon(Icons.filter_list),
                    onSelected: (value) {
                      print('Popup selected: $value');
                      todoListPageKey.currentState?.setFilter(value);
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'All',
                        child: Text(appData.t('allTasks')),
                      ),
                      PopupMenuItem(
                        value: 'Pending',
                        child: Text(appData.t('pendingOnly')),
                      ),
                      PopupMenuItem(
                        value: 'Completed',
                        child: Text(appData.t('completedOnly')),
                      ),
                      PopupMenuItem(
                        value: 'Overdue',
                        child: Text(appData.t('overdue')),
                      ),
                    ],
                  );
                },
              )
            : null,
        title: Consumer<AppData>(
          builder: (context, appData, _) {
            String pageTitle = appData.t('home');
            if (_selectedIndex == 1) pageTitle = appData.t('myModules');
            if (_selectedIndex == 2) pageTitle = appData.t('calendar');
            if (_selectedIndex == 3) pageTitle = appData.t('toDoList');
            return Text(pageTitle);
          },
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Consumer<AppData>(
        builder: (context, appData, _) {
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: appData.t('home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: appData.t('modules'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today),
                label: appData.t('calendar'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.checklist),
                label: appData.t('toDo'),
              ),
            ],
          );
        },
      ),
    );
  }
}
