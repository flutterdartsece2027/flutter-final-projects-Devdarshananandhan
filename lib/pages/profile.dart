import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/component/themechanger.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/pages/settings.dart';
import 'package:page_transition/page_transition.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? userName;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final result = await fetchUserNameById(
      context,
      GlobalState.userId.toString(),
    );
    setState(() {
      userName = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            userName ?? "Loading...",
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 8),

          Text(
            "User ID: ${GlobalState.userId}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: 32),

          ListTile(
            leading: Icon(HugeIcons.strokeRoundedSettings01),
            title: Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.theme,
                  duration: Duration(milliseconds: 300),
                  child: Settings(),
                ),
              );
            },
          ),

          // to change to add theme shifting
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: Text("Toggle Theme"),
            onTap: () {
              showDialog(context: context, builder: (context)=>Themechanger());
            },
          ),

          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              // Add logout logic here (optional)
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
