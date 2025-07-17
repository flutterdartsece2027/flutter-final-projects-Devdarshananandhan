import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          SvgPicture.asset("assets/login_image.svg", width: 200),
          SizedBox(height: 16,),
          Text("Welcome to NoteVault", style: Theme.of(context).textTheme.headlineMedium,),
          Text("Notes that follow you", style: Theme.of(context).textTheme.labelMedium,),
          Expanded(child: SizedBox()),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: Text("Sign-in"))),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: Text("Login"))),
        ],
      ),
    );
  }
}