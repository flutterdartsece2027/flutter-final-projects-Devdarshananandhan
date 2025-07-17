import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/component/menu.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/pages/emptystarecontent.dart';
import 'package:notevault/pages/settings.dart';
import 'package:page_transition/page_transition.dart';

class PrivateFolder extends StatefulWidget {
  const PrivateFolder({super.key});

  @override
  State<PrivateFolder> createState() => _PrivateFolderState();
}

class _PrivateFolderState extends State<PrivateFolder> {
  bool isUnlocked = false;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final TextEditingController passwordController = TextEditingController();
  String correctPassword = "";
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final hasPassword = await checkForPrivateFolderAccess(
        context,
        GlobalState.userId.toString(),
      );

      if (hasPassword) {
        correctPassword = await fetchPrivatePassword(GlobalState.userId.toString());
        _showPasswordDialog();
      } else {
        _showSetPasswordAlert();
      }
    });
  }

  void _loadNotes() async {
    final data = await fetchPrivateNotes(GlobalState.userId.toString());
    setState(() {
      notes = data;
    });
  }

  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(hintText: "Password"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (passwordController.text == correctPassword) {
                  Navigator.of(context).pop();
                  setState(() {
                    isUnlocked = true;
                  });
                  _loadNotes(); // ✅ Load notes from DB after unlocking
                } else {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: 'Incorrect password',
                    backgroundColor: Theme.of(context).colorScheme.onError,
                    gravity: ToastGravity.TOP,
                  );
                }
              },
              child: Text("Unlock"),
            ),
          ],
        );
      },
    );
  }

  void _showSetPasswordAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("No Password Found"),
          content: Text("No private folder password set. Please set one."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: Settings(),
                  ),
                );
              },
              child: Text("Set Password"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUnlocked
        ? Scaffold(
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: notes.isEmpty
                  ? EmptyNotesScreen()
                  : RefreshIndicator(
                    key: _refreshKey,
                    onRefresh: () async => _loadNotes(),
                    child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return _privateNoteCard(note['title'], note['content']);
                        },
                      ),
                  ),
            ),
          )
        : Scaffold(); // Locked state
  }

  // Widget _privateNoteCard(String title, String content) {
  //   return Card(
  //     margin: EdgeInsets.symmetric(vertical: 8),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: ListTile(
  //       title: Text(title),
  //       subtitle: Text(content),
  //       leading: Icon(Icons.lock),
  //       trailing: IconButton(
  //         icon: Icon(HugeIcons.strokeRoundedMoreVerticalCircle01),
  //         onPressed: () {},
  //       ),
  //     ),
  //   );
  // }
  Widget _privateNoteCard(String title, String content) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      title: Text(title),
      subtitle: Text(content),
      leading: Icon(HugeIcons.strokeRoundedSquareLock02),
      trailing: Menu(
        title: title,
        content: content,
        onEdit: (newContent) async {
          await updatePrivateNoteInSupabase(
            GlobalState.userId.toString(),
            title,
            newContent,
          );
          _loadNotes(); // refresh list
        },
        onDelete: () async {
          await deletePrivateNoteFromSupabase(
            GlobalState.userId.toString(),
            title,
          );
          _loadNotes(); // refresh list
        },
      ),
    ),
  );
}

}

