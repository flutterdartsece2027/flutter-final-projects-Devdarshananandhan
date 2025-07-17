// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/component/Typecomponent.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/global/globalstate.dart';
// import 'package:notevault/pages/emptystarecontent.dart';
import 'package:notevault/pages/hascontentpage.dart';
import 'package:notevault/pages/private_folder.dart';
import 'package:notevault/pages/profile.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? name;
  int _selectedIndex = 0;
  // late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    initializeDashboard();
  }

  Future<void> initializeDashboard() async {
    final result = await fetchUserNameById(
      context,
      GlobalState.userId.toString(),
    );
    setState(() {
      name = result;
    });
  }

  final _screens = [HasContentPage(), PrivateFolder(), Profile()];

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
      GlobalState.selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If _screens is not yet initialized, show loading
    if (_screens == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? (name == null ? 'Loading...' : 'Welcome, $name')
              : _selectedIndex == 1
              ? 'Private Folder'
              : 'Profile',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedNote05),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedFileLocked),
            label: 'Private',
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedUser02),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Typecomponent()),
                );
                
              },
              child: Icon(HugeIcons.strokeRoundedNoteAdd),
            )
          : null,
    );
  }
}
