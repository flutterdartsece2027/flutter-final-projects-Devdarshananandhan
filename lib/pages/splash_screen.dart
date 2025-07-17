// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notevault/pages/Login_content.dart';
import 'package:notevault/pages/sign_in.dart';
import 'package:notevault/themes/theme.dart';
import 'package:notevault/themes/util.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/login_image_${brightness == Brightness.light ? "light" : "dark"}.svg',
                      width: 200,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Welcome to NoteVault",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Notes that follow you",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => SignUp()),
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 300),
                            child: SignUp(),
                          ),
                        );
                      },
                      label: Text("Sign-Up"),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => Login()),
                          PageTransition(
                            type: PageTransitionType.fade,
                            duration: Duration(milliseconds: 300),
                            child: Login(),
                          ),
                        );
                      },
                      label: Text("Login"),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
