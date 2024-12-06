import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sq_lite_application1/contactlist.dart';
import 'package:sq_lite_application1/contactprovider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider
        (create: (_) => ContactProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite CRUD Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ContactListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
