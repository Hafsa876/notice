import 'package:flutter/material.dart';

void main() {
  runApp(const NoticeBoardApp());
}

class NoticeBoardApp extends StatelessWidget {
  const NoticeBoardApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notice Board App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const NoticeBoardScreen(),
    );
  }
}

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({Key? key});

  @override
  _NoticeBoardScreenState createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  List<String> notices = [];
  bool isAdmin = true; // Set to false for Student, true for Admin

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notice Board'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              _printNotices();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notices[index]),
                  trailing: isAdmin
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteNotice(index);
                          },
                        )
                      : null,
                  onTap: isAdmin
                      ? () {
                          _showUpdateNoticeDialog(context, index);
                        }
                      : null,
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'All Notices:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isAdmin ? notices.length : 0, // Only display notices if user is admin
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notices[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                _showAddNoticeDialog(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
      drawer: isAdmin ? _buildAdminDrawer() : null, // Show admin drawer if user is admin
    );
  }

  // Admin drawer
  Drawer _buildAdminDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.brown,
            ),
            child: Text(
              'Admin',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Notice'),
            onTap: () {
              Navigator.of(context).pop();
              _showAddNoticeDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Manage Users'),
            onTap: () {
              // Navigate to the manage users screen
              Navigator.of(context).pop();
              // TODO: Implement the manage users functionality
            },
          ),
          // Add more admin-specific options as needed
        ],
      ),
    );
  }

  void _showAddNoticeDialog(BuildContext context) {
    String newNotice = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Notice'),
          content: TextField(
            onChanged: (value) {
              newNotice = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newNotice.isNotEmpty) {
                  setState(() {
                    notices.add(newNotice);
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateNoticeDialog(BuildContext context, int index) {
    String updatedNotice = notices[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Notice'),
          content: TextField(
            onChanged: (value) {
              updatedNotice = value;
            },
            controller: TextEditingController(text: updatedNotice),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (updatedNotice.isNotEmpty) {
                  setState(() {
                    notices[index] = updatedNotice;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNotice(int index) {
    setState(() {
      notices.removeAt(index);
    });
  }

  void _printNotices() {
    for (String notice in notices) {
      print(notice);
    }
  }
}
