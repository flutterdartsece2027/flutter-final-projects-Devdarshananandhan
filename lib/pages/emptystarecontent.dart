import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:notevault/themes/theme.dart';
// import 'package:notevault/themes/util.dart';

class EmptyNotesScreen extends StatelessWidget {
  const EmptyNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    // TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
    // MaterialTheme theme = MaterialTheme(textTheme);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/empty_${brightness == Brightness.light ? "light" : "dark"}.svg',
              width: 250,
            ),
            SizedBox(height: 14),
            Text("Standing Still?",style: Theme.of(context).textTheme.titleLarge,),
            Text("Start Taking Notes", style: Theme.of(context).textTheme.labelMedium,)
          ],
        ),
      ),
    );
  }
}
