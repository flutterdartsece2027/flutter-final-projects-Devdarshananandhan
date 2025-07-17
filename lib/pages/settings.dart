import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/global/globalstate.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          ListTile(
            // leading: Icon(HugeIcons.strokeRoundedResetPassword),
            title: Text("Set Password for Private Folder"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Set Password"),
                  content: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter password"),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // close dialog
                      },
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final password = passwordController.text.trim();
                        if (password.isNotEmpty) {
                          await setprivatepassword(
                            context,
                            GlobalState.userId.toString(),
                            password,
                          );
                          Fluttertoast.showToast(
                            msg: 'Password set to $password',
                            backgroundColor: Colors.lightGreen,
                            gravity: ToastGravity.TOP,
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text("Save"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text("Reset Password"),
            onTap: () {
              final oldPasswordController = TextEditingController();
              final newPasswordController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Reset Account Password"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: oldPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Old Password"),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "New Password"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final oldPass = oldPasswordController.text.trim();
                        final newPass = newPasswordController.text.trim();

                        if (oldPass.isEmpty || newPass.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "All fields are required",
                          );
                          return;
                        }

                        bool isOldCorrect = await verifyOldPassword(
                          GlobalState.userId.toString(),
                          oldPass,
                        );

                        if (isOldCorrect) {
                          await resetAccountPassword(
                            GlobalState.userId.toString(),
                            newPass,
                          );
                          Fluttertoast.showToast(
                            msg: "Password updated successfully!",
                          );
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Old password is incorrect",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      child: Text("Update"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text("Reset Password for Private Folder"),
            onTap: () {
              final oldPrivateController = TextEditingController();
              final newPrivateController = TextEditingController();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Reset Private Folder Password"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: oldPrivateController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Old Private Password",
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: newPrivateController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "New Private Password",
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final oldPass = oldPrivateController.text.trim();
                        final newPass = newPrivateController.text.trim();

                        if (oldPass.isEmpty || newPass.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "All fields are required",
                          );
                          return;
                        }

                        final isValid = await verifyOldPrivatePassword(
                          GlobalState.userId.toString(),
                          oldPass,
                        );

                        if (isValid) {
                          await updateprivatepassword(
                            context,
                            GlobalState.userId.toString(),
                            newPass,
                          );
                          Fluttertoast.showToast(
                            msg: "Private password updated!",
                          );
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Old private password is incorrect",
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      child: Text("Update"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
