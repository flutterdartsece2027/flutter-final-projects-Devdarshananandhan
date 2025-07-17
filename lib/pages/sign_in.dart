// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/pages/Dashbard.dart';
import 'package:notevault/themes/theme.dart';
import 'package:notevault/themes/util.dart';
import 'package:notevault/database/supabase_connection.dart';

class SignUp extends StatefulWidget {
  SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController useridController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypepasswordController =
      TextEditingController();

  bool passwordobscure = true;
  bool retypepasswordobscure = true;

  void triggerpassword() {
    setState(() {
      passwordobscure = !passwordobscure;
    });
  }

  void triggerretypepassword() {
    setState(() {
      retypepasswordobscure = !retypepasswordobscure;
    });
  }

  @override
  void dispose() {
    useridController.dispose();
    nameController.dispose();
    passwordController.dispose();
    retypepasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
    MaterialTheme theme = MaterialTheme(textTheme);
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Page")),
      body: Form(
        key: formkey,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SvgPicture.asset(
                'assets/sign_in_${brightness == Brightness.light ? "light" : "dark"}.svg',
                width: 180,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: useridController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "User ID is required";
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                    return "User ID must be numeric";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'User ID',
                  prefixIcon: Icon(HugeIcons.strokeRoundedId),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(HugeIcons.strokeRoundedUser02),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: passwordController,
                obscureText: passwordobscure,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                  suffixIcon: IconButton(
                    onPressed: triggerpassword,
                    icon: Icon(
                      passwordobscure
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: retypepasswordController,
                obscureText: retypepasswordobscure,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please re-enter the password";
                  }
                  if (value.trim() != passwordController.text.trim()) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Re-Type Password',
                  suffixIcon: IconButton(
                    onPressed: triggerretypepassword,
                    icon: Icon(
                      retypepasswordobscure
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOff,
                    ),
                  ),
                  prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    final password = passwordController.text.trim();
                    final userId = useridController.text.trim();
                    final name = nameController.text.trim();
                    GlobalState.userId = int.parse(userId);
                    print('signup_user_id===>>>${userId}');
                    signUpUser(context, userId, name, password);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  foregroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Continue"), Icon(Icons.navigate_next)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
