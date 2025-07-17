import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/database/supabase_connection.dart';

class Typecomponent extends StatefulWidget {
  const Typecomponent({super.key});

  @override
  State<Typecomponent> createState() => _TypecomponentState();
}

class _TypecomponentState extends State<Typecomponent> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController contentcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              title: TextFormField(
                controller: titlecontroller,
                style: Theme.of(context).textTheme.titleLarge,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    Fluttertoast.showToast(
                      msg: 'Title is Required',
                      backgroundColor: Theme.of(context).colorScheme.onError,
                      gravity: ToastGravity.TOP,
                    );
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(HugeIcons.strokeRoundedFileValidation),
                  tooltip: 'Save',
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      final title = titlecontroller.text.trim();
                      final content = contentcontroller.text.trim();

                      if (title.isNotEmpty && content.isNotEmpty) {
                        if (GlobalState.selectedindex == 0) {
                          await savefiles(
                            context,
                            GlobalState.userId.toString(),
                            title,
                            content,
                          );
                        } else {
                          await savefilesinprivate(
                            context,
                            GlobalState.userId.toString(),
                            title,
                            content,
                          );
                        }
                      }
                      Navigator.pop(context);

                      print('Saving Note:\nTitle: $title\nContent: $content');
                    }
                  },
                ),
              ],
            ),

            // Content Field
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  controller: contentcontroller,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: Theme.of(context).textTheme.bodyLarge,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      Fluttertoast.showToast(
                        msg: 'Content is Requierd',
                        backgroundColor: Theme.of(context).colorScheme.onError,
                        gravity: ToastGravity.TOP,
                      );
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Start typing your content...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
