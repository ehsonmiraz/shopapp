import 'package:flutter/material.dart';
import './providers/products.dart';
import './screens/overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          accentColor: Colors.yellow,
          primarySwatch: Colors.cyan,
        ),
        home: OverviewScreen(),
      ),
    );
  }
}

