import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:notevault/database/supabase_connection.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/pages/Dashbard.dart';
import 'package:notevault/pages/sign_in.dart';
import 'package:page_transition/page_transition.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordobscuretext = true;

  void triggerpassword() {
    setState(() {
      passwordobscuretext = !passwordobscuretext;
    });
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Form(
        key: formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: 40),
            SvgPicture.asset(
              'assets/login_display_${brightness == Brightness.light ? "light" : "dark"}.svg',
              width: 180,
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: idController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your User ID";
                }
                if (!RegExp(r'^\d+$').hasMatch(value)) {
                  return "User ID must be numeric";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "User ID",
                prefixIcon: Icon(HugeIcons.strokeRoundedUser02),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: passwordController,
              obscureText: passwordobscuretext,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your password";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(HugeIcons.strokeRoundedLockPassword),
                suffixIcon: IconButton(
                  onPressed: triggerpassword,
                  icon: Icon(
                    passwordobscuretext
                        ? HugeIcons.strokeRoundedView
                        : HugeIcons.strokeRoundedViewOff,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            Divider(indent: 5, endIndent: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                    );
                  },
                  child: Text("Sign Up", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (formkey.currentState!.validate()) {
                  final userId = idController.text.trim();
                  final password = passwordController.text.trim();
                  GlobalState.userId = int.parse(userId);
                  bool isLoggedIn = await loginUser(context, userId, password);
                  if (isLoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      // MaterialPageRoute(
                      //   builder: (context) => Dashboard(),
                      // ),
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 300),
                        child: Dashboard(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid credentials")),
                    );
                  }
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Continue"), Icon(Icons.navigate_next)],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
