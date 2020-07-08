import 'package:flutter/material.dart';
import 'package:just_serve/app/landing_page.dart';
import 'package:just_serve/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (BuildContext context) => Auth(),
      child: MaterialApp(
        title: "Material App Title",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: LandingPage(),
      ),
    );
  }
}
