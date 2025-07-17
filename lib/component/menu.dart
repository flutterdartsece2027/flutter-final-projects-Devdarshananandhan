import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/global/globalstate.dart';

class Menu extends StatefulWidget {
  final String title;
  final String content;
  final Function(String newContent) onEdit;
  final VoidCallback onDelete;

  const Menu({
    super.key,
    required this.title,
    required this.content,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void _showEditDialog() {
    final contentController = TextEditingController(text: widget.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Content'),
        content: TextField(
          controller: contentController,
          decoration: InputDecoration(labelText: 'Content'),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Save'),
            onPressed: () async {
              final newContent = contentController.text.trim();
              if (GlobalState.selectedindex == 0) {
                await updateNoteInSupabase(
                  GlobalState.userId.toString(),
                  widget.title,
                  newContent,
                );
              } else {
                await updatePrivateNoteInSupabase(
                  GlobalState.userId.toString(),
                  widget.title,
                  newContent,
                );
              }
              Navigator.pop(context);
              widget.onEdit(newContent);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(HugeIcons.strokeRoundedMoreVerticalCircle01),
      onSelected: (value) {
        if (value == 'edit') {
          _showEditDialog();
        } else if (value == 'delete') {
          widget.onDelete();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
        PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}
