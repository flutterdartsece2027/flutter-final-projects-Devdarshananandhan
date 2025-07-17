import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notevault/component/menu.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:hugeicons/hugeicons.dart';

class HasContentPage extends StatefulWidget {
  const HasContentPage({super.key});

  @override
  State<HasContentPage> createState() => _HasContentPageState();
}

class _HasContentPageState extends State<HasContentPage> {
  List<Map<String, dynamic>> notesList = [];
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchNotes();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _refreshKey.currentState?.show(); // Trigger the spinner programmatically
  });
  }

  void fetchNotes() async {
    final data = await getNotesByUserId(GlobalState.userId.toString());
    setState(() {
      notesList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;

    return Scaffold(
      body: notesList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/empty_${brightness == Brightness.light ? "light" : "dark"}.svg',
                    width: 250,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Standing Still?",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Start Taking Notes",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
            key: _refreshKey,
              onRefresh: () async=> fetchNotes(),
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  final note = notesList[index];
                  final title = note['title'] ?? 'Untitled';
                  final content = note['content'] ?? '';

                  return _noteCard(title, content);
                },
              ),
            ),
    );
  }

  Widget _noteCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(content),
        leading: Icon(HugeIcons.strokeRoundedStickyNote01),
        trailing: Menu(
          title: title,
          content: content,
          onEdit: (newContent) async {
            await updateNoteInSupabase(
              GlobalState.userId.toString(),
              title,
              newContent,
            );
            fetchNotes();
            Fluttertoast.showToast(
              msg: 'Editted Successfully',
              backgroundColor: Colors.lightGreen,
              gravity: ToastGravity.TOP,
            );
          },
          onDelete: () async {
            await deleteNoteFromSupabase(GlobalState.userId.toString(), title);
            fetchNotes();
            Fluttertoast.showToast(
              msg: 'Deleted Successfully',
              backgroundColor: Colors.lightGreen,
              gravity: ToastGravity.TOP,
            );
          },
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:hugeicons/hugeicons.dart';
// import 'package:notevault/component/menu.dart';
// import 'package:notevault/database/supabase_connection.dart';
// import 'package:notevault/global/globalstate.dart';
// // import 'package:notevault/themes/theme.dart';
// // import 'package:notevault/themes/util.dart';

// class HasContentPage extends StatefulWidget {
//    HasContentPage({super.key});

//   @override
//   State<HasContentPage> createState() => _HasContentPageState();
// }

// class _HasContentPageState extends State<HasContentPage> {
//   late Future<List<Map<String, dynamic>>> notes;

//   @override
//   void initState() {
//     super.initState();
//     notes = getNotesByUserId(context, GlobalState.userId.toString());
//   }

//   @override
//   Widget build(BuildContext context) {
//     final brightness = View.of(context).platformDispatcher.platformBrightness;
//     // TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
//     // MaterialTheme theme = MaterialTheme(textTheme);

//     return Scaffold(
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: notes,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("❌ Error loading notes"));
//           }

//           if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     'assets/empty_${brightness == Brightness.light ? "light" : "dark"}.svg',
//                     width: 250,
//                   ),
//                    SizedBox(height: 14),
//                   Text(
//                     "Standing Still?",
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   Text(
//                     "Start Taking Notes",
//                     style: Theme.of(context).textTheme.labelMedium,
//                   ),
//                 ],
//               ),
//             );
//           }

//           final notesList = snapshot.data!;
//           return ListView.builder(
//             itemCount: notesList.length,
//             itemBuilder: (context, index) {
//               final note = notesList[index];

//               return ListTile(
//                 leading: Icon(Icons.note),
//                 title: Text(
//                   note['title'] ?? 'Untitled',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Text(note['content'] ?? 'No content'),
//                 trailing: Menu(
//                   title: note['title'],
//                   content: note['content'],
//                   onEdit: (newTitle, newContent) async {
//                     await updateNoteInSupabase(
//                       note['id'],
//                       newTitle,
//                       newContent,
//                     );
//                     setState(() {}); // Refresh
//                   },
//                   onDelete: () async {
//                     await deleteNoteFromSupabase(note['id']);
//                     setState(() {
//                       notesList.removeAt(index);
//                     });
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

