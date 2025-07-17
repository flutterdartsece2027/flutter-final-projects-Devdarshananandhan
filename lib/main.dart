// import 'package:flutter/material.dart';
// import 'package:notevault/global/globalstate.dart';
// import 'package:notevault/pages/splash_screen.dart';
// import 'package:notevault/themes/theme.dart';
// import 'package:notevault/themes/util.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// const supabaseUrl = 'https://zvfhroxrrwziscxbjqwg.supabase.co';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2Zmhyb3hycnd6aXNjeGJqcXdnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1MzgwMDMsImV4cCI6MjA2NzExNDAwM30.NAPKQmeAUxwaUImB8OlFCMOPqG1ny-6DnW0vnYqVTMk';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final brightness = View.of(context).platformDispatcher.platformBrightness;
//     TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
//     MaterialTheme theme = MaterialTheme(textTheme);
//     return MaterialApp(
//       theme: theme.light(),
//       darkTheme: theme.dark(),
//       debugShowCheckedModeBanner: false,
      
//       home: SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:notevault/global/globalstate.dart';
import 'package:notevault/pages/splash_screen.dart';
import 'package:notevault/themes/theme.dart';
import 'package:notevault/themes/util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://zvfhroxrrwziscxbjqwg.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp2Zmhyb3hycnd6aXNjeGJqcXdnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1MzgwMDMsImV4cCI6MjA2NzExNDAwM30.NAPKQmeAUxwaUImB8OlFCMOPqG1ny-6DnW0vnYqVTMk';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Open Sans", "Nunito Sans");
    MaterialTheme theme = MaterialTheme(textTheme);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: GlobalState.themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: currentTheme, 
          home: SplashScreen(),
        );
      },
    );
  }
}
