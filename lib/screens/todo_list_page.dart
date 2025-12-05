// // lib/screens/todo_list_page.dart
// // Complete list of all tasks with filtering options
// // Allows marking tasks as complete and viewing by status

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import '../providers/app_data.dart';
// import '../models/task.dart';
// import '../utils/colors.dart';
// import '../utils/constants.dart';

// class TodoListPage extends StatefulWidget {
//   const TodoListPage({Key? key}) : super(key: key);

//   @override
//   State<TodoListPage> createState() => _TodoListPageState();
// }

// class _TodoListPageState extends State<TodoListPage> {
//   String _filter = 'All';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('To-Do List'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) => setState(() => _filter = value),
//             icon: const Icon(Icons.filter_list),
//             itemBuilder: (context) => [
//               const PopupMenuItem(
//                 value: 'All',
//                 child: Text('All Tasks'),
//               ),
//               const PopupMenuItem(
//                 value: 'Pending',
//                 child: Text('Pending Only'),
//               ),
//               const PopupMenuItem(
//                 value: 'Completed',
//                 child: Text('Completed Only'),
//               ),
//               const PopupMenuItem(
//                 value: 'Overdue',
//                 child: Text('Overdue'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: Consumer<AppData>(
//         builder: (context, app